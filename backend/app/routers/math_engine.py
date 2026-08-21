from fastapi import APIRouter, HTTPException, status
from google import genai
from google.genai.errors import APIError

from ..config import settings
from ..schemas import MathEngineAskIn, MathEngineAskOut, MathEngineSource
from ..supabase_client import supabase_admin

router = APIRouter(prefix="/api/math-engine", tags=["math-engine"])

_gemini_client = genai.Client(api_key=settings.gemini_api_key)

_TOP_K = 5

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
    concepts_result = (
        supabase_admin.table("concepts")
        .select("name,description,body,units!inner(grade,name)")
        .eq("units.grade", grade)
        .text_search("search_vector", question, options={"config": "english", "type": "web_search"})
        .limit(_TOP_K)
        .execute()
    )
    notes_result = (
        supabase_admin.table("short_notes")
        .select("content,units!inner(grade,name)")
        .eq("units.grade", grade)
        .text_search("content", question, options={"config": "english", "type": "web_search"})
        .limit(_TOP_K)
        .execute()
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
