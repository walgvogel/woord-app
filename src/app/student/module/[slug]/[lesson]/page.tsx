import { createClient } from "@/lib/supabase/server";
import { notFound } from "next/navigation";
import Link from "next/link";
import ReactMarkdown from "react-markdown";
import AudioRecorder from "@/components/AudioRecorder";
import StarRating from "@/components/StarRating";
import type { Submission } from "@/types/database";

export default async function LessonPage({
  params,
}: {
  params: Promise<{ slug: string; lesson: string }>;
}) {
  const { slug, lesson: lessonSlug } = await params;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return null;

  // Fetch module + lesson + exercises
  const { data: mod } = await supabase
    .from("modules")
    .select("id, slug, title, icon")
    .eq("slug", slug)
    .single();

  if (!mod) notFound();

  const { data: lesson } = await supabase
    .from("lessons")
    .select("*, exercises(*)")
    .eq("module_id", mod.id)
    .eq("slug", lessonSlug)
    .single();

  if (!lesson) notFound();

  const exercises = (lesson.exercises as { id: string; title: string; type: string; instructions: string | null; order: number }[]).sort(
    (a, b) => a.order - b.order
  );

  // Fetch all submissions for these exercises
  const exerciseIds = exercises.map((e) => e.id);
  const { data: submissions } = await supabase
    .from("submissions")
    .select("*, feedback(*)")
    .eq("student_id", user.id)
    .in("exercise_id", exerciseIds)
    .order("attempt_number", { ascending: true });

  // Generate signed URLs for audio paths (bucket is private)
  // Old submissions may have a full public URL; skip those.
  const submissionsWithUrls: Submission[] = await Promise.all(
    (submissions ?? []).map(async (sub) => {
      if (sub.audio_url && !sub.audio_url.startsWith("http")) {
        const { data } = await supabase.storage
          .from("recordings")
          .createSignedUrl(sub.audio_url, 3600);
        return { ...sub, audio_url: data?.signedUrl ?? null };
      }
      return sub;
    })
  );

  // Group submissions by exercise
  const submissionsByExercise: Record<string, Submission[]> = {};
  for (const sub of submissionsWithUrls) {
    if (!submissionsByExercise[sub.exercise_id]) {
      submissionsByExercise[sub.exercise_id] = [];
    }
    submissionsByExercise[sub.exercise_id].push(sub);
  }

  // Sibling lessons for prev/next
  const { data: siblingLessons } = await supabase
    .from("lessons")
    .select("slug, title, order")
    .eq("module_id", mod.id)
    .order("order");

  const siblings = siblingLessons ?? [];
  const currentIdx = siblings.findIndex((l) => l.slug === lessonSlug);
  const prevLesson = currentIdx > 0 ? siblings[currentIdx - 1] : null;
  const nextLesson = currentIdx < siblings.length - 1 ? siblings[currentIdx + 1] : null;

  return (
    <div className="flex flex-col gap-6">
      {/* Breadcrumb */}
      <div className="flex items-center gap-2 text-sm text-gray-500 flex-wrap">
        <Link href="/student/dashboard" className="hover:text-brand-blue transition">
          Dashboard
        </Link>
        <span>/</span>
        <Link href={`/student/module/${slug}`} className="hover:text-brand-blue transition">
          {mod.title}
        </Link>
        <span>/</span>
        <span className="text-brand-blue font-semibold">{lesson.title}</span>
      </div>

      {/* Title */}
      <div>
        <h1
          className="text-4xl text-brand-blue leading-tight"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          {lesson.title.toUpperCase()}
        </h1>
      </div>

      {/* Content */}
      {lesson.content && (
        <div className="card prose prose-sm max-w-none">
          <ReactMarkdown
            components={{
              h2: ({ children }) => (
                <h2
                  style={{ fontFamily: "var(--font-bebas)", color: "#1A35F4", fontSize: "1.5rem" }}
                >
                  {children}
                </h2>
              ),
              h3: ({ children }) => (
                <h3 style={{ fontFamily: "var(--font-bebas)", color: "#1A35F4" }}>
                  {children}
                </h3>
              ),
              blockquote: ({ children }) => (
                <div className="callout">{children}</div>
              ),
            }}
          >
            {lesson.content}
          </ReactMarkdown>
        </div>
      )}

      {/* Exercises */}
      {exercises.length > 0 && (
        <section>
          <h2
            className="text-2xl text-brand-blue mb-4"
            style={{ fontFamily: "var(--font-bebas)" }}
          >
            OEFENINGEN
          </h2>
          <div className="flex flex-col gap-6">
            {exercises.map((exercise, idx) => {
              const exSubmissions = submissionsByExercise[exercise.id] ?? [];
              const lastSubmission = exSubmissions[exSubmissions.length - 1];

              return (
                <div key={exercise.id} className="flex flex-col gap-3">
                  <div className="flex items-start gap-3">
                    <div className="w-8 h-8 rounded-full bg-pink text-white flex items-center justify-center text-sm font-bold shrink-0 mt-0.5">
                      {idx + 1}
                    </div>
                    <div className="flex-1">
                      <h3
                        className="text-lg text-brand-blue"
                        style={{ fontFamily: "var(--font-bebas)" }}
                      >
                        {exercise.title.toUpperCase()}
                      </h3>
                      {exercise.type !== "recording" && (
                        <span className="text-xs bg-gray-100 text-gray-600 rounded-full px-2 py-0.5">
                          {exercise.type === "reading" ? "Leesoefening" : "Zelfevaluatie"}
                        </span>
                      )}
                    </div>
                  </div>

                  {exercise.instructions && (
                    <div className="callout ml-11">
                      <p className="text-sm">{exercise.instructions}</p>
                    </div>
                  )}

                  {/* Recording exercise */}
                  {exercise.type === "recording" && (
                    <div className="ml-11">
                      <AudioRecorder
                        exerciseId={exercise.id}
                        existingSubmissions={exSubmissions}
                      />

                      {/* Teacher feedback */}
                      {lastSubmission &&
                        (lastSubmission as Submission & { feedback: { id: string; text: string; created_at: string }[] }).feedback?.length > 0 && (
                          <div className="mt-3 callout">
                            <p className="text-xs font-bold text-brand-blue mb-1">
                              Feedback van de leerkracht
                            </p>
                            {(lastSubmission as Submission & { feedback: { id: string; text: string; created_at: string }[] }).feedback.map((fb) => (
                              <p key={fb.id} className="text-sm text-gray-700">
                                {fb.text}
                              </p>
                            ))}
                          </div>
                        )}
                    </div>
                  )}

                  {/* Reading / self-assessment exercise */}
                  {exercise.type !== "recording" && exSubmissions.length === 0 && (
                    <div className="ml-11">
                      <MarkExerciseDoneButton exerciseId={exercise.id} />
                    </div>
                  )}
                  {exercise.type !== "recording" && exSubmissions.length > 0 && (
                    <div className="ml-11 callout text-sm text-gray-700">
                      ✓ Voltooid
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </section>
      )}

      {/* Prev / Next */}
      <div className="flex gap-3 mt-2">
        {prevLesson ? (
          <Link
            href={`/student/module/${slug}/${prevLesson.slug}`}
            className="flex-1 py-3 text-center rounded-xl border-2 border-brand-blue text-brand-blue font-bold hover:bg-brand-blue hover:text-white transition text-sm"
          >
            ← {prevLesson.title}
          </Link>
        ) : (
          <div className="flex-1" />
        )}
        {nextLesson ? (
          <Link
            href={`/student/module/${slug}/${nextLesson.slug}`}
            className="flex-1 py-3 text-center rounded-xl bg-brand-blue text-white font-bold hover:opacity-90 transition text-sm"
          >
            {nextLesson.title} →
          </Link>
        ) : (
          <Link
            href={`/student/module/${slug}`}
            className="flex-1 py-3 text-center rounded-xl bg-pink text-white font-bold hover:opacity-90 transition text-sm"
          >
            Module overzicht →
          </Link>
        )}
      </div>
    </div>
  );
}

// Small client component to mark reading/self-assessment as done
import MarkExerciseDoneButton from "./MarkExerciseDoneButton";
