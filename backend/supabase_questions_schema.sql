-- Math Engine practice questions: the question bank the engine poses to
-- students (student answers, engine grades — not the other way around).
-- Run this in the Supabase SQL Editor. Populated by
-- scripts/ingest_math_engine_corpus.py, not hand-authored here.
--
-- Design notes:
--   * question_id is the corpus's own id (e.g. g6-u09-q001) — stable across
--     re-ingests, so upserts by this key are idempotent.
--   * accepted_variants/solution_steps/hints are plain text[] since they're
--     opaque lists rendered as-is, never queried by element.
--   * hints is always exactly 3 entries (enforced by the corpus's own
--     validate.py) — hint N is released after the Nth wrong attempt.
--   * RLS is enabled with no policies, same as every other content table:
--     only the service_role key (used exclusively by the backend) reads
--     this. The public GET /api/math-engine/next-question endpoint never
--     forwards `answer`/`solution_steps`/unreleased `hints` to the client.

create table if not exists public.questions (
    question_id        text primary key,
    unit_id            text not null,
    grade              integer not null check (grade between 6 and 11),
    subtopic           text,
    difficulty         text not null check (difficulty in ('easy', 'medium', 'hard')),
    objective          text,
    prompt             text not null,
    answer             text not null,
    answer_type        text not null check (answer_type in ('text', 'numeric')),
    accepted_variants  text[] not null default '{}',
    solution_steps     text[] not null default '{}',
    hints              text[] not null,
    created_at         timestamptz not null default now()
);

create index if not exists questions_unit_idx on public.questions (unit_id);
create index if not exists questions_grade_idx on public.questions (grade);

alter table public.questions enable row level security;
