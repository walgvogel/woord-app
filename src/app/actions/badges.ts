"use server";

import { createClient } from "@/lib/supabase/server";

export async function checkAndAwardBadges(studentId: string) {
  const supabase = await createClient();

  // Fetch all badges
  const { data: badges } = await supabase.from("badges").select("*");
  if (!badges) return;

  // Fetch already earned badges
  const { data: earned } = await supabase
    .from("student_badges")
    .select("badge_id")
    .eq("student_id", studentId);
  const earnedIds = new Set(earned?.map((b) => b.badge_id) ?? []);

  // Fetch all submissions by this student
  const { data: submissions } = await supabase
    .from("submissions")
    .select("id, exercise_id, attempt_number, exercises(lesson_id, lessons(module_id))")
    .eq("student_id", studentId);

  if (!submissions) return;

  const toAward: string[] = [];

  for (const badge of badges) {
    if (earnedIds.has(badge.id)) continue;

    let earned = false;

    switch (badge.slug) {
      case "eerste-stem":
        earned = submissions.length >= 1;
        break;

      case "doorzetter": {
        // 3+ attempts on a single exercise
        const countPerExercise: Record<string, number> = {};
        for (const s of submissions) {
          countPerExercise[s.exercise_id] =
            (countPerExercise[s.exercise_id] ?? 0) + 1;
        }
        earned = Object.values(countPerExercise).some((c) => c >= 3);
        break;
      }

      case "module-meester": {
        // All exercises in at least one module are completed
        // Get all modules with their exercise counts
        const { data: modules } = await supabase
          .from("modules")
          .select("id, lessons(exercises(id))");

        if (modules) {
          for (const mod of modules) {
            const exerciseIds = (mod.lessons as { exercises: { id: string }[] }[])
              .flatMap((l) => l.exercises.map((e) => e.id));
            if (exerciseIds.length === 0) continue;
            const completedInModule = submissions.filter((s) =>
              exerciseIds.includes(s.exercise_id)
            );
            const uniqueCompleted = new Set(completedInModule.map((s) => s.exercise_id));
            if (uniqueCompleted.size >= exerciseIds.length) {
              earned = true;
              break;
            }
          }
        }
        break;
      }

      case "cursus-voltooid": {
        // All modules completed (dynamically counted)
        const { data: allModules } = await supabase
          .from("modules")
          .select("id, lessons(exercises(id))");

        if (allModules && allModules.length > 0) {
          let allDone = true;
          for (const mod of allModules) {
            const exerciseIds = (mod.lessons as { exercises: { id: string }[] }[])
              .flatMap((l) => l.exercises.map((e) => e.id));
            if (exerciseIds.length === 0) continue;
            const uniqueCompleted = new Set(
              submissions
                .filter((s) => exerciseIds.includes(s.exercise_id))
                .map((s) => s.exercise_id)
            );
            if (uniqueCompleted.size < exerciseIds.length) {
              allDone = false;
              break;
            }
          }
          earned = allDone;
        }
        break;
      }

      case "luisteraar": {
        // 10 unique exercises completed
        const uniqueExercises = new Set(submissions.map((s) => s.exercise_id));
        earned = uniqueExercises.size >= 10;
        break;
      }
    }

    if (earned) toAward.push(badge.id);
  }

  if (toAward.length > 0) {
    await supabase.from("student_badges").upsert(
      toAward.map((badge_id) => ({
        student_id: studentId,
        badge_id,
      })),
      { onConflict: "student_id,badge_id", ignoreDuplicates: true }
    );
  }
}
