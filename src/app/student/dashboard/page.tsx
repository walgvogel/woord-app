import { createClient } from "@/lib/supabase/server";
import Link from "next/link";
import ProgressBar from "@/components/ProgressBar";
import BadgeCard from "@/components/BadgeCard";

export default async function StudentDashboard() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return null;

  const [
    { data: profile },
    { data: modules },
    { data: submissions },
    { data: studentBadges },
    { data: allBadges },
    { data: memberships },
  ] = await Promise.all([
    supabase.from("profiles").select("*").eq("id", user.id).single(),
    supabase.from("modules").select("*, lessons(*, exercises(*))").order("order"),
    supabase.from("submissions").select("exercise_id").eq("student_id", user.id),
    supabase
      .from("student_badges")
      .select("*, badges(*)")
      .eq("student_id", user.id),
    supabase.from("badges").select("*"),
    supabase
      .from("class_memberships")
      .select("class_id, classes(name)")
      .eq("student_id", user.id),
  ]);

  const completedExercises = new Set(submissions?.map((s) => s.exercise_id) ?? []);
  const earnedBadgeIds = new Set(studentBadges?.map((sb) => sb.badge_id) ?? []);

  // Find the first incomplete lesson to suggest "ga verder"
  let continueLink = "/student/dashboard";
  let continueLabel = "Begin je eerste les";
  outer: for (const mod of modules ?? []) {
    for (const lesson of (mod.lessons as { slug: string; title: string; exercises: { id: string }[] }[]) ?? []) {
      const allDone = lesson.exercises.every((ex) => completedExercises.has(ex.id));
      if (!allDone) {
        continueLink = `/student/module/${mod.slug}/${lesson.slug}`;
        continueLabel = `Ga verder: ${lesson.title}`;
        break outer;
      }
    }
  }

  // Calculate module progress
  const moduleProgress = (modules ?? []).map((mod) => {
    const allExercises = (mod.lessons as { exercises: { id: string }[] }[]).flatMap(
      (l) => l.exercises
    );
    const done = allExercises.filter((ex) => completedExercises.has(ex.id)).length;
    return {
      ...mod,
      total: allExercises.length,
      done,
      percent: allExercises.length > 0 ? Math.round((done / allExercises.length) * 100) : 0,
    };
  });

  const totalExercises = moduleProgress.reduce((acc, m) => acc + m.total, 0);
  const totalDone = moduleProgress.reduce((acc, m) => acc + m.done, 0);
  const overallPercent =
    totalExercises > 0 ? Math.round((totalDone / totalExercises) * 100) : 0;

  return (
    <div className="flex flex-col gap-6">
      {/* Welcome */}
      <div className="bg-brand-blue text-white rounded-2xl p-6">
        <h1
          className="text-4xl leading-tight"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          HEY, {(profile?.display_name ?? "LEERLING").toUpperCase()}!
        </h1>
        {memberships && memberships.length > 0 ? (
          <p className="text-white/80 text-sm mt-1">
            Klas:{" "}
            {(memberships as unknown as { classes: { name: string } | null }[])
              .map((m) => m.classes?.name)
              .filter(Boolean)
              .join(", ")}
          </p>
        ) : (
          <Link
            href="/student/join"
            className="inline-block mt-2 px-4 py-2 bg-pink text-white rounded-lg text-sm font-bold hover:opacity-90 transition"
          >
            + Klas joinen
          </Link>
        )}

        {/* Overall progress */}
        <div className="mt-4">
          <ProgressBar value={overallPercent} label="Totale voortgang" />
        </div>

        {/* Continue button */}
        <Link
          href={continueLink}
          className="inline-flex items-center gap-2 mt-4 px-6 py-3 bg-pink rounded-xl text-white font-bold hover:opacity-90 active:scale-95 transition"
        >
          {continueLabel} →
        </Link>
      </div>

      {/* Modules */}
      <section>
        <h2
          className="text-2xl text-brand-blue mb-3"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          MODULES
        </h2>
        <div className="flex flex-col gap-3">
          {moduleProgress.map((mod) => (
            <Link
              key={mod.id}
              href={`/student/module/${mod.slug}`}
              className="card flex items-center gap-4 hover:shadow-md transition group"
            >
              <span className="text-3xl">{mod.icon ?? "📚"}</span>
              <div className="flex-1 min-w-0">
                <p
                  className="font-bold text-brand-blue group-hover:text-pink transition"
                  style={{ fontFamily: "var(--font-bebas)", fontSize: "1.1rem" }}
                >
                  {mod.title.toUpperCase()}
                </p>
                <ProgressBar
                  value={mod.percent}
                  showPercent={false}
                  color="pink"
                />
                <p className="text-xs text-gray-500 mt-1">
                  {mod.done}/{mod.total} oefeningen
                </p>
              </div>
              <span className="text-brand-blue text-xl shrink-0">→</span>
            </Link>
          ))}
        </div>
      </section>

      {/* Opdrachten van leerkracht */}
      {memberships && memberships.length > 0 && (
        <section>
          <h2
            className="text-2xl text-brand-blue mb-3"
            style={{ fontFamily: "var(--font-bebas)" }}
          >
            OPDRACHTEN
          </h2>
          <a
            href="/student/opdrachten"
            className="card flex items-center gap-4 hover:shadow-md transition group"
          >
            <span className="text-3xl">📝</span>
            <div className="flex-1 min-w-0">
              <p
                className="font-bold text-brand-blue group-hover:text-pink transition"
                style={{ fontFamily: "var(--font-bebas)", fontSize: "1.1rem" }}
              >
                OPDRACHTEN VAN JE LEERKRACHT
              </p>
              <p className="text-xs text-gray-500">
                Bekijk en neem de teksten van je leerkracht op
              </p>
            </div>
            <span className="text-brand-blue text-xl shrink-0">→</span>
          </a>
        </section>
      )}

      {/* Badges */}
      <section>
        <h2
          className="text-2xl text-brand-blue mb-3"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          BADGES
        </h2>
        <div className="grid grid-cols-3 gap-3">
          {(allBadges ?? []).map((badge) => {
            const earned = studentBadges?.find((sb) => sb.badge_id === badge.id);
            return (
              <BadgeCard
                key={badge.id}
                badge={badge}
                earned={earnedBadgeIds.has(badge.id)}
                earnedAt={earned?.earned_at}
              />
            );
          })}
        </div>
      </section>
    </div>
  );
}
