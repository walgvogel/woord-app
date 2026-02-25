-- ============================================================
-- Migratie: eigen teksten per klas voor leerkrachten
-- Run in Supabase SQL Editor
-- ============================================================

-- 1. lesson_id nullable maken (class exercises hebben geen les)
ALTER TABLE exercises ALTER COLUMN lesson_id DROP NOT NULL;

-- 2. class_id + created_by + created_at toevoegen
ALTER TABLE exercises
  ADD COLUMN IF NOT EXISTS class_id   UUID REFERENCES classes(id) ON DELETE CASCADE,
  ADD COLUMN IF NOT EXISTS created_by UUID REFERENCES profiles(id),
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW();

-- 3. Oude publieke-read policy vervangen
DROP POLICY IF EXISTS "exercises: public read" ON exercises;

-- Globale oefeningen (uit curriculum, class_id IS NULL): zichtbaar voor iedereen
CREATE POLICY "exercises: global read"
  ON exercises FOR SELECT
  USING (class_id IS NULL);

-- Klas-oefeningen: zichtbaar voor klasleden en de leerkracht van die klas
CREATE POLICY "exercises: class read"
  ON exercises FOR SELECT
  USING (
    class_id IS NOT NULL AND (
      EXISTS (
        SELECT 1 FROM class_memberships cm
        WHERE cm.class_id = exercises.class_id
          AND cm.student_id = auth.uid()
      )
      OR EXISTS (
        SELECT 1 FROM classes c
        WHERE c.id = exercises.class_id
          AND c.teacher_id = auth.uid()
      )
    )
  );

-- Leerkracht kan eigen klas-oefeningen aanmaken
CREATE POLICY "exercises: teacher insert"
  ON exercises FOR INSERT
  WITH CHECK (
    class_id IS NOT NULL AND
    created_by = auth.uid() AND
    EXISTS (
      SELECT 1 FROM classes c
      WHERE c.id = exercises.class_id
        AND c.teacher_id = auth.uid()
    )
  );

-- Leerkracht kan eigen klas-oefeningen bewerken
CREATE POLICY "exercises: teacher update"
  ON exercises FOR UPDATE
  USING (created_by = auth.uid() AND class_id IS NOT NULL);

-- Leerkracht kan eigen klas-oefeningen verwijderen
CREATE POLICY "exercises: teacher delete"
  ON exercises FOR DELETE
  USING (created_by = auth.uid() AND class_id IS NOT NULL);
