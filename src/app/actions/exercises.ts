"use server";

import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";

export async function createClassExercise(
  classId: string,
  title: string,
  instructions: string
) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) throw new Error("Not authenticated");

  const { data, error } = await supabase
    .from("exercises")
    .insert({
      lesson_id: null,
      class_id: classId,
      created_by: user.id,
      title,
      instructions: instructions.trim() || null,
      type: "recording",
      order: 1,
    })
    .select()
    .single();

  if (error) throw error;

  revalidatePath(`/teacher/classes/${classId}`);
  revalidatePath("/student/opdrachten");

  return data;
}

export async function updateClassExercise(
  exerciseId: string,
  classId: string,
  title: string,
  instructions: string
) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) throw new Error("Not authenticated");

  const { error } = await supabase
    .from("exercises")
    .update({ title, instructions: instructions.trim() || null })
    .eq("id", exerciseId)
    .eq("created_by", user.id);

  if (error) throw error;

  revalidatePath(`/teacher/classes/${classId}`);
  revalidatePath("/student/opdrachten");
}

export async function deleteClassExercise(exerciseId: string, classId: string) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) throw new Error("Not authenticated");

  const { error } = await supabase
    .from("exercises")
    .delete()
    .eq("id", exerciseId)
    .eq("created_by", user.id);

  if (error) throw error;

  revalidatePath(`/teacher/classes/${classId}`);
  revalidatePath("/student/opdrachten");
}
