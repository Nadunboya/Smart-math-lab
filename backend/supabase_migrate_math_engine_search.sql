-- Math Engine RAG retrieval: full-text search over curriculum content.
-- Run this in the Supabase SQL Editor after supabase_content_schema.sql.
--
-- Design notes:
--   * concepts gets a generated tsvector column combining name/description/body
--     (weighted A/B/C) so a single text_search() call can match across all three.
--   * short_notes is searched directly on `content` via an expression index —
--     PostgREST's fts filter runs to_tsvector('english', content) on the fly,
--     which this index matches.

alter table public.concepts
    add column if not exists search_vector tsvector
    generated always as (
        setweight(to_tsvector('english', coalesce(name, '')), 'A') ||
        setweight(to_tsvector('english', coalesce(description, '')), 'B') ||
        setweight(to_tsvector('english', coalesce(body, '')), 'C')
    ) stored;

create index if not exists concepts_search_vector_idx
    on public.concepts using gin (search_vector);

create index if not exists short_notes_content_fts_idx
    on public.short_notes using gin (to_tsvector('english', content));
