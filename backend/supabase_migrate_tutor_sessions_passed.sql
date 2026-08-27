-- Gamified "hearts": a student gets one heart per hint on a question
-- (3, matching the corpus's 3 hints per question). Each wrong answer burns
-- a heart; once all are gone, the student can pass instead of being stuck.
-- A passed question is excluded from GET /next-question same as a solved
-- one, but tracked separately so it's never counted as solved.

alter table public.tutor_sessions
    add column if not exists passed boolean not null default false;
