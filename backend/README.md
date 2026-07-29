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
cp .env.example .env   # fill in SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY
```

Run these against your Supabase project (SQL Editor), in order:

1. `supabase_schema.sql` — the `students` table
2. `supabase_content_schema.sql` — the `units` / `concepts` / `short_notes` tables
3. `supabase_seed_grade6.sql` — seeds Grade 6 content (migrated from the
   previous mock data). Grades 7 and up are intentionally left empty —
   insert rows into `units` / `concepts` / `short_notes` with the right
   `grade` once you have that curriculum content ready; no code changes
   needed for a new grade to show up.

Also enable the Google provider under Authentication > Providers, with your
app's `/auth/callback` URL registered as an authorized redirect URI.

## Run

```bash
uvicorn app.main:app --reload --port 8000
```

## Endpoints

- `GET /api/students/me` — returns the signed-in user's profile, or 404 if
  they haven't completed onboarding yet. Requires
  `Authorization: Bearer <supabase-access-token>`.
- `POST /api/students` — creates the signed-in user's profile. Body:
  `student_name`, `grade` (1-13), `guardian_name`, `guardian_phone`,
  `other_phone` (optional), `address`. Requires the same bearer token.
- `GET /api/units?grade=N` — returns all units (with nested concepts and
  short notes) for that grade, ordered for display. No auth required —
  curriculum content is the same for every student in a grade, so this is
  cacheable and shared instead of being fetched per user.
