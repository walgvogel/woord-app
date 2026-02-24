import { createClient } from "@/lib/supabase/server";
import Link from "next/link";
import ProgressBar from "@/components/ProgressBar";

export default async function TeacherDashboard() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return null;

  // Fetch teacher's classes with memberships
  const { data: classes } = await supabase
    .from("classes")
    .select("*, class_memberships(student_id)")
    .eq("teacher_id", user.id)
    .order("created_at", { ascending: false });

  // Fetch total exercise count for completion %
  const { count: totalExercises } = await supabase
    .from("exercises")
    .select("*", { count: "exact", head: true });

  // For each class, get submission stats
  const classStats = await Promise.all(
    (classes ?? []).map(async (cls) => {
      const studentIds = (cls.class_memberships as { student_id: string }[]).map(
        (m) => m.student_id
      );

      if (studentIds.length === 0) {
        return { ...cls, avgCompletion: 0 };
      }

      const { data: submissions } = await supabase
        .from("submissions")
        .select("student_id, exercise_id")
        .in("student_id", studentIds);

      // Average completion per student
      let totalCompletion = 0;
      for (const studentId of studentIds) {
        const studentSubs = submissions?.filter((s) => s.student_id === studentId) ?? [];
        const uniqueExercises = new Set(studentSubs.map((s) => s.exercise_id)).size;
        const pct =
          totalExercises && totalExercises > 0
            ? (uniqueExercises / totalExercises) * 100
            : 0;
        totalCompletion += pct;
      }

      return {
        ...cls,
        avgCompletion: Math.round(totalCompletion / studentIds.length),
      };
    })
  );

  return (
    <div className="flex flex-col gap-6">
      <div className="flex items-center justify-between">
        <h1
          className="text-4xl text-brand-blue"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          MIJN KLASSEN
        </h1>
        <Link
          href="/teacher/classes/new"
          className="px-4 py-2 bg-pink text-white rounded-xl font-bold text-sm hover:opacity-90 active:scale-95 transition"
        >
          + Nieuwe klas
        </Link>
      </div>

      {classStats.length === 0 ? (
        <div className="callout text-center py-10">
          <p className="text-2xl mb-2">🎓</p>
          <p className="text-gray-700 font-semibold">Nog geen klassen</p>
          <p className="text-sm text-gray-500 mt-1">
            Maak je eerste klas aan en deel de code met je leerlingen.
          </p>
          <Link
            href="/teacher/classes/new"
            className="inline-block mt-4 px-6 py-3 bg-brand-blue text-white rounded-xl font-bold hover:opacity-90 transition"
          >
            Klas aanmaken
          </Link>
        </div>
      ) : (
        <div className="flex flex-col gap-4">
          {classStats.map((cls) => {
            const memberCount = (cls.class_memberships as { student_id: string }[]).length;
            return (
              <Link
                key={cls.id}
                href={`/teacher/classes/${cls.id}`}
                className="card hover:shadow-md transition group"
              >
                <div className="flex items-start justify-between gap-4">
                  <div className="flex-1">
                    <h2
                      className="text-xl text-brand-blue group-hover:text-pink transition"
                      style={{ fontFamily: "var(--font-bebas)" }}
                    >
                      {cls.name.toUpperCase()}
                    </h2>
                    <div className="flex items-center gap-4 mt-1">
                      <span className="text-sm text-gray-600">
                        {memberCount} leerling{memberCount !== 1 ? "en" : ""}
                      </span>
                      <span className="text-sm font-mono bg-light-pink text-brand-blue px-2 py-0.5 rounded-lg font-bold">
                        {cls.join_code}
                      </span>
                    </div>
                  </div>
                  <span className="text-brand-blue text-xl">→</span>
                </div>
                <div className="mt-3">
                  <ProgressBar
                    value={cls.avgCompletion}
                    label="Gem. voortgang"
                    color="blue"
                  />
                </div>
              </Link>
            );
          })}
        </div>
      )}
    </div>
  );
}
