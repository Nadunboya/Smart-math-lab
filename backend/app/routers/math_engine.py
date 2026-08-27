from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends, HTTPException, Query, status
from google import genai
from google.genai.errors import APIError

from ..config import settings
from ..constants import MAX_GRADE, MIN_GRADE
from ..deps import CurrentUser, get_current_user
from ..grading import grade_answer
from ..schemas import (
    AnswerIn,
    AnswerOut,
    HeartsOut,
    MathEngineAskIn,
    MathEngineAskOut,
    MathEngineSource,
    NextQuestionOut,
    PassIn,
    PassOut,
)
from ..supabase_client import execute_with_retry, supabase_admin

router = APIRouter(prefix="/api/math-engine", tags=["math-engine"])

_gemini_client = genai.Client(api_key=settings.gemini_api_key)

_TOP_K = 5
_DIFFICULTY_ORDER = {"easy": 0, "medium": 1, "hard": 2}

# Global "hearts" (lives), shared across all practice — not per-question.
# Burning one is an explicit "reveal the answer" action (POST /pass), never
# an automatic cost of a wrong answer. Regeneration is computed lazily
# whenever hearts are read or burned, rather than via a background job.
_HEART_CAP = 5
_HEART_REFILL_MINUTES = 30


def _get_hearts(student_id: str) -> tuple[int, datetime]:
    """Returns (hearts_remaining, last_regen_at) after settling any regeneration due."""
    result = execute_with_retry(
        lambda: supabase_admin.table("student_hearts").select("*").eq("student_id", student_id).limit(1)
    )
    now = datetime.now(timezone.utc)

    if not result.data:
        execute_with_retry(
            lambda: supabase_admin.table("student_hearts").upsert(
                {"student_id": student_id, "hearts_remaining": _HEART_CAP, "last_regen_at": now.isoformat()}
            )
        )
        return _HEART_CAP, now

    row = result.data[0]
    hearts = row["hearts_remaining"]
    last_regen_at = datetime.fromisoformat(row["last_regen_at"])

    if hearts >= _HEART_CAP:
        return hearts, last_regen_at

    elapsed_minutes = (now - last_regen_at).total_seconds() / 60
    regenerated = int(elapsed_minutes // _HEART_REFILL_MINUTES)
    if regenerated <= 0:
        return hearts, last_regen_at

    hearts = min(_HEART_CAP, hearts + regenerated)
    last_regen_at = now if hearts >= _HEART_CAP else last_regen_at + timedelta(minutes=regenerated * _HEART_REFILL_MINUTES)

    execute_with_retry(
        lambda: supabase_admin.table("student_hearts")
        .update({"hearts_remaining": hearts, "last_regen_at": last_regen_at.isoformat()})
        .eq("student_id", student_id)
    )
    return hearts, last_regen_at


def _next_refill_at(hearts_remaining: int, last_regen_at: datetime) -> datetime | None:
    if hearts_remaining >= _HEART_CAP:
        return None
    return last_regen_at + timedelta(minutes=_HEART_REFILL_MINUTES)


def _burn_heart(student_id: str) -> tuple[int, datetime | None]:
    hearts, last_regen_at = _get_hearts(student_id)
    if hearts <= 0:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail="No hearts left — they refill over time",
        )

    hearts -= 1
    execute_with_retry(
        lambda: supabase_admin.table("student_hearts")
        .update({"hearts_remaining": hearts})
        .eq("student_id", student_id)
    )
    return hearts, _next_refill_at(hearts, last_regen_at)


_MODE_INSTRUCTIONS = {
    "step_by_step": (
        "Walk through the solution one step at a time, explaining the reasoning "
        "behind each step. End with the final answer clearly stated."
    ),
    "hint": (
        "Do NOT give the final answer or the full solution. Give one small nudge "
        "toward the next step, phrased as a question or a suggestion."
    ),
    "concept": (
        "Explain the underlying concept in simple terms a student can understand. "
        "Use an example, but do not solve the student's specific problem for them."
    ),
}


def _retrieve(question: str, grade: int) -> tuple[list[dict], list[MathEngineSource]]:
    concepts_result = execute_with_retry(
        lambda: supabase_admin.table("concepts")
        .select("name,description,body,units!inner(grade,name)")
        .eq("units.grade", grade)
        .text_search("search_vector", question, options={"config": "english", "type": "web_search"})
        .limit(_TOP_K)
    )
    notes_result = execute_with_retry(
        lambda: supabase_admin.table("short_notes")
        .select("content,units!inner(grade,name)")
        .eq("units.grade", grade)
        .text_search("content", question, options={"config": "english", "type": "web_search"})
        .limit(_TOP_K)
    )

    chunks: list[dict] = []
    sources: list[MathEngineSource] = []

    for row in concepts_result.data:
        unit = row["units"]
        chunks.append(
            {
                "kind": "concept",
                "unit": unit["name"],
                "name": row["name"],
                "text": row["body"] or row["description"],
            }
        )
        sources.append(MathEngineSource(unit_name=unit["name"], concept_name=row["name"]))

    for row in notes_result.data:
        unit = row["units"]
        chunks.append(
            {"kind": "short note", "unit": unit["name"], "name": "Short note", "text": row["content"]}
        )

    return chunks, sources


