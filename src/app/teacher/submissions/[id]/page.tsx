import { createClient } from "@/lib/supabase/server";
import { notFound } from "next/navigation";
import Link from "next/link";
import FeedbackForm from "./FeedbackForm";
import StarRating from "@/components/StarRating";

export default async function SubmissionDetailPage({
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

  const { data: submission } = await supabase
    .from("submissions")
    .select(
      "*, profiles(display_name, avatar_url), exercises(id, title, type, instructions, lessons(title, modules(title, icon, slug))), feedback(*, profiles(display_name))"
    )
    .eq("id", id)
    .single();

  if (!submission) notFound();

  const profile = submission.profiles as {
    display_name: string | null;
    avatar_url: string | null;
  };
  const exercise = submission.exercises as {
    id: string;
    title: string;
    type: string;
    instructions: string | null;
    lessons: { title: string; modules: { title: string; icon: string | null; slug: string } } | null;
  };
  const feedbacks = submission.feedback as {
    id: string;
    text: string;
    created_at: string;
    profiles: { display_name: string | null };
  }[];

  // All attempts for this student + exercise
  const { data: allAttempts } = await supabase
    .from("submissions")
    .select("id, attempt_number, audio_url, self_score, reflection_text, completed_at")
    .eq("student_id", submission.student_id)
    .eq("exercise_id", exercise.id)
    .order("attempt_number", { ascending: true });

  // Generate signed URLs for audio paths (bucket is private)
  // Old submissions may have a full public URL; skip those.
  const attemptsWithUrls = await Promise.all(
    (allAttempts ?? []).map(async (attempt) => {
      if (attempt.audio_url && !attempt.audio_url.startsWith("http")) {
        const { data } = await supabase.storage
          .from("recordings")
          .createSignedUrl(attempt.audio_url, 3600);
        return { ...attempt, audio_url: data?.signedUrl ?? null };
      }
      return attempt;
    })
  );

  return (
    <div className="flex flex-col gap-6">
      {/* Breadcrumb */}
      <div>
        <Link
          href="/teacher/submissions"
          className="text-sm text-gray-500 hover:text-brand-blue transition"
        >
          ← Alle opnames
        </Link>
      </div>

      {/* Student + exercise info */}
      <div className="card">
        <div className="flex items-center gap-4 mb-4">
          {profile.avatar_url ? (
            <img
              src={profile.avatar_url}
              alt=""
              className="w-12 h-12 rounded-full object-cover border-2 border-pink"
            />
          ) : (
            <div className="w-12 h-12 rounded-full bg-light-pink flex items-center justify-center text-2xl border-2 border-pink">
              🎤
            </div>
          )}
          <div>
            <h1
              className="text-2xl text-brand-blue"
              style={{ fontFamily: "var(--font-bebas)" }}
            >
              {(profile.display_name ?? "Leerling").toUpperCase()}
            </h1>
            <p className="text-sm text-gray-500">
              {exercise.lessons
                ? `${exercise.lessons.modules.icon} ${exercise.lessons.modules.title} → ${exercise.lessons.title}`
                : "📝 Eigen opdracht"}
            </p>
          </div>
        </div>

        <div className="border-t border-gray-100 pt-3">
          <p className="font-bold text-brand-blue">{exercise.title}</p>
          {exercise.instructions && (
            <p className="text-sm text-gray-600 mt-1">{exercise.instructions}</p>
          )}
        </div>
      </div>

      {/* All attempts */}
      <section>
        <h2
          className="text-xl text-brand-blue mb-3"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          ALLE POGINGEN ({attemptsWithUrls.length})
        </h2>
        <div className="flex flex-col gap-3">
          {attemptsWithUrls.map((attempt) => {
            const isCurrent = attempt.id === id;
            return (
              <div
                key={attempt.id}
                className={`card ${isCurrent ? "border-pink" : ""}`}
              >
                <div className="flex items-center justify-between mb-2">
                  <span
                    className="font-bold text-brand-blue"
                    style={{ fontFamily: "var(--font-bebas)" }}
                  >
                    POGING {attempt.attempt_number}
                    {isCurrent && (
                      <span className="ml-2 text-sm text-pink">← huidig</span>
                    )}
                  </span>
                  <span className="text-xs text-gray-400">
                    {new Date(attempt.completed_at).toLocaleDateString("nl-BE", {
                      day: "numeric",
                      month: "short",
                      year: "numeric",
                      hour: "2-digit",
                      minute: "2-digit",
                    })}
                  </span>
                </div>

                {attempt.audio_url ? (
                  <audio src={attempt.audio_url} controls className="w-full" />
                ) : (
                  <p className="text-sm text-gray-400 italic">Geen audio</p>
                )}

                {attempt.self_score !== null && attempt.self_score > 0 && (
                  <div className="mt-2 flex items-center gap-2">
                    <span className="text-sm text-gray-600">Zelfbeoordeling:</span>
                    <StarRating
                      value={attempt.self_score}
                      readonly
                      size="sm"
                    />
                  </div>
                )}

                {(attempt as typeof attempt & { reflection_text?: string | null }).reflection_text && (
                  <div className="mt-2 callout text-sm text-gray-700">
                    <p className="text-xs font-bold text-brand-blue mb-1">Reflectie leerling</p>
                    <p>{(attempt as typeof attempt & { reflection_text?: string | null }).reflection_text}</p>
                  </div>
                )}

                {!isCurrent && attempt.id && (
                  <Link
                    href={`/teacher/submissions/${attempt.id}`}
                    className="mt-2 inline-block text-xs text-brand-blue hover:text-pink transition"
                  >
                    Feedback geven op deze poging →
                  </Link>
                )}
              </div>
            );
          })}
        </div>
      </section>

      {/* Feedback section */}
      <section>
        <h2
          className="text-xl text-brand-blue mb-3"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          FEEDBACK
        </h2>

        {/* Existing feedback */}
        {feedbacks.length > 0 && (
          <div className="flex flex-col gap-2 mb-4">
            {feedbacks.map((fb) => (
              <div key={fb.id} className="callout">
                <p className="text-xs text-gray-500 mb-1">
                  {fb.profiles.display_name} –{" "}
                  {new Date(fb.created_at).toLocaleDateString("nl-BE", {
                    day: "numeric",
                    month: "short",
                  })}
                </p>
                <p className="text-sm text-gray-800">{fb.text}</p>
              </div>
            ))}
          </div>
        )}

        <FeedbackForm submissionId={id} />
      </section>
    </div>
  );
}
