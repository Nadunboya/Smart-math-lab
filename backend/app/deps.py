from dataclasses import dataclass

from fastapi import Header, HTTPException, status

from .supabase_client import supabase_admin


@dataclass
class CurrentUser:
    id: str
    email: str


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
