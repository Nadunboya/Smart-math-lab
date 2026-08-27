"""Answer-validation tests for the Math Engine practice loop.

Run from backend/:
    pytest -v tests/test_grading.py
"""

import pytest

from app.grading import grade_answer, normalize


TEXT_QUESTION = {
    "answer": "9, the number of equal parts the whole is divided into",
    "answer_type": "text",
    "accepted_variants": ["9", "nine", "9 the number of equal parts"],
}

NUMERIC_QUESTION = {
    "answer": "23",
    "answer_type": "numeric",
    "accepted_variants": ["23", "twenty three"],
}

FRACTION_QUESTION = {
    "answer": "1/2",
    "answer_type": "text",
    "accepted_variants": ["1/2", "3/6", "one half", "half"],
}


class TestNormalize:
    def test_lowercases(self):
        assert normalize("NINE") == "nine"

    def test_collapses_whitespace(self):
        assert normalize("  9   the number  ") == "9 the number"

    def test_strips_trailing_period(self):
        assert normalize("half.") == "half"


class TestGradeAnswerText:
    @pytest.mark.parametrize(
        "student_answer",
        ["9", "Nine", "  9   the number of equal parts"],
    )
    def test_accepts_known_variants(self, student_answer):
        assert grade_answer(TEXT_QUESTION, student_answer) is True

    def test_rejects_wrong_answer(self):
        assert grade_answer(TEXT_QUESTION, "8") is False

    @pytest.mark.parametrize(
        "student_answer", ["1/2", "Half", "one half"]
    )
    def test_fraction_variants_accepted(self, student_answer):
        assert grade_answer(FRACTION_QUESTION, student_answer) is True

    def test_unlisted_equivalent_fraction_rejected(self):
        # 2/4 == 1/2 mathematically, but exact/variant matching only
        # accepts what the corpus explicitly lists.
        assert grade_answer(FRACTION_QUESTION, "2/4") is False


class TestGradeAnswerNumeric:
    @pytest.mark.parametrize(
        "student_answer",
        ["23", "23.0", " 23 ", "twenty three"],
    )
    def test_accepts_numeric_and_word_variants(self, student_answer):
        assert grade_answer(NUMERIC_QUESTION, student_answer) is True

    def test_rejects_wrong_number(self):
        assert grade_answer(NUMERIC_QUESTION, "24") is False

    def test_rejects_non_numeric_garbage(self):
        assert grade_answer(NUMERIC_QUESTION, "banana") is False
