-- ============================================================
-- Audio Woord – Supabase Schema
-- Run this in the Supabase SQL Editor (Dashboard → SQL Editor)
-- ============================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- TABLES
-- ============================================================

-- Profiles (extends auth.users)
CREATE TABLE IF NOT EXISTS profiles (
  id          UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  role        TEXT NOT NULL CHECK (role IN ('student', 'teacher')),
  display_name TEXT,
  avatar_url  TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Classes
CREATE TABLE IF NOT EXISTS classes (
  id          UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name        TEXT NOT NULL,
  teacher_id  UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  join_code   TEXT UNIQUE NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Class memberships
CREATE TABLE IF NOT EXISTS class_memberships (
  class_id    UUID REFERENCES classes(id) ON DELETE CASCADE NOT NULL,
  student_id  UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  joined_at   TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (class_id, student_id)
);

-- Modules (seeded from cursus)
CREATE TABLE IF NOT EXISTS modules (
  id      UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  slug    TEXT UNIQUE NOT NULL,
  title   TEXT NOT NULL,
  icon    TEXT,
  "order" INTEGER NOT NULL
);

-- Lessons
CREATE TABLE IF NOT EXISTS lessons (
  id          UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  module_id   UUID REFERENCES modules(id) ON DELETE CASCADE NOT NULL,
  slug        TEXT NOT NULL,
  title       TEXT NOT NULL,
  content     TEXT,  -- Markdown
  "order"     INTEGER NOT NULL,
  UNIQUE (module_id, slug)
);

-- Exercises (lesson_id nullable: class exercises have no lesson)
CREATE TABLE IF NOT EXISTS exercises (
  id           UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  lesson_id    UUID REFERENCES lessons(id) ON DELETE CASCADE,
  title        TEXT NOT NULL,
  type         TEXT NOT NULL CHECK (type IN ('recording', 'reading', 'self_assessment')),
  instructions TEXT,
  "order"      INTEGER NOT NULL,
  class_id     UUID REFERENCES classes(id) ON DELETE CASCADE,
  created_by   UUID REFERENCES profiles(id),
  created_at   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (lesson_id, title)  -- enables upsert for curriculum exercises
);

-- Submissions
CREATE TABLE IF NOT EXISTS submissions (
  id             UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  exercise_id    UUID REFERENCES exercises(id) ON DELETE CASCADE NOT NULL,
  student_id     UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  attempt_number INTEGER NOT NULL DEFAULT 1,
  audio_url      TEXT,
  self_score     INTEGER CHECK (self_score >= 0 AND self_score <= 5),
  reflection_text TEXT,
  completed_at   TIMESTAMPTZ DEFAULT NOW()
);

-- Feedback
CREATE TABLE IF NOT EXISTS feedback (
  id            UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  submission_id UUID REFERENCES submissions(id) ON DELETE CASCADE NOT NULL,
  teacher_id    UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  text          TEXT NOT NULL,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- Badges
CREATE TABLE IF NOT EXISTS badges (
  id          UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  slug        TEXT UNIQUE NOT NULL,
  name        TEXT NOT NULL,
  description TEXT,
  icon_emoji  TEXT
);

-- Student badges (earned)
CREATE TABLE IF NOT EXISTS student_badges (
  student_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  badge_id   UUID REFERENCES badges(id) ON DELETE CASCADE NOT NULL,
  earned_at  TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (student_id, badge_id)
);

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_submissions_student   ON submissions(student_id);
CREATE INDEX IF NOT EXISTS idx_submissions_exercise  ON submissions(exercise_id);
CREATE INDEX IF NOT EXISTS idx_lessons_module        ON lessons(module_id);
CREATE INDEX IF NOT EXISTS idx_exercises_lesson      ON exercises(lesson_id);
CREATE INDEX IF NOT EXISTS idx_exercises_class       ON exercises(class_id);
CREATE INDEX IF NOT EXISTS idx_class_memberships_student ON class_memberships(student_id);
CREATE INDEX IF NOT EXISTS idx_feedback_submission   ON feedback(submission_id);

-- ============================================================
-- STORAGE BUCKET
-- ============================================================

-- Create storage bucket for recordings (run via Supabase Dashboard or this SQL)
-- INSERT INTO storage.buckets (id, name, public)
-- VALUES ('recordings', 'recordings', true)
-- ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE profiles          ENABLE ROW LEVEL SECURITY;
ALTER TABLE classes            ENABLE ROW LEVEL SECURITY;
ALTER TABLE class_memberships  ENABLE ROW LEVEL SECURITY;
ALTER TABLE modules            ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons            ENABLE ROW LEVEL SECURITY;
ALTER TABLE exercises          ENABLE ROW LEVEL SECURITY;
ALTER TABLE submissions        ENABLE ROW LEVEL SECURITY;
ALTER TABLE feedback           ENABLE ROW LEVEL SECURITY;
ALTER TABLE badges             ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_badges     ENABLE ROW LEVEL SECURITY;

-- profiles: read own, update own
CREATE POLICY "profiles: read own"
  ON profiles FOR SELECT USING (auth.uid() = id);

CREATE POLICY "profiles: insert own"
  ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "profiles: update own"
  ON profiles FOR UPDATE USING (auth.uid() = id);

-- Teachers need to read student profiles in their classes
CREATE POLICY "profiles: teacher reads class members"
  ON profiles FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM class_memberships cm
      JOIN classes c ON c.id = cm.class_id
      WHERE cm.student_id = profiles.id
        AND c.teacher_id = auth.uid()
    )
  );

-- classes: teacher CRUD own, student reads joined
CREATE POLICY "classes: teacher CRUD own"
  ON classes FOR ALL USING (teacher_id = auth.uid());

CREATE POLICY "classes: student reads joined"
  ON classes FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM class_memberships
      WHERE class_id = classes.id AND student_id = auth.uid()
    )
  );

