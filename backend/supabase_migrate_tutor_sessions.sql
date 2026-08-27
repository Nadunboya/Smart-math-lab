-- Fixes tutor_sessions to match the rest of the schema and gives it the
-- constraints the Math Engine practice loop relies on. Run this once, after
-- supabase_questions_schema.sql, against the tutor_sessions table created by
-- the earlier concept_chunks/RAG corpus SQL. Assumes tutor_sessions is still
-- empty (fresh) — this will fail on the type change if it already holds rows
-- with non-uuid student_id values.

-- student_id was `text`; every other per-student table (students.id) is a
-- uuid referencing auth.users, so align it instead of inventing a second id
-- scheme.
alter table public.tutor_sessions
    alter column student_id type uuid using student_id::uuid;

alter table public.tutor_sessions
    add constraint tutor_sessions_student_id_fkey
    foreign key (student_id) references auth.users (id) on delete cascade;

alter table public.tutor_sessions
    add constraint tutor_sessions_question_id_fkey
    foreign key (question_id) references public.questions (question_id);

-- One row per (student, question) — the practice loop upserts this on every
-- answer submission to track attempts/hints_released/solved.
create unique index if not exists tutor_sessions_student_question_idx
    on public.tutor_sessions (student_id, question_id);

alter table public.tutor_sessions enable row level security;
