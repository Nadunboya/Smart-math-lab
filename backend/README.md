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

Run the schema in `supabase_schema.sql` against your Supabase project (SQL
Editor), and enable the Google provider under Authentication > Providers,
with your app's `/auth/callback` URL registered as an authorized redirect URI.

## Run

```bash
uvicorn app.main:app --reload --port 8000
```

## Endpoints

- `GET /api/students/me` — returns the signed-in user's profile, or 404 if
  they haven't completed onboarding yet.
- `POST /api/students` — creates the signed-in user's profile. Body:
  `student_name`, `grade` (1-13), `guardian_name`, `guardian_phone`,
  `other_phone` (optional), `address`.

Both endpoints require `Authorization: Bearer <supabase-access-token>`,
verified against Supabase Auth on every request.