-- classes: anyone can read by join_code (to join)
CREATE POLICY "classes: read by join_code"
  ON classes FOR SELECT USING (true);

-- class_memberships: student inserts/reads own, teacher reads for own classes
CREATE POLICY "memberships: student reads own"
  ON class_memberships FOR SELECT USING (student_id = auth.uid());

CREATE POLICY "memberships: student inserts own"
  ON class_memberships FOR INSERT WITH CHECK (student_id = auth.uid());

CREATE POLICY "memberships: teacher reads own class"
  ON class_memberships FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM classes WHERE id = class_memberships.class_id
        AND teacher_id = auth.uid()
    )
  );

-- modules, lessons: public read (curriculum)
CREATE POLICY "modules: public read"   ON modules    FOR SELECT USING (true);
CREATE POLICY "lessons: public read"   ON lessons    FOR SELECT USING (true);

-- exercises: curriculum (no class_id) is public, class exercises scoped to members
CREATE POLICY "exercises: global read" ON exercises
  FOR SELECT USING (class_id IS NULL);

CREATE POLICY "exercises: class read" ON exercises
  FOR SELECT USING (
    class_id IS NOT NULL AND (
      EXISTS (SELECT 1 FROM class_memberships cm WHERE cm.class_id = exercises.class_id AND cm.student_id = auth.uid())
      OR EXISTS (SELECT 1 FROM classes c WHERE c.id = exercises.class_id AND c.teacher_id = auth.uid())
    )
  );

CREATE POLICY "exercises: teacher insert" ON exercises
  FOR INSERT WITH CHECK (
    class_id IS NOT NULL AND created_by = auth.uid()
    AND EXISTS (SELECT 1 FROM classes c WHERE c.id = exercises.class_id AND c.teacher_id = auth.uid())
  );

CREATE POLICY "exercises: teacher update own" ON exercises
  FOR UPDATE USING (created_by = auth.uid());

CREATE POLICY "exercises: teacher delete own" ON exercises
  FOR DELETE USING (created_by = auth.uid());

-- submissions: student CRUD own, teacher reads for class students
CREATE POLICY "submissions: student CRUD own"
  ON submissions FOR ALL USING (student_id = auth.uid());

CREATE POLICY "submissions: teacher reads class students"
  ON submissions FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM class_memberships cm
      JOIN classes c ON c.id = cm.class_id
      WHERE cm.student_id = submissions.student_id
        AND c.teacher_id = auth.uid()
    )
  );

-- feedback: teacher inserts/reads own, student reads own submission's feedback
CREATE POLICY "feedback: teacher insert"
  ON feedback FOR INSERT WITH CHECK (teacher_id = auth.uid());

CREATE POLICY "feedback: teacher reads own"
  ON feedback FOR SELECT USING (teacher_id = auth.uid());

CREATE POLICY "feedback: student reads own submission"
  ON feedback FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM submissions
      WHERE id = feedback.submission_id AND student_id = auth.uid()
    )
  );

-- badges: public read
CREATE POLICY "badges: public read" ON badges FOR SELECT USING (true);

-- ============================================================
-- AUTO-CREATE PROFILE ON SIGN-UP
-- ============================================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, role, display_name, avatar_url)
  VALUES (
    NEW.id,
    'student',
    COALESCE(NEW.raw_user_meta_data ->> 'full_name', NEW.raw_user_meta_data ->> 'name'),
    NEW.raw_user_meta_data ->> 'avatar_url'
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- student_badges: student reads own, teacher reads class students
CREATE POLICY "student_badges: student reads own"
  ON student_badges FOR SELECT USING (student_id = auth.uid());

CREATE POLICY "student_badges: student inserts own"
  ON student_badges FOR INSERT WITH CHECK (student_id = auth.uid());

CREATE POLICY "student_badges: teacher reads class"
  ON student_badges FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM class_memberships cm
      JOIN classes c ON c.id = cm.class_id
      WHERE cm.student_id = student_badges.student_id
        AND c.teacher_id = auth.uid()
    )
  );
