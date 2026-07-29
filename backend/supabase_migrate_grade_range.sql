-- One-time migration: narrows the `grade` check constraint from 1-13 to
-- 6-11 on tables created before this change (you already ran
-- supabase_schema.sql / supabase_content_schema.sql with the old range).
--
-- Fresh installs don't need this — supabase_schema.sql and
-- supabase_content_schema.sql already have the 6-11 constraint baked in.
--
-- If this fails with a constraint violation, it means a row already has a
-- grade outside 6-11 (e.g. test data) — fix or delete that row, then re-run.

do $$
declare
  constraint_name text;
begin
  select conname into constraint_name
  from pg_constraint
  where conrelid = 'public.students'::regclass
    and contype = 'c'
    and pg_get_constraintdef(oid) ilike '%grade%';
  if constraint_name is not null then
    execute format('alter table public.students drop constraint %I', constraint_name);
  end if;
end $$;

alter table public.students add constraint students_grade_check check (grade between 6 and 11);

do $$
declare
  constraint_name text;
begin
  select conname into constraint_name
  from pg_constraint
  where conrelid = 'public.units'::regclass
    and contype = 'c'
    and pg_get_constraintdef(oid) ilike '%grade%';
  if constraint_name is not null then
    execute format('alter table public.units drop constraint %I', constraint_name);
  end if;
end $$;

alter table public.units add constraint units_grade_check check (grade between 6 and 11);
