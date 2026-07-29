-- Teacher accounts: invite-only, not self-serve.
--
-- A teacher never signs themselves up. You (the admin) pre-provision a row
-- here with just their email *before* they ever sign in:
--
--   insert into public.teachers (email) values ('teacher@example.com');
--
-- When that email signs in with Google, the backend recognizes it as an
-- invited teacher (by email, since `id` is still null) and sends them to
-- teacher onboarding instead of student onboarding. Completing onboarding
-- claims the invite by filling in `id` (their Supabase auth user id) and
-- setting onboarded = true. Any other Google account falls back to the
-- normal student flow — there's no self-serve path to becoming a teacher.
create table if not exists public.teachers (
    email text primary key,
    id uuid unique references auth.users (id) on delete set null,
    full_name text,
    phone text,
    bio text,
    grades integer[] not null default '{}'
        check (grades <@ '{6,7,8,9,10,11}'::integer[]),
    onboarded boolean not null default false,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);
create index if not exists teachers_id_idx on public.teachers (id);

-- Same pattern as students/units: only the backend's service_role key
-- reads/writes this table.
alter table public.teachers enable row level security;
