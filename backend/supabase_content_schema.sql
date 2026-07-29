-- SmartMathLab content schema: units / concepts / short notes
-- Run this in the Supabase SQL Editor, alongside supabase_schema.sql.
--
-- Design notes:
--   * Normalized (not JSONB) so a future teacher/admin UI can edit a single
--     concept or note without rewriting a whole unit's blob.
--   * Content is curriculum data, not per-student data — the FastAPI
--     `GET /api/units` endpoint intentionally does NOT require a Supabase
--     session, so responses can be cached and shared across every student
--     in a grade instead of once per user.
--   * RLS is enabled with no policies, same as students: only the
--     service_role key (used exclusively by the backend) can read/write.
--     Public reads go through the backend's public GET endpoint, not
--     straight to Supabase.

create table if not exists public.units (
    id bigint generated always as identity primary key,
    grade integer not null check (grade between 1 and 13),
    name text not null,
    sinhala_name text,
    accent_color text not null default '#5B4FE5',
    icon_key text not null,
    description text not null,
    sort_order integer not null default 0,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);
create index if not exists units_grade_idx on public.units (grade, sort_order);

create table if not exists public.concepts (
    id bigint generated always as identity primary key,
    unit_id bigint not null references public.units (id) on delete cascade,
    name text not null,
    description text not null,
    sort_order integer not null default 0
);
create index if not exists concepts_unit_id_idx on public.concepts (unit_id, sort_order);

create table if not exists public.short_notes (
    id bigint generated always as identity primary key,
    unit_id bigint not null references public.units (id) on delete cascade,
    content text not null,
    sort_order integer not null default 0
);
create index if not exists short_notes_unit_id_idx on public.short_notes (unit_id, sort_order);

alter table public.units enable row level security;
alter table public.concepts enable row level security;
alter table public.short_notes enable row level security;
