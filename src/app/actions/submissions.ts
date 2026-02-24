"use server";

import { createClient } from "@/lib/supabase/server";
import { checkAndAwardBadges } from "./badges";
import { revalidatePath } from "next/cache";

export async function createSubmission(
  exerciseId: string,
  audioUrl: string,
  selfScore: number
) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) throw new Error("Not authenticated");

  // Get current attempt count
  const { count } = await supabase
    .from("submissions")
    .select("*", { count: "exact", head: true })
    .eq("exercise_id", exerciseId)
    .eq("student_id", user.id);

  const attemptNumber = (count ?? 0) + 1;

  const { data, error } = await supabase
    .from("submissions")
    .insert({
      exercise_id: exerciseId,
      student_id: user.id,
      attempt_number: attemptNumber,
      audio_url: audioUrl,
      self_score: selfScore,
    })
    .select()
    .single();

  if (error) throw error;

  // Check and award badges
  await checkAndAwardBadges(user.id);

  revalidatePath("/student/dashboard");

  return data;
}

export async function submitFeedback(submissionId: string, text: string) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) throw new Error("Not authenticated");

  // Verify teacher
  const { data: profile } = await supabase
    .from("profiles")
    .select("role")
    .eq("id", user.id)
    .single();

  if (profile?.role !== "teacher") throw new Error("Not authorized");

  const { data, error } = await supabase
    .from("feedback")
    .insert({
      submission_id: submissionId,
      teacher_id: user.id,
      text,
    })
    .select()
    .single();

  if (error) throw error;

  revalidatePath(`/teacher/submissions/${submissionId}`);
  return data;
}
