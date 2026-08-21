-- Global gamified "hearts" (lives): one shared pool per student across all
-- practice, not per-question. Wrong answers alone never cost a heart —
-- only the explicit "reveal the answer" action (POST /api/math-engine/pass)
-- does. Hearts regenerate over time even while the app is closed; the
-- backend computes regeneration lazily on read/write (last_regen_at is the
-- watermark up to which regeneration has been credited) rather than
-- relying on a background job.

create table if not exists public.student_hearts (
    student_id       uuid primary key references auth.users (id) on delete cascade,
    hearts_remaining integer not null default 5 check (hearts_remaining between 0 and 5),
    last_regen_at    timestamptz not null default now()
);

alter table public.student_hearts enable row level security;
