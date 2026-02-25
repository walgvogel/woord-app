export type Role = "student" | "teacher";
export type ExerciseType = "recording" | "reading" | "self_assessment";

export interface Profile {
  id: string;
  role: Role;
  display_name: string | null;
  avatar_url: string | null;
  created_at: string;
}

export interface Class {
  id: string;
  name: string;
  teacher_id: string;
  join_code: string;
  created_at: string;
}

export interface ClassMembership {
  class_id: string;
  student_id: string;
  joined_at: string;
}

export interface Module {
  id: string;
  slug: string;
  title: string;
  icon: string | null;
  order: number;
}

export interface Lesson {
  id: string;
  module_id: string;
  slug: string;
  title: string;
  content: string | null;
  order: number;
}

export interface Exercise {
  id: string;
  lesson_id: string;
  title: string;
  type: ExerciseType;
  instructions: string | null;
  order: number;
}

export interface Submission {
  id: string;
  exercise_id: string;
  student_id: string;
  attempt_number: number;
  audio_url: string | null;
  self_score: number | null;
  reflection_text: string | null;
  completed_at: string;
}

export interface Feedback {
  id: string;
  submission_id: string;
  teacher_id: string;
  text: string;
  created_at: string;
}

export interface Badge {
  id: string;
  slug: string;
  name: string;
  description: string | null;
  icon_emoji: string | null;
}

export interface StudentBadge {
  student_id: string;
  badge_id: string;
  earned_at: string;
}

// Joined types
export interface LessonWithExercises extends Lesson {
  exercises: Exercise[];
}

export interface ModuleWithLessons extends Module {
  lessons: LessonWithExercises[];
}

export interface SubmissionWithFeedback extends Submission {
  feedback: Feedback[];
  exercises: Exercise & { lessons: Lesson & { modules: Module } };
  profiles: Profile;
}

export interface StudentBadgeWithBadge extends StudentBadge {
  badges: Badge;
}

export interface ClassWithMemberships extends Class {
  class_memberships: { student_id: string }[];
}
