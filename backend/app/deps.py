from dataclasses import dataclass

from fastapi import Depends, Header, HTTPException, status

from .supabase_client import supabase_admin


@dataclass
class CurrentUser:
    id: str
    email: str


@dataclass
class CurrentTeacher:
    email: str
    full_name: str | None
    grades: list[int]


def get_current_user(authorization: str | None = Header(default=None)) -> CurrentUser:
    if not authorization or not authorization.lower().startswith("bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing or malformed Authorization header",
        )

    token = authorization.split(" ", 1)[1]

    try:
        user = supabase_admin.auth.get_user(token).user
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired session",
        ) from exc

    if not user or not user.email:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired session",
        )

    return CurrentUser(id=user.id, email=user.email)


def get_current_teacher(user: CurrentUser = Depends(get_current_user)) -> CurrentTeacher:
    result = (
        supabase_admin.table("teachers")
        .select("*")
        .eq("id", user.id)
        .eq("onboarded", True)
        .limit(1)
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not an onboarded teacher account",
        )

    row = result.data[0]
    return CurrentTeacher(email=row["email"], full_name=row["full_name"], grades=row["grades"])


def require_grade_access(grade: int, teacher: CurrentTeacher) -> None:
    if grade not in teacher.grades:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=f"You are not assigned to grade {grade}",
        )
