import { createClient } from "@/lib/supabase/server";
import SignOutButton from "./SignOutButton";

export default async function TeacherProfilePage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return null;

  const [{ data: profile }, { data: classes }, { data: submissions }] =
    await Promise.all([
      supabase.from("profiles").select("*").eq("id", user.id).single(),
      supabase
        .from("classes")
        .select("id, name, class_memberships(student_id)")
        .eq("teacher_id", user.id),
      supabase
        .from("submissions")
        .select("id, feedback(id)")
        .in(
          "student_id",
          (
            await supabase
              .from("class_memberships")
              .select("student_id, classes!inner(teacher_id)")
              .eq("classes.teacher_id", user.id)
          ).data?.map((m) => m.student_id) ?? []
        ),
    ]);

  const totalStudents = new Set(
    (classes ?? []).flatMap((c) =>
      (c.class_memberships as { student_id: string }[]).map(
        (m) => m.student_id
      )
    )
  ).size;

  const totalFeedback = (submissions ?? []).reduce(
    (sum, s) => sum + ((s.feedback as { id: string }[])?.length ?? 0),
    0
  );

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
            👩‍🏫
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
          <p className="text-xs text-pink font-semibold mt-1">Leerkracht</p>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-3 gap-3">
        <div className="card text-center">
          <p className="text-4xl font-bold text-brand-blue">
            {classes?.length ?? 0}
          </p>
          <p className="text-sm text-gray-600 mt-1">Klassen</p>
        </div>
        <div className="card text-center">
          <p className="text-4xl font-bold text-pink">{totalStudents}</p>
          <p className="text-sm text-gray-600 mt-1">Leerlingen</p>
        </div>
        <div className="card text-center">
          <p className="text-4xl font-bold text-brand-blue">{totalFeedback}</p>
          <p className="text-sm text-gray-600 mt-1">Feedback gegeven</p>
        </div>
      </div>

      {/* Sign out */}
      <SignOutButton />
    </div>
  );
}
