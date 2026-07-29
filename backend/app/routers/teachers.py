from fastapi import APIRouter, Depends, HTTPException, status

from ..deps import CurrentUser, get_current_user
from ..schemas import TeacherOnboardingIn, TeacherOut
from ..supabase_client import supabase_admin

router = APIRouter(prefix="/api/teachers", tags=["teachers"])


def _find_invite(email: str) -> dict | None:
    result = (
        supabase_admin.table("teachers").select("*").eq("email", email).limit(1).execute()
    )
    return result.data[0] if result.data else None


@router.get("/lookup", response_model=TeacherOut)
def lookup_invite(user: CurrentUser = Depends(get_current_user)):
    """Tells the auth callback whether this Google account is an invited
    teacher at all (onboarded or not) — invited-but-not-onboarded still
    routes to teacher onboarding rather than the student flow."""
    row = _find_invite(user.email)
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="No teacher invite for this email")
    return row


@router.get("/me", response_model=TeacherOut)
def get_my_teacher_profile(user: CurrentUser = Depends(get_current_user)):
    result = (
        supabase_admin.table("teachers")
        .select("*")
        .eq("id", user.id)
        .eq("onboarded", True)
        .limit(1)
        .execute()
    )
    if not result.data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Not an onboarded teacher")
    return result.data[0]


@router.post("/complete", response_model=TeacherOut)
def complete_teacher_onboarding(
    payload: TeacherOnboardingIn, user: CurrentUser = Depends(get_current_user)
):
    invite = _find_invite(user.email)
    if not invite:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="This email was not invited as a teacher")

    if invite.get("id") and invite["id"] != user.id:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Invite already claimed")

    result = (
        supabase_admin.table("teachers")
        .update(
            {
                "id": user.id,
                "full_name": payload.full_name,
                "phone": payload.phone,
                "bio": payload.bio,
                "grades": payload.grades,
                "onboarded": True,
            }
        )
        .eq("email", user.email)
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Could not complete onboarding"
        )

    return result.data[0]
