# SmartMathLab API

FastAPI backend for SmartMathLab. Handles the post-Google-sign-in onboarding
profile (student/guardian details) and will host the AI-based learning guide
endpoints.

## Setup

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env   # fill in SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, and GEMINI_API_KEY
```

`GEMINI_API_KEY` powers the Math Engine RAG agent (see below) — get a free-tier
key at https://aistudio.google.com/apikey.

Run these against your Supabase project (SQL Editor), in order:

1. `supabase_schema.sql` — the `students` table
2. `supabase_content_schema.sql` — the `units` / `concepts` / `short_notes` tables
3. `supabase_seed_grade6.sql` — seeds 21 real Grade 6 units (with full
   Markdown lesson content per concept), sourced from the official Sri
   Lankan Educational Publications Department textbook (Mathematics Grade
   6, Parts I & II — freely distributed). Safe to re-run: it deletes
   existing Grade 6 units first, then reinserts. Four syllabus chapters are
   intentionally excluded (Circles, Angles, Rectilinear Plane Figures,
   Solids) since their teaching method is hands-on/tool-based and doesn't
   suit a text+diagram e-learning format — those stay in the physical
   classroom. Grades 7 and up are intentionally left empty — insert rows
   into `units` / `concepts` / `short_notes` with the right `grade` once
   you have that curriculum content ready; no code changes needed for a
   new grade to show up.
4. `supabase_teachers_schema.sql` — the `teachers` table.
5. `supabase_migrate_concept_body.sql` — adds the `body` (Markdown lesson
   content) column to `concepts`. Fresh installs don't need this — it's
   already in `supabase_content_schema.sql`.
6. `supabase_migrate_math_engine_search.sql` — adds the full-text search
   column/indexes the `POST /api/math-engine/ask` retrieval step queries
   (see below). Safe to re-run.
7. The `concept_chunks` / `match_concept_chunks` / `tutor_sessions` SQL you
   already have for the pgvector RAG corpus.
8. `supabase_questions_schema.sql` — the `questions` table: the Math
   Engine's practice question bank (engine poses a question, student
   answers). Populated by `scripts/ingest_math_engine_corpus.py`, not
   hand-authored.
9. `supabase_migrate_tutor_sessions.sql` — fixes `tutor_sessions.student_id`
   to `uuid` (matching `auth.users`/`students.id` instead of the `text` it
   was created with) and adds the FKs/unique index the practice loop needs.
   Run this only once, before `tutor_sessions` has any rows.
10. `supabase_migrate_tutor_sessions_passed.sql` — adds `tutor_sessions.passed`,
    set when a student reveals a question's answer instead of solving it
    (see below). Safe to re-run.
11. `supabase_student_hearts_schema.sql` — the `student_hearts` table: one
    global "hearts" pool per student (see below).

### Ingesting a Math Engine corpus

A corpus is a directory of `concepts/*.md` (chunked lesson content with
frontmatter) and `questions/*.json` (the practice question bank), in the
format documented by that corpus's own `validate.py`. Run its `validate.py`
first to catch structural issues before ingesting. Then, with steps 7-8
above already applied:

```bash
python scripts/ingest_math_engine_corpus.py /path/to/corpus
```

This embeds every retrievable concept chunk with Gemini's free-tier
`gemini-embedding-001` (truncated to 1536 dims to match `concept_chunks`)
and upserts both tables by their natural key (`chunk_key` /
`question_id`) — safe to re-run after editing the corpus.

Supported grades are 6-11 (`MIN_GRADE`/`MAX_GRADE` in `app/constants.py`). If
you already ran `supabase_schema.sql` / `supabase_content_schema.sql` before
this range was narrowed from 1-13, also run `supabase_migrate_grade_range.sql`
once to update the existing check constraints — fresh installs don't need it.

Also enable the Google provider under Authentication > Providers, with your
app's `/auth/callback` URL registered as an authorized redirect URI.

### Inviting a teacher

Teacher accounts are invite-only, not self-serve — anyone who signs in with
Google defaults to the student flow unless their email was pre-provisioned:

```sql
insert into public.teachers (email) values ('teacher@example.com');
```

When that email signs in with Google, they're routed to `/teacher/onboarding`
instead of the student onboarding form. Completing it claims the invite
(links their Supabase auth user id) and grants access to `/teacher`, scoped
to whichever grades they entered.

## Run

```bash
uvicorn app.main:app --reload --port 8000
```

## Tests

```bash
pytest -v
```

Currently covers answer validation (`app/grading.py`, used by
`POST /api/math-engine/answer`) — exact/case/whitespace matching,
numeric equivalence, and accepted-variant matching, with the
deliberately-rejected cases (e.g. an unlisted equivalent fraction)
included alongside the accepted ones. No Supabase/Gemini credentials
needed to run it: grading is pure logic with no I/O, kept in its own
module for exactly this reason.

## Endpoints

- `GET /api/students/me` — returns the signed-in user's profile, or 404 if
  they haven't completed onboarding yet. Requires
  `Authorization: Bearer <supabase-access-token>`.
- `POST /api/students` — creates the signed-in user's profile. Body:
  `student_name`, `grade` (6-11), `guardian_name`, `guardian_phone`,
  `other_phone` (optional), `address`. Requires the same bearer token.
- `GET /api/units?grade=N` — returns all units (with nested concepts and
  short notes) for that grade, ordered for display. Each concept includes an
  optional `body` — Markdown lesson content rendered on the student-facing
  "Launch Lab" view, `null` if the teacher hasn't written it yet. No auth
  required — curriculum content is the same for every student in a grade,
  so this is cacheable and shared instead of being fetched per user.
- `GET /api/units/{id}` — a single unit, same shape as above entry. No auth.
- `POST /api/units`, `PUT /api/units/{id}`, `DELETE /api/units/{id}` —
  create/update/delete a unit and its concepts/short notes. Requires a
  bearer token belonging to an onboarded teacher whose `grades` include the
  unit's grade; otherwise 403.
- `GET /api/teachers/lookup` — used by the auth callback to tell whether a
  signed-in email is an invited teacher at all (onboarded or not).
- `POST /api/teachers/complete` — claims a teacher invite and saves
  onboarding details. Body: `full_name`, `phone`, `bio` (optional),
  `grades` (list of ints).
- `GET /api/teachers/me` — the signed-in, onboarded teacher's profile, or
  404.
- `POST /api/math-engine/ask` — the AI Math Engine's RAG agent. Body:
  `question`, `grade` (6-11), `mode` (`step_by_step` | `hint` | `concept`,
  defaults to `step_by_step`). Retrieves the most relevant `concepts` and
  `short_notes` for that grade via Postgres full-text search (no embeddings —
  zero extra cost beyond the free-tier Gemini call), then asks Gemini
  (`GEMINI_MODEL`, default `gemini-2.5-flash`) to answer grounded in that
  content. Returns `answer` plus `sources` (the unit/concept names used as
  context). No auth required — same rationale as `GET /api/units`: the
  curriculum is shared, not per-student. Returns 502 if Gemini is unreachable
  or replies empty.
- `GET /api/math-engine/hearts` — the student's current global "hearts"
  (lives): `hearts_remaining`, `hearts_max` (5), `next_refill_at` (null once
  full). Hearts are shared across all practice, not per-question, and
  regenerate 1 every 30 minutes even while the app is closed — regeneration
  is computed lazily whenever hearts are read or burned (`student_hearts`
  table), not via a background job. Requires a bearer token.
- `GET /api/math-engine/next-question?grade=N&unit_id=` — the practice loop:
  the engine picks a question, not the other way around. Returns the next
  question (from the `questions` table, ingested from a corpus — see above)
  for that grade/unit that this student hasn't solved *or passed* yet,
  ordered easiest first. Never includes `answer`/`solution_steps`/`hints`.
  Requires a bearer token (progress is per-student). 404 once nothing is
  left.
- `POST /api/math-engine/answer` — body: `question_id`, `student_answer`.
  Grades by exact/normalized match against the question's `answer` and
  `accepted_variants` (case/whitespace-insensitive; numeric questions also
  get a float-equality fallback). Upserts `tutor_sessions` (one row per
  student+question) to track `attempts`/`hints_released`/`solved`. On a
  wrong answer, releases the corpus's next pre-written hint — no hearts
  involved, and no LLM call (the corpus already ships exactly 3 hints per
  question, ordered from a conceptual nudge to nearly-there); once solved,
  returns the full `solution_steps` instead. Requires a bearer token.
- `POST /api/math-engine/pass` — body: `question_id`. The gamified escape
  hatch: burns one heart from the student's global pool to reveal a
  question's answer and move on, instead of grinding forever on one they
  can't get. Marks that question `passed` in `tutor_sessions` (excluded from
  future `next-question` calls, same as solved) and returns
  `solution_steps` plus the updated `hearts_remaining`/`next_refill_at`.
  429 if there are no hearts left to burn. Requires a bearer token.
