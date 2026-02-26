-- ============================================================
-- Storage bucket for audio recordings
-- Run this AFTER schema.sql in Supabase SQL Editor
-- ============================================================

-- Create PRIVATE bucket (not public — use signed URLs)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'recordings',
  'recordings',
  false,
  52428800,  -- 50 MB max per file
  ARRAY['audio/webm', 'audio/mp4', 'audio/mpeg', 'audio/ogg', 'audio/wav']
)
ON CONFLICT (id) DO UPDATE
  SET public = false;

-- Drop old policies if they exist
DROP POLICY IF EXISTS "recordings: authenticated can upload" ON storage.objects;
DROP POLICY IF EXISTS "recordings: public can read" ON storage.objects;
DROP POLICY IF EXISTS "recordings: owner can delete" ON storage.objects;
DROP POLICY IF EXISTS "recordings: owner can read" ON storage.objects;
DROP POLICY IF EXISTS "recordings: teacher can read class students" ON storage.objects;

-- Upload: student can upload to own folder
CREATE POLICY "recordings: authenticated can upload"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'recordings' AND
    (storage.foldername(name))[1] = auth.uid()::text
  );

-- Read: student can read own recordings
CREATE POLICY "recordings: owner can read"
  ON storage.objects FOR SELECT
  TO authenticated
  USING (
    bucket_id = 'recordings' AND
    (storage.foldername(name))[1] = auth.uid()::text
  );

-- Read: teacher can read recordings of students in their classes
CREATE POLICY "recordings: teacher can read class students"
  ON storage.objects FOR SELECT
  TO authenticated
  USING (
    bucket_id = 'recordings' AND
    EXISTS (
      SELECT 1 FROM class_memberships cm
      JOIN classes c ON c.id = cm.class_id
      WHERE cm.student_id = (storage.foldername(name))[1]::uuid
        AND c.teacher_id = auth.uid()
    )
  );

-- Delete: student can delete own recordings
CREATE POLICY "recordings: owner can delete"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'recordings' AND
    (storage.foldername(name))[1] = auth.uid()::text
  );
