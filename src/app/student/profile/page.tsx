import { createClient } from "@/lib/supabase/server";
import BadgeCard from "@/components/BadgeCard";
import Link from "next/link";

export default async function ProfilePage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return null;

  const [
    { data: profile },
    { data: memberships },
    { data: studentBadges },
    { data: allBadges },
    { data: submissions },
  ] = await Promise.all([
    supabase.from("profiles").select("*").eq("id", user.id).single(),
    supabase
      .from("class_memberships")
      .select("classes(id, name, join_code)")
      .eq("student_id", user.id),
    supabase
      .from("student_badges")
      .select("*, badges(*)")
      .eq("student_id", user.id)
      .order("earned_at", { ascending: false }),
    supabase.from("badges").select("*"),
    supabase
      .from("submissions")
      .select("exercise_id, completed_at")
      .eq("student_id", user.id),
  ]);

  const uniqueExercises = new Set(submissions?.map((s) => s.exercise_id) ?? []);
  const earnedBadgeIds = new Set(studentBadges?.map((sb) => sb.badge_id) ?? []);

  return (
    <div className="flex flex-col gap-6">
      <h1
        className="text-4xl text-brand-blue"
        style={{ fontFamily: "var(--font-bebas)" }}
      >
        MIJN PROFIEL
      </h1>

      {/* Profile card */}
      <div className="card flex items-center gap-4">
        {profile?.avatar_url ? (
          <img
            src={profile.avatar_url}
            alt={profile.display_name ?? "Avatar"}
            className="w-16 h-16 rounded-full object-cover border-2 border-pink"
          />
        ) : (
          <div className="w-16 h-16 rounded-full bg-light-pink flex items-center justify-center text-3xl border-2 border-pink">
            🎤
          </div>
        )}
        <div>
          <h2
            className="text-xl text-brand-blue"
            style={{ fontFamily: "var(--font-bebas)" }}
          >
            {profile?.display_name ?? user.email}
          </h2>
          <p className="text-sm text-gray-500">{user.email}</p>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 gap-3">
        <div className="card text-center">
          <p className="text-4xl font-bold text-pink">{uniqueExercises.size}</p>
          <p className="text-sm text-gray-600 mt-1">Oefeningen voltooid</p>
        </div>
        <div className="card text-center">
          <p className="text-4xl font-bold text-brand-blue">{submissions?.length ?? 0}</p>
          <p className="text-sm text-gray-600 mt-1">Opnames ingediend</p>
        </div>
      </div>

      {/* Classes */}
      <section>
        <h2
          className="text-2xl text-brand-blue mb-3"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          MIJN KLASSEN
        </h2>
        {memberships && memberships.length > 0 ? (
          <div className="flex flex-col gap-2">
            {(memberships as unknown as { classes: { id: string; name: string; join_code: string } | null }[])
              .filter((m) => m.classes != null)
              .map((m) => (
                <div key={m.classes!.id} className="card flex items-center justify-between">
                  <span className="font-bold text-brand-blue">{m.classes!.name}</span>
                  <span className="text-sm text-gray-500 font-mono">
                    {m.classes!.join_code}
                  </span>
                </div>
              ))}
          </div>
        ) : (
          <div className="callout">
            <p className="text-sm text-gray-700">
              Je bent nog geen lid van een klas.{" "}
              <Link href="/student/join" className="text-brand-blue font-bold underline">
                Klas joinen
              </Link>
            </p>
          </div>
        )}
      </section>

      {/* Badges */}
      <section>
        <h2
          className="text-2xl text-brand-blue mb-3"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          BADGES ({earnedBadgeIds.size}/{allBadges?.length ?? 0})
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
