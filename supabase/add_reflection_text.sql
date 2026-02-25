-- ============================================================
-- Voeg reflection_text kolom toe aan submissions
-- Eenmalig uitvoeren in Supabase SQL Editor
-- ============================================================

ALTER TABLE submissions
  ADD COLUMN IF NOT EXISTS reflection_text TEXT;
