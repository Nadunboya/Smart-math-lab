-- SmartMathLab Supabase schema
-- Run this in the Supabase SQL Editor (Project > SQL Editor > New query)
--
-- Prerequisite: enable the Google provider under
-- Authentication > Providers > Google, with your OAuth client id/secret,
-- and add your app's /auth/callback URL as an authorized redirect URI.

create table if not exists public.students (
    id uuid primary key references auth.users (id) on delete cascade,
    email text not null unique,
    student_name text not null,
    grade integer not null check (grade between 6 and 11),
    guardian_name text not null,
    guardian_phone text not null,
    other_phone text,
    address text not null,
    created_at timestamptz not null default now()
);

-- The FastAPI backend talks to this table exclusively with the service_role
-- key, which bypasses RLS. RLS is enabled with no policies so that the
-- anon/authenticated keys (used only for auth, never for direct table
-- access from the frontend) cannot read or write this table at all.
alter table public.students enable row level security;
