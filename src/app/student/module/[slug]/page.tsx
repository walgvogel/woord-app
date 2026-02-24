import { createClient } from "@/lib/supabase/server";
import { notFound } from "next/navigation";
import Link from "next/link";

export default async function ModulePage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return null;

  const { data: mod } = await supabase
    .from("modules")
    .select("*, lessons(*, exercises(id))")
    .eq("slug", slug)
    .single();

  if (!mod) notFound();

  const { data: submissions } = await supabase
    .from("submissions")
    .select("exercise_id")
    .eq("student_id", user.id);

  const completedExercises = new Set(submissions?.map((s) => s.exercise_id) ?? []);

  const lessons = (
    mod.lessons as {
      id: string;
      slug: string;
      title: string;
      order: number;
      exercises: { id: string }[];
    }[]
  ).sort((a, b) => a.order - b.order);

  return (
    <div className="flex flex-col gap-6">
      <div>
        <Link
          href="/student/dashboard"
          className="text-sm text-gray-500 hover:text-brand-blue transition"
        >
          ← Dashboard
        </Link>
        <div className="flex items-center gap-3 mt-2">
          <span className="text-4xl">{mod.icon ?? "📚"}</span>
          <h1
            className="text-4xl text-brand-blue leading-tight"
            style={{ fontFamily: "var(--font-bebas)" }}
          >
            {mod.title.toUpperCase()}
          </h1>
        </div>
      </div>

      <div className="flex flex-col gap-3">
        {lessons.map((lesson, idx) => {
          const total = lesson.exercises.length;
          const done = lesson.exercises.filter((ex) =>
            completedExercises.has(ex.id)
          ).length;
          const allDone = total > 0 && done === total;
          const percent = total > 0 ? Math.round((done / total) * 100) : 0;

          return (
            <Link
              key={lesson.id}
              href={`/student/module/${slug}/${lesson.slug}`}
              className="card flex items-center gap-4 hover:shadow-md transition group"
            >
              {/* Number */}
              <div
                className={`w-10 h-10 rounded-full flex items-center justify-center text-white font-bold shrink-0 ${
                  allDone ? "bg-pink" : "bg-brand-blue"
                }`}
              >
                {allDone ? "✓" : idx + 1}
              </div>

              <div className="flex-1 min-w-0">
                <p
                  className="font-bold text-brand-blue group-hover:text-pink transition"
                  style={{ fontFamily: "var(--font-bebas)", fontSize: "1.1rem" }}
                >
                  {lesson.title.toUpperCase()}
                </p>
                {total > 0 && (
                  <p className="text-xs text-gray-500 mt-0.5">
                    {done}/{total} oefeningen afgerond
                    {allDone && " 🎉"}
                  </p>
                )}
              </div>
              <span className="text-brand-blue text-xl shrink-0">→</span>
            </Link>
          );
        })}
      </div>
    </div>
  );
}
