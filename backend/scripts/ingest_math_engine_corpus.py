"""Ingest a Math Engine corpus (concepts/*.md + questions/*.json) into Supabase.

The corpus format is produced by a separate authoring process (see
validate.py bundled with the corpus itself), not by this script. This script
only parses it and loads it:

  - concepts/*.md   -> concept_chunks (embedded with Gemini, for RAG grounding)
  - questions/*.json -> questions (the practice question bank)

Usage:
    cd backend
    python scripts/ingest_math_engine_corpus.py /path/to/corpus

Safe to re-run: both tables are upserted by their natural key
(chunk_key / question_id), so re-ingesting the same corpus after an edit
just updates the changed rows.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from google import genai  # noqa: E402
from google.genai import types  # noqa: E402

from app.config import settings  # noqa: E402
from app.supabase_client import supabase_admin  # noqa: E402

FRONTMATTER_RE = re.compile(r"^---\s*\n(.*?)\n---\s*\n", re.DOTALL)
CHUNK_RE = re.compile(r"<!--\s*chunk:([\w-]+)\s*\|([^>]*?)-->(.*?)<!--\s*/chunk\s*-->", re.DOTALL)
HEADING_RE = re.compile(r"^##\s+(.+)$", re.MULTILINE)
GRADE_FROM_UNIT_RE = re.compile(r"^g(\d+)-")

EMBEDDING_MODEL = "gemini-embedding-001"
EMBEDDING_DIMENSIONS = 1536
EMBEDDING_BATCH_SIZE = 20

_gemini_client = genai.Client(api_key=settings.gemini_api_key)


def _parse_frontmatter(text: str) -> tuple[dict[str, str], str]:
    match = FRONTMATTER_RE.match(text)
    if not match:
        raise ValueError("missing frontmatter")

    fields: dict[str, str] = {}
    for line in match.group(1).splitlines():
        if ":" not in line:
            continue
        key, _, value = line.partition(":")
        fields[key.strip()] = value.strip()
    return fields, text[match.end() :]


def _parse_chunk_meta(raw: str) -> dict[str, str]:
    meta: dict[str, str] = {}
    for part in raw.split("|"):
        if ":" not in part:
            continue
        key, _, value = part.partition(":")
        meta[key.strip()] = value.strip()
    return meta


def _embed_texts(texts: list[str]) -> list[list[float]]:
    embeddings: list[list[float]] = []
    for start in range(0, len(texts), EMBEDDING_BATCH_SIZE):
        batch = texts[start : start + EMBEDDING_BATCH_SIZE]
        response = _gemini_client.models.embed_content(
            model=EMBEDDING_MODEL,
            contents=batch,
            config=types.EmbedContentConfig(
                output_dimensionality=EMBEDDING_DIMENSIONS,
                task_type="RETRIEVAL_DOCUMENT",
            ),
        )
        embeddings.extend(embedding.values for embedding in response.embeddings)
    return embeddings


def parse_concept_file(path: Path) -> list[dict]:
    frontmatter, body = _parse_frontmatter(path.read_text())
    if frontmatter.get("retrievable") != "true":
        return []

    unit_id = frontmatter["unit_id"]
    grade = int(frontmatter["grade"])
    unit_name = frontmatter["unit_name"]

    rows = []
    for chunk_key, raw_meta, content in CHUNK_RE.findall(body):
        meta = _parse_chunk_meta(raw_meta)
        heading_match = HEADING_RE.search(content)
        rows.append(
            {
                "chunk_key": f"{unit_id}::{chunk_key}",
                "unit_id": unit_id,
                "grade": grade,
                "unit_name": unit_name,
                "subtopic": meta.get("subtopic"),
                "chunk_type": meta.get("type"),
                "difficulty": meta.get("difficulty"),
                "heading": heading_match.group(1).strip() if heading_match else None,
                "content": content.strip(),
            }
        )
    return rows


def ingest_concepts(concepts_dir: Path) -> int:
    rows: list[dict] = []
    for path in sorted(concepts_dir.glob("*.md")):
        rows.extend(parse_concept_file(path))

    if not rows:
        print("no retrievable concept chunks found")
        return 0

    print(f"embedding {len(rows)} concept chunks...")
    embeddings = _embed_texts([row["content"] for row in rows])
    for row, embedding in zip(rows, embeddings):
        row["embedding"] = embedding

    supabase_admin.table("concept_chunks").upsert(rows, on_conflict="chunk_key").execute()
    print(f"upserted {len(rows)} concept_chunks")
    return len(rows)


def parse_question_file(path: Path) -> list[dict]:
    data = json.loads(path.read_text())
    unit_id = data["unit_id"]
    grade_match = GRADE_FROM_UNIT_RE.match(unit_id)
    if not grade_match:
        raise ValueError(f"cannot infer grade from unit_id {unit_id!r}")
    grade = int(grade_match.group(1))

    rows = []
    for q in data["questions"]:
        rows.append(
            {
                "question_id": q["question_id"],
                "unit_id": unit_id,
                "grade": grade,
                "subtopic": q.get("subtopic"),
                "difficulty": q["difficulty"],
                "objective": q.get("objective"),
                "prompt": q["prompt"],
                "answer": q["answer"],
                "answer_type": q["answer_type"],
                "accepted_variants": q.get("accepted_variants", []),
                "solution_steps": q.get("solution_steps", []),
                "hints": q["hints"],
            }
        )
    return rows


def ingest_questions(questions_dir: Path) -> int:
    rows: list[dict] = []
    for path in sorted(questions_dir.glob("*.json")):
        rows.extend(parse_question_file(path))

    if not rows:
        print("no questions found")
        return 0

    supabase_admin.table("questions").upsert(rows, on_conflict="question_id").execute()
    print(f"upserted {len(rows)} questions")
    return len(rows)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("corpus_dir", type=Path, help="Path to the corpus directory")
    args = parser.parse_args()

    concepts_dir = args.corpus_dir / "concepts"
    questions_dir = args.corpus_dir / "questions"
    if not concepts_dir.is_dir() or not questions_dir.is_dir():
        raise SystemExit(f"expected {concepts_dir} and {questions_dir} to both exist")

    ingest_concepts(concepts_dir)
    ingest_questions(questions_dir)


if __name__ == "__main__":
    main()
