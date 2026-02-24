import { createClient } from "@/lib/supabase/server";
import { notFound } from "next/navigation";
import Link from "next/link";

export default async function StudentDetailPage({
  params,
}: {
  params: Promise<{ id: string; studentId: string }>;
}) {
  const { id: classId, studentId } = await params;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return null;

  // Verify teacher owns this class
  const { data: cls } = await supabase
    .from("classes")
    .select("name")
    .eq("id", classId)
    .eq("teacher_id", user.id)
    .single();

  if (!cls) notFound();

  const [
    { data: studentProfile },
    { data: modules },
    { data: submissions },
  ] = await Promise.all([
    supabase
      .from("profiles")
      .select("*")
      .eq("id", studentId)
      .single(),
    supabase
      .from("modules")
      .select("*, lessons(*, exercises(*))")
      .order("order"),
    supabase
      .from("submissions")
      .select("*, feedback(*)")
      .eq("student_id", studentId)
      .order("completed_at", { ascending: false }),
  ]);

  if (!studentProfile) notFound();

  // Group submissions by exercise_id (latest first per exercise)
  const submissionsByExercise: Record<string, typeof submissions> = {};
  for (const sub of submissions ?? []) {
    if (!submissionsByExercise[sub.exercise_id]) {
      submissionsByExercise[sub.exercise_id] = [];
    }
    submissionsByExercise[sub.exercise_id]!.push(sub);
  }

  return (
    <div className="flex flex-col gap-6">
      {/* Breadcrumb */}
      <div>
        <div className="flex items-center gap-2 text-sm text-gray-500 flex-wrap">
          <Link href="/teacher/dashboard" className="hover:text-brand-blue transition">
            Klassen
          </Link>
          <span>/</span>
          <Link href={`/teacher/classes/${classId}`} className="hover:text-brand-blue transition">
            {cls.name}
          </Link>
          <span>/</span>
          <span className="text-brand-blue font-semibold">
            {studentProfile.display_name}
          </span>
        </div>
      </div>

      {/* Student header */}
      <div className="card flex items-center gap-4">
        {studentProfile.avatar_url ? (
          <img
            src={studentProfile.avatar_url}
            alt=""
            className="w-14 h-14 rounded-full object-cover border-2 border-pink"
          />
        ) : (
          <div className="w-14 h-14 rounded-full bg-light-pink flex items-center justify-center text-2xl border-2 border-pink">
            🎤
          </div>
        )}
        <div>
          <h1
            className="text-2xl text-brand-blue"
            style={{ fontFamily: "var(--font-bebas)" }}
          >
            {(studentProfile.display_name ?? "Leerling").toUpperCase()}
          </h1>
          <p className="text-sm text-gray-500">
            {submissions?.length ?? 0} opnames ingediend
          </p>
        </div>
      </div>

      {/* Progress per module */}
      {(modules ?? []).map((mod) => {
        const lessons = (
          mod.lessons as {
            id: string;
            title: string;
            order: number;
            exercises: { id: string; title: string; type: string; order: number }[];
          }[]
        ).sort((a, b) => a.order - b.order);

        return (
          <section key={mod.id}>
            <h2
              className="text-xl text-brand-blue mb-3 flex items-center gap-2"
              style={{ fontFamily: "var(--font-bebas)" }}
            >
              <span>{mod.icon ?? "📚"}</span>
              {mod.title.toUpperCase()}
            </h2>

            <div className="flex flex-col gap-3">
              {lessons.map((lesson) => (
                <div key={lesson.id} className="card">
                  <p className="font-bold text-sm text-gray-700 mb-2">
                    {lesson.title}
                  </p>
                  <div className="flex flex-col gap-2">
                    {lesson.exercises
                      .sort((a, b) => a.order - b.order)
                      .map((ex) => {
                        const exSubs = submissionsByExercise[ex.id] ?? [];
                        const done = exSubs.length > 0;
                        const latest = exSubs[0];
                        return (
                          <div
                            key={ex.id}
                            className="flex items-center gap-3 p-2 rounded-lg bg-gray-50"
                          >
                            <span
                              className={`w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold shrink-0 ${
                                done
                                  ? "bg-pink text-white"
                                  : "bg-gray-200 text-gray-400"
                              }`}
                            >
                              {done ? "✓" : "–"}
                            </span>
                            <span className="text-sm flex-1 truncate">
                              {ex.title}
                            </span>
                            {done && (
                              <span className="text-xs text-gray-400 shrink-0">
                                {exSubs.length} poging{exSubs.length !== 1 ? "en" : ""}
                              </span>
                            )}
                            {latest?.audio_url && (
                              <Link
                                href={`/teacher/submissions/${latest.id}`}
                                className="text-xs text-brand-blue font-bold hover:text-pink transition shrink-0"
                              >
                                Bekijken →
                              </Link>
                            )}
                          </div>
                        );
                      })}
                  </div>
                </div>
              ))}
            </div>
          </section>
        );
      })}
    </div>
  );
}
