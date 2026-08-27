from collections import defaultdict
from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, Query, status

from ..constants import MAX_GRADE, MIN_GRADE
from ..deps import (
    CurrentTeacher,
    CurrentUser,
    get_current_teacher,
    get_current_user,
    require_grade_access,
)
from ..schemas import StudentProgressOut, TeacherOnboardingIn, TeacherOut
from ..supabase_client import execute_with_retry, supabase_admin

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


def _parse_ts(value: str) -> datetime:
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


@router.get("/progress", response_model=list[StudentProgressOut])
def get_student_progress(
    grade: int = Query(ge=MIN_GRADE, le=MAX_GRADE),
    teacher: CurrentTeacher = Depends(get_current_teacher),
) -> list[StudentProgressOut]:
    """Basic per-student progress for a grade: how many of that grade's Math
    Engine questions each student has solved, passed (revealed instead of
    solving), or attempted at all. Teacher-only, scoped to their own grades."""
    require_grade_access(grade, teacher)

    students_result = execute_with_retry(
        lambda: supabase_admin.table("students").select("id,student_name,grade").eq("grade", grade)
    )
    students = students_result.data
    if not students:
        return []

    student_ids = [s["id"] for s in students]

    questions_count_result = execute_with_retry(
        lambda: supabase_admin.table("questions")
        .select("question_id", count="exact")
        .eq("grade", grade)
        .limit(1)
    )
    questions_total = questions_count_result.count or 0

    sessions_result = execute_with_retry(
        lambda: supabase_admin.table("tutor_sessions")
        .select("student_id,solved,passed,updated_at")
        .in_("student_id", student_ids)
    )

    sessions_by_student: dict[str, list[dict]] = defaultdict(list)
    for row in sessions_result.data:
        sessions_by_student[row["student_id"]].append(row)

    progress = []
    for student in students:
        rows = sessions_by_student.get(student["id"], [])
        solved = sum(1 for r in rows if r["solved"])
        passed = sum(1 for r in rows if r["passed"] and not r["solved"])
        last_activity_at = max((_parse_ts(r["updated_at"]) for r in rows), default=None)

        progress.append(
            StudentProgressOut(
                student_id=student["id"],
                student_name=student["student_name"],
                grade=student["grade"],
                questions_total=questions_total,
                questions_solved=solved,
                questions_passed=passed,
                questions_attempted=len(rows),
                last_activity_at=last_activity_at,
            )
        )

    progress.sort(key=lambda p: p.student_name)
    return progress
