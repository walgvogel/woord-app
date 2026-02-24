-- ============================================================
-- Storage bucket for audio recordings
-- Run this AFTER schema.sql in Supabase SQL Editor
-- ============================================================

-- Create public bucket
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'recordings',
  'recordings',
  true,
  52428800,  -- 50 MB max per file
  ARRAY['audio/webm', 'audio/mp4', 'audio/mpeg', 'audio/ogg', 'audio/wav']
)
ON CONFLICT (id) DO NOTHING;

-- RLS for storage objects
CREATE POLICY "recordings: authenticated can upload"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'recordings' AND
    (storage.foldername(name))[1] = auth.uid()::text
  );

CREATE POLICY "recordings: public can read"
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'recordings');

CREATE POLICY "recordings: owner can delete"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'recordings' AND
    (storage.foldername(name))[1] = auth.uid()::text
  );
