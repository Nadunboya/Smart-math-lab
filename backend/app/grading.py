"""Answer validation for the Math Engine practice loop.

Pure functions, no I/O — kept separate from routers/math_engine.py
specifically so they can be unit tested without Supabase/Gemini
credentials.
"""

import re


def normalize(text: str) -> str:
    return re.sub(r"\s+", " ", text.strip().lower()).rstrip(".")


def grade_answer(question: dict, student_answer: str) -> bool:
    acceptable = {question["answer"], *question.get("accepted_variants", [])}
    normalized_input = normalize(student_answer)

    if normalized_input in {normalize(a) for a in acceptable}:
        return True

    if question["answer_type"] == "numeric":
        try:
            student_value = float(normalized_input)
        except ValueError:
            return False
        for candidate in acceptable:
            try:
                if abs(float(candidate) - student_value) < 1e-9:
                    return True
            except ValueError:
                continue

    return False
