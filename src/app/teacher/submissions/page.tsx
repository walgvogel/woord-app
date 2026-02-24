import { createClient } from "@/lib/supabase/server";
import Link from "next/link";

export default async function SubmissionsPage({
  searchParams,
}: {
  searchParams: Promise<{ class?: string }>;
}) {
  const { class: classFilter } = await searchParams;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return null;

  // Get teacher's classes
  const { data: classes } = await supabase
    .from("classes")
    .select("id, name, class_memberships(student_id)")
    .eq("teacher_id", user.id);

  // Collect all student IDs from teacher's classes
  const allStudentIds = new Set<string>();
  for (const cls of classes ?? []) {
    for (const m of cls.class_memberships as { student_id: string }[]) {
      allStudentIds.add(m.student_id);
    }
  }

  // If filtering by class
  let filteredStudentIds = [...allStudentIds];
  if (classFilter) {
    const cls = classes?.find((c) => c.id === classFilter);
    if (cls) {
      filteredStudentIds = (cls.class_memberships as { student_id: string }[]).map(
        (m) => m.student_id
      );
    }
  }

  // Fetch latest submission per student per exercise (with audio)
  const { data: submissions } = filteredStudentIds.length > 0
    ? await supabase
        .from("submissions")
        .select(
          "*, profiles(display_name, avatar_url), exercises(title, type, lessons(title, modules(title, icon)))"
        )
        .in("student_id", filteredStudentIds)
        .not("audio_url", "is", null)
        .order("completed_at", { ascending: false })
        .limit(100)
    : { data: [] };

  return (
    <div className="flex flex-col gap-6">
      <h1
        className="text-4xl text-brand-blue"
        style={{ fontFamily: "var(--font-bebas)" }}
      >
        ALLE OPNAMES
      </h1>

      {/* Class filter */}
      <div className="flex gap-2 flex-wrap">
        <Link
          href="/teacher/submissions"
          className={`px-3 py-1.5 rounded-lg text-sm font-semibold transition ${
            !classFilter
              ? "bg-brand-blue text-white"
              : "bg-gray-100 text-gray-600 hover:bg-gray-200"
          }`}
        >
          Alle klassen
        </Link>
        {(classes ?? []).map((cls) => (
          <Link
            key={cls.id}
            href={`/teacher/submissions?class=${cls.id}`}
            className={`px-3 py-1.5 rounded-lg text-sm font-semibold transition ${
              classFilter === cls.id
                ? "bg-brand-blue text-white"
                : "bg-gray-100 text-gray-600 hover:bg-gray-200"
            }`}
          >
            {cls.name}
          </Link>
        ))}
      </div>

      {/* Submissions list */}
      {(!submissions || submissions.length === 0) ? (
        <div className="callout text-center py-10">
          <p className="text-gray-600">Nog geen opnames ingediend.</p>
        </div>
      ) : (
        <div className="flex flex-col gap-3">
          {submissions.map((sub) => {
            const profile = sub.profiles as { display_name: string | null; avatar_url: string | null };
            const exercise = sub.exercises as {
              title: string;
              type: string;
              lessons: { title: string; modules: { title: string; icon: string | null } };
            };

            return (
              <Link
                key={sub.id}
                href={`/teacher/submissions/${sub.id}`}
                className="card flex items-center gap-4 hover:shadow-md transition group"
              >
                {profile.avatar_url ? (
                  <img
                    src={profile.avatar_url}
                    alt=""
                    className="w-10 h-10 rounded-full object-cover shrink-0"
                  />
                ) : (
                  <div className="w-10 h-10 rounded-full bg-light-pink flex items-center justify-center text-xl shrink-0">
                    🎤
                  </div>
                )}
                <div className="flex-1 min-w-0">
                  <p className="font-bold text-brand-blue group-hover:text-pink transition truncate">
                    {profile.display_name ?? "Leerling"}
                  </p>
                  <p className="text-sm text-gray-600 truncate">
                    {exercise.lessons.modules.icon}{" "}
                    {exercise.lessons.modules.title} →{" "}
                    {exercise.lessons.title} → {exercise.title}
                  </p>
                  <p className="text-xs text-gray-400 mt-0.5">
                    Poging {sub.attempt_number} •{" "}
                    {new Date(sub.completed_at).toLocaleDateString("nl-BE", {
                      day: "numeric",
                      month: "short",
                      year: "numeric",
                    })}
                    {sub.self_score !== null && sub.self_score > 0 && (
                      <> • {"⭐".repeat(sub.self_score)}</>
                    )}
                  </p>
                </div>
                <span className="text-brand-blue text-xl shrink-0">→</span>
              </Link>
            );
          })}
        </div>
      )}
    </div>
  );
}
