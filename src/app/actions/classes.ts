"use server";

import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";

function generateJoinCode(): string {
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  let code = "";
  for (let i = 0; i < 6; i++) {
    code += chars[Math.floor(Math.random() * chars.length)];
  }
  return code;
}

export async function createClass(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) throw new Error("Not authenticated");

  const name = formData.get("name") as string;
  if (!name?.trim()) throw new Error("Naam is verplicht");

  // Generate unique join code
  let joinCode = generateJoinCode();
  let attempts = 0;
  while (attempts < 10) {
    const { data: existing } = await supabase
      .from("classes")
      .select("id")
      .eq("join_code", joinCode)
      .single();
    if (!existing) break;
    joinCode = generateJoinCode();
    attempts++;
  }

  const { data, error } = await supabase
    .from("classes")
    .insert({
      name: name.trim(),
      teacher_id: user.id,
      join_code: joinCode,
    })
    .select()
    .single();

  if (error) throw error;

  revalidatePath("/teacher/dashboard");
  redirect(`/teacher/classes/${data.id}`);
}

export async function joinClass(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) throw new Error("Not authenticated");

  const code = (formData.get("code") as string)?.trim().toUpperCase();
  if (!code || code.length !== 6) {
    return { error: "Voer een geldige 6-tekens code in." };
  }

  const { data: cls, error: findError } = await supabase
    .from("classes")
    .select("id, name")
    .eq("join_code", code)
    .single();

  if (findError || !cls) {
    return { error: "Klascode niet gevonden. Controleer de code en probeer opnieuw." };
  }

  // Check if already a member
  const { data: existing } = await supabase
    .from("class_memberships")
    .select("class_id")
    .eq("class_id", cls.id)
    .eq("student_id", user.id)
    .single();

  if (existing) {
    return { error: "Je bent al lid van deze klas." };
  }

  const { error: joinError } = await supabase.from("class_memberships").insert({
    class_id: cls.id,
    student_id: user.id,
  });

  if (joinError) throw joinError;

  revalidatePath("/student/dashboard");
  revalidatePath("/student/join");
  return { success: true, className: cls.name };
}
