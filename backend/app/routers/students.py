from fastapi import APIRouter, Depends, HTTPException, status

from ..deps import CurrentUser, get_current_user
from ..schemas import StudentProfileIn, StudentProfileOut
from ..supabase_client import supabase_admin

router = APIRouter(prefix="/api/students", tags=["students"])


@router.get("/me", response_model=StudentProfileOut)
def get_my_profile(user: CurrentUser = Depends(get_current_user)):
    result = (
        supabase_admin.table("students").select("*").eq("id", user.id).limit(1).execute()
    )

    if not result.data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Profile not found")

    return result.data[0]


@router.post("", response_model=StudentProfileOut, status_code=status.HTTP_201_CREATED)
def create_my_profile(
    payload: StudentProfileIn, user: CurrentUser = Depends(get_current_user)
):
    existing = (
        supabase_admin.table("students").select("id").eq("id", user.id).limit(1).execute()
    )
    if existing.data:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Profile already exists")

    row = {
        "id": user.id,
        "email": user.email,
        **payload.model_dump(),
    }

    result = supabase_admin.table("students").insert(row).execute()

    if not result.data:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Could not create profile",
        )

    return result.data[0]
