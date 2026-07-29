-- Adds the "Launch Lab" content field: a Markdown lesson body per concept,
-- authored by teachers, shown to students on the concept detail view.
--
-- Fresh installs don't need this — supabase_content_schema.sql already
-- includes the column.

alter table public.concepts add column if not exists body text;