def _build_prompt(question: str, grade: int, mode: str, chunks: list[dict]) -> str:
    if chunks:
        context = "\n\n".join(
            f"[{chunk['kind']} — {chunk['unit']} / {chunk['name']}]\n{chunk['text']}" for chunk in chunks
        )
    else:
        context = (
            "(No matching curriculum content was found for this question. Answer using "
            "general grade-appropriate math knowledge, and mention that this topic may "
            "not be covered in the syllabus yet.)"
        )

    return (
        f"You are a friendly Grade {grade} math tutor for the SmartMathLab app.\n"
        f"{_MODE_INSTRUCTIONS[mode]}\n"
        "Ground your answer in the curriculum content below whenever it's relevant, and "
        "don't contradict it.\n\n"
        f"--- Curriculum content ---\n{context}\n--- End curriculum content ---\n\n"
        f"Student question: {question}"
    )


@router.post("/ask", response_model=MathEngineAskOut)
def ask(payload: MathEngineAskIn) -> MathEngineAskOut:
    chunks, sources = _retrieve(payload.question, payload.grade)
    prompt = _build_prompt(payload.question, payload.grade, payload.mode, chunks)

    try:
        response = _gemini_client.models.generate_content(
            model=settings.gemini_model,
            contents=prompt,
        )
    except APIError as exc:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY, detail="Math engine is unavailable right now"
        ) from exc

    if not response.text:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY, detail="Math engine returned an empty response"
        )

    return MathEngineAskOut(answer=response.text, sources=sources)


@router.get("/hearts", response_model=HeartsOut)
def get_hearts(user: CurrentUser = Depends(get_current_user)) -> HeartsOut:
    hearts, last_regen_at = _get_hearts(user.id)
    return HeartsOut(
        hearts_remaining=hearts,
        hearts_max=_HEART_CAP,
        next_refill_at=_next_refill_at(hearts, last_regen_at),
    )


@router.get("/next-question", response_model=NextQuestionOut)
def next_question(
    grade: int = Query(ge=MIN_GRADE, le=MAX_GRADE),
    unit_id: str | None = None,
    user: CurrentUser = Depends(get_current_user),
) -> NextQuestionOut:
    done_result = execute_with_retry(
        lambda: supabase_admin.table("tutor_sessions")
        .select("question_id")
        .eq("student_id", user.id)
        .or_("solved.eq.true,passed.eq.true")
    )
    done_ids = {row["question_id"] for row in done_result.data}

    def _build_questions_query():
        query = supabase_admin.table("questions").select("*").eq("grade", grade)
        if unit_id:
            query = query.eq("unit_id", unit_id)
        return query

    questions = execute_with_retry(_build_questions_query).data

    candidates = sorted(
        (q for q in questions if q["question_id"] not in done_ids),
        key=lambda q: (_DIFFICULTY_ORDER.get(q["difficulty"], 99), q["question_id"]),
    )
    if not candidates:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No more questions available for this grade/unit",
        )

    return NextQuestionOut(**candidates[0])


@router.post("/answer", response_model=AnswerOut)
def submit_answer(payload: AnswerIn, user: CurrentUser = Depends(get_current_user)) -> AnswerOut:
    question_result = execute_with_retry(
        lambda: supabase_admin.table("questions")
        .select("*")
        .eq("question_id", payload.question_id)
        .limit(1)
    )
    if not question_result.data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Question not found")
    question = question_result.data[0]

    session_result = execute_with_retry(
        lambda: supabase_admin.table("tutor_sessions")
        .select("*")
        .eq("student_id", user.id)
        .eq("question_id", payload.question_id)
        .limit(1)
    )
    session = session_result.data[0] if session_result.data else None
    attempts = (session["attempts"] if session else 0) + 1
    hints_released = session["hints_released"] if session else 0
    solved = session["solved"] if session else False

    correct = grade_answer(question, payload.student_answer)
    solved = solved or correct

    hint = None
    if not correct and hints_released < len(question["hints"]):
        hint = question["hints"][hints_released]
        hints_released += 1

    execute_with_retry(
        lambda: supabase_admin.table("tutor_sessions").upsert(
            {
                "student_id": user.id,
                "unit_id": question["unit_id"],
                "question_id": payload.question_id,
                "attempts": attempts,
                "hints_released": hints_released,
                "solved": solved,
                "updated_at": datetime.now(timezone.utc).isoformat(),
            },
            on_conflict="student_id,question_id",
        )
    )

    return AnswerOut(
        correct=correct,
        attempts=attempts,
        hints_released=hints_released,
        hint=hint,
        solution_steps=question["solution_steps"] if correct else None,
    )


@router.post("/pass", response_model=PassOut)
def pass_question(payload: PassIn, user: CurrentUser = Depends(get_current_user)) -> PassOut:
    question_result = execute_with_retry(
        lambda: supabase_admin.table("questions")
        .select("*")
        .eq("question_id", payload.question_id)
        .limit(1)
    )
    if not question_result.data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Question not found")
    question = question_result.data[0]

    hearts_remaining, next_refill_at = _burn_heart(user.id)

    session_result = execute_with_retry(
        lambda: supabase_admin.table("tutor_sessions")
        .select("*")
        .eq("student_id", user.id)
        .eq("question_id", payload.question_id)
        .limit(1)
    )
    session = session_result.data[0] if session_result.data else None

    execute_with_retry(
        lambda: supabase_admin.table("tutor_sessions").upsert(
            {
                "student_id": user.id,
                "unit_id": question["unit_id"],
                "question_id": payload.question_id,
                "attempts": session["attempts"] if session else 0,
                "hints_released": session["hints_released"] if session else 0,
                "solved": session["solved"] if session else False,
                "passed": True,
                "updated_at": datetime.now(timezone.utc).isoformat(),
            },
            on_conflict="student_id,question_id",
        )
    )

    return PassOut(
        passed=True,
        solution_steps=question["solution_steps"],
        hearts_remaining=hearts_remaining,
        next_refill_at=next_refill_at,
    )
