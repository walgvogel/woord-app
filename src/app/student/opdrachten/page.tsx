import { createClient } from "@/lib/supabase/server";
import AudioRecorder from "@/components/AudioRecorder";
import type { Submission } from "@/types/database";

export default async function OpdrachtenPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return null;

  const { data: memberships } = await supabase
    .from("class_memberships")
    .select("class_id")
    .eq("student_id", user.id);

  const classIds = (memberships ?? []).map((m) => m.class_id);

  if (classIds.length === 0) {
    return (
      <div className="flex flex-col gap-6">
        <h1
          className="text-4xl text-brand-blue"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          OPDRACHTEN
        </h1>
        <div className="callout text-center py-8">
          <p className="text-gray-600 text-sm">
            Je bent nog niet in een klas. Join een klas om opdrachten te zien.
          </p>
        </div>
      </div>
    );
  }

  const { data: exercises } = await supabase
    .from("exercises")
    .select("id, title, instructions, class_id")
    .in("class_id", classIds)
    .order("created_at", { ascending: true });

  const exerciseIds = (exercises ?? []).map((e) => e.id);

  const rawSubmissions =
    exerciseIds.length > 0
      ? await supabase
          .from("submissions")
          .select("*")
          .eq("student_id", user.id)
          .in("exercise_id", exerciseIds)
          .order("attempt_number", { ascending: true })
      : { data: [] };

  // Generate signed URLs for private audio paths
  const submissionsWithUrls = (await Promise.all(
    (rawSubmissions.data ?? []).map(async (sub) => {
      if (sub.audio_url && !sub.audio_url.startsWith("http")) {
        const { data } = await supabase.storage
          .from("recordings")
          .createSignedUrl(sub.audio_url, 3600);
        return { ...sub, audio_url: data?.signedUrl ?? null };
      }
      return sub;
    })
  )) as Submission[];

  const subsByExercise: Record<string, Submission[]> = {};
  for (const sub of submissionsWithUrls) {
    if (!subsByExercise[sub.exercise_id]) subsByExercise[sub.exercise_id] = [];
    subsByExercise[sub.exercise_id].push(sub);
  }

  return (
    <div className="flex flex-col gap-6">
      <h1
        className="text-4xl text-brand-blue"
        style={{ fontFamily: "var(--font-bebas)" }}
      >
        OPDRACHTEN VAN JE LEERKRACHT
      </h1>

      {!exercises || exercises.length === 0 ? (
        <div className="callout text-center py-8">
          <p className="text-gray-600 text-sm">
            Je leerkracht heeft nog geen opdrachten toegevoegd.
          </p>
        </div>
      ) : (
        <div className="flex flex-col gap-6">
          {exercises.map((exercise, idx) => {
            const exSubs = subsByExercise[exercise.id] ?? [];
            return (
              <div key={exercise.id} className="flex flex-col gap-3">
                <div className="flex items-start gap-3">
                  <div className="w-8 h-8 rounded-full bg-pink text-white flex items-center justify-center text-sm font-bold shrink-0 mt-0.5">
                    {idx + 1}
                  </div>
                  <h3
                    className="text-lg text-brand-blue flex-1"
                    style={{ fontFamily: "var(--font-bebas)" }}
                  >
                    {exercise.title.toUpperCase()}
                  </h3>
                </div>

                {exercise.instructions && (
                  <div className="callout ml-11">
                    <p className="text-sm whitespace-pre-wrap">
                      {exercise.instructions}
                    </p>
                  </div>
                )}

                <div className="ml-11">
                  <AudioRecorder
                    exerciseId={exercise.id}
                    existingSubmissions={exSubs}
                  />
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
