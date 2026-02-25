import { createClient } from "@/lib/supabase/server";
import { notFound } from "next/navigation";
import Link from "next/link";
import ProgressBar from "@/components/ProgressBar";
import CopyButton from "./CopyButton";
import ClassExercisesSection from "./ClassExercisesSection";

export default async function ClassDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return null;

  const { data: cls } = await supabase
    .from("classes")
    .select("*")
    .eq("id", id)
    .eq("teacher_id", user.id)
    .single();

  if (!cls) notFound();

  const { data: memberships } = await supabase
    .from("class_memberships")
    .select("student_id, joined_at, profiles(id, display_name, avatar_url)")
    .eq("class_id", id)
    .order("joined_at", { ascending: true });

  const { count: totalExercises } = await supabase
    .from("exercises")
    .select("*", { count: "exact", head: true })
    .is("class_id", null);

  const { data: classExercises } = await supabase
    .from("exercises")
    .select("id, title, instructions")
    .eq("class_id", id)
    .order("created_at", { ascending: true });

  // Fetch all submissions for these students
  const studentIds = (memberships ?? []).map((m) => m.student_id);

  const submissions =
    studentIds.length > 0
      ? await supabase
          .from("submissions")
          .select("student_id, exercise_id, completed_at")
          .in("student_id", studentIds)
      : { data: [] };

  const subsByStudent: Record<
    string,
    { exercise_id: string; completed_at: string }[]
  > = {};
  for (const sub of submissions.data ?? []) {
    if (!subsByStudent[sub.student_id]) subsByStudent[sub.student_id] = [];
    subsByStudent[sub.student_id].push(sub);
  }

  return (
    <div className="flex flex-col gap-6">
      {/* Header */}
      <div>
        <Link
          href="/teacher/dashboard"
          className="text-sm text-gray-500 hover:text-brand-blue transition"
        >
          ← Klassen
        </Link>
        <h1
          className="text-4xl text-brand-blue mt-2"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          {cls.name.toUpperCase()}
        </h1>
      </div>

      {/* Join code */}
      <div className="card flex items-center gap-4">
        <div className="flex-1">
          <p className="text-sm font-semibold text-gray-600">Klascode</p>
          <p
            className="text-4xl font-bold text-brand-blue tracking-widest mt-1"
            style={{ fontFamily: "var(--font-bebas)" }}
          >
            {cls.join_code}
          </p>
          <p className="text-xs text-gray-500 mt-1">
            Deel deze code met je leerlingen
          </p>
        </div>
        <CopyButton code={cls.join_code} />
      </div>

      {/* Students */}
      <section>
        <h2
          className="text-2xl text-brand-blue mb-3"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          LEERLINGEN ({memberships?.length ?? 0})
        </h2>

        {!memberships || memberships.length === 0 ? (
          <div className="callout text-center py-6">
            <p className="text-gray-600 text-sm">
              Nog geen leerlingen. Deel de klascode{" "}
              <strong>{cls.join_code}</strong> met je klas.
            </p>
          </div>
        ) : (
          <div className="flex flex-col gap-3">
            {memberships.map((m) => {
              const profileArr = m.profiles as {
                id: string;
                display_name: string | null;
                avatar_url: string | null;
              }[];
              const profile = Array.isArray(profileArr) ? profileArr[0] : (profileArr as unknown as { id: string; display_name: string | null; avatar_url: string | null });
              const studentSubs = subsByStudent[m.student_id] ?? [];
              const uniqueEx = new Set(studentSubs.map((s) => s.exercise_id)).size;
              const pct =
                totalExercises && totalExercises > 0
                  ? Math.round((uniqueEx / totalExercises) * 100)
                  : 0;

              return (
                <Link
                  key={m.student_id}
                  href={`/teacher/classes/${id}/students/${m.student_id}`}
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
                      {profile.display_name ?? "Onbekend"}
                    </p>
                    <ProgressBar value={pct} showPercent={false} color="pink" />
                    <p className="text-xs text-gray-500 mt-0.5">
                      {uniqueEx}/{totalExercises ?? 0} oefeningen
                    </p>
                  </div>
                  <span className="text-brand-blue text-xl shrink-0">→</span>
                </Link>
              );
            })}
          </div>
        )}
      </section>

      {/* Eigen teksten */}
      <ClassExercisesSection
        classId={id}
        initialExercises={classExercises ?? []}
      />
    </div>
  );
}
