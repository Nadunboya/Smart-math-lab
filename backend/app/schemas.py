from datetime import datetime
from typing import Literal

from pydantic import BaseModel, Field, field_validator

from .constants import MAX_GRADE, MIN_GRADE


class StudentProfileIn(BaseModel):
    student_name: str = Field(min_length=1, max_length=200)
    grade: int = Field(ge=MIN_GRADE, le=MAX_GRADE)
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
    body: str | None


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
    sort_order: int
    concepts: list[ConceptOut]
    short_notes: list[ShortNoteOut]


class ConceptIn(BaseModel):
    name: str = Field(min_length=1, max_length=200)
    description: str = Field(min_length=1, max_length=2000)
    body: str | None = Field(default=None, max_length=20000)
    sort_order: int = 0


class ShortNoteIn(BaseModel):
    content: str = Field(min_length=1, max_length=2000)
    sort_order: int = 0


class UnitIn(BaseModel):
    grade: int = Field(ge=MIN_GRADE, le=MAX_GRADE)
    name: str = Field(min_length=1, max_length=200)
    sinhala_name: str | None = Field(default=None, max_length=200)
    accent_color: str = Field(default="#5B4FE5", max_length=20)
    icon_key: str = Field(min_length=1, max_length=50)
    description: str = Field(min_length=1, max_length=2000)
    sort_order: int = 0
    concepts: list[ConceptIn] = Field(default_factory=list)
    short_notes: list[ShortNoteIn] = Field(default_factory=list)


class NextQuestionOut(BaseModel):
    question_id: str
    unit_id: str
    subtopic: str | None
    difficulty: str
    prompt: str


class AnswerIn(BaseModel):
    question_id: str = Field(min_length=1, max_length=100)
    student_answer: str = Field(min_length=1, max_length=500)


class AnswerOut(BaseModel):
    correct: bool
    attempts: int
    hints_released: int
    hint: str | None
    solution_steps: list[str] | None


class HeartsOut(BaseModel):
    hearts_remaining: int
    hearts_max: int
    next_refill_at: datetime | None


class PassIn(BaseModel):
    question_id: str = Field(min_length=1, max_length=100)


class PassOut(BaseModel):
    passed: bool
    solution_steps: list[str]
    hearts_remaining: int
    next_refill_at: datetime | None


class MathEngineAskIn(BaseModel):
    question: str = Field(min_length=1, max_length=2000)
    grade: int = Field(ge=MIN_GRADE, le=MAX_GRADE)
    mode: Literal["step_by_step", "hint", "concept"] = "step_by_step"

    @field_validator("question")
    @classmethod
    def not_blank(cls, value: str) -> str:
        stripped = value.strip()
        if not stripped:
            raise ValueError("must not be blank")
        return stripped


class MathEngineSource(BaseModel):
    unit_name: str
    concept_name: str


class MathEngineAskOut(BaseModel):
    answer: str
    sources: list[MathEngineSource]


class TeacherOnboardingIn(BaseModel):
    full_name: str = Field(min_length=1, max_length=200)
    phone: str = Field(min_length=1, max_length=30)
    bio: str | None = Field(default=None, max_length=1000)
    grades: list[int] = Field(min_length=1)

    @field_validator("grades")
    @classmethod
    def grades_in_range(cls, value: list[int]) -> list[int]:
        if any(g < MIN_GRADE or g > MAX_GRADE for g in value):
            raise ValueError(f"grades must be between {MIN_GRADE} and {MAX_GRADE}")
        return sorted(set(value))


class TeacherOut(BaseModel):
    email: str
    full_name: str | None
    phone: str | None
    bio: str | None
    grades: list[int]
    onboarded: bool
