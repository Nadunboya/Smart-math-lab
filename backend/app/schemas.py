from datetime import datetime

from pydantic import BaseModel, Field, field_validator


class StudentProfileIn(BaseModel):
    student_name: str = Field(min_length=1, max_length=200)
    grade: int = Field(ge=1, le=13)
    guardian_name: str = Field(min_length=1, max_length=200)
    guardian_phone: str = Field(min_length=1, max_length=30)
    other_phone: str | None = Field(default=None, max_length=30)
    address: str = Field(min_length=1, max_length=500)

    @field_validator("student_name", "guardian_name", "guardian_phone", "address")
    @classmethod
    def not_blank(cls, value: str) -> str:
        stripped = value.strip()
        if not stripped:
            raise ValueError("must not be blank")
        return stripped

    @field_validator("other_phone")
    @classmethod
    def blank_to_none(cls, value: str | None) -> str | None:
        if value is None:
            return None
        stripped = value.strip()
        return stripped or None


class StudentProfileOut(BaseModel):
    id: str
    email: str
    student_name: str
    grade: int
    guardian_name: str
    guardian_phone: str
    other_phone: str | None
    address: str
    created_at: datetime


class ConceptOut(BaseModel):
    id: int
    name: str
    description: str


class ShortNoteOut(BaseModel):
    id: int
    content: str


class UnitOut(BaseModel):
    id: int
    grade: int
    name: str
    sinhala_name: str | None
    accent_color: str
    icon_key: str
    description: str
    concepts: list[ConceptOut]
    short_notes: list[ShortNoteOut]
