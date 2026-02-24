"use client";

import { useState, useRef } from "react";
import { createClient } from "@/lib/supabase/client";
import { createSubmission } from "@/app/actions/submissions";
import StarRating from "./StarRating";
import type { Submission } from "@/types/database";

type RecorderState =
  | "idle"
  | "requesting"
  | "recording"
  | "recorded"
  | "uploading"
  | "submitted";

interface AudioRecorderProps {
  exerciseId: string;
  existingSubmissions: Submission[];
  onSubmitted?: () => void;
}

export default function AudioRecorder({
  exerciseId,
  existingSubmissions,
  onSubmitted,
}: AudioRecorderProps) {
  const [state, setState] = useState<RecorderState>("idle");
  const [audioBlob, setAudioBlob] = useState<Blob | null>(null);
  const [localAudioUrl, setLocalAudioUrl] = useState<string | null>(null);
  const [selfScore, setSelfScore] = useState(3);
  const [error, setError] = useState<string | null>(null);
  const [elapsed, setElapsed] = useState(0);

  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const chunksRef = useRef<BlobPart[]>([]);
  const streamRef = useRef<MediaStream | null>(null);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const audioRef = useRef<HTMLAudioElement | null>(null);

  const startRecording = async () => {
    setError(null);
    setState("requesting");
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      streamRef.current = stream;

      const mimeType = MediaRecorder.isTypeSupported("audio/webm;codecs=opus")
        ? "audio/webm;codecs=opus"
        : MediaRecorder.isTypeSupported("audio/webm")
        ? "audio/webm"
        : "audio/mp4";

      const mediaRecorder = new MediaRecorder(stream, { mimeType });
      mediaRecorderRef.current = mediaRecorder;
      chunksRef.current = [];

      mediaRecorder.ondataavailable = (e) => {
        if (e.data.size > 0) chunksRef.current.push(e.data);
      };

      mediaRecorder.onstop = () => {
        const blob = new Blob(chunksRef.current, { type: mimeType });
        setAudioBlob(blob);
        if (localAudioUrl) URL.revokeObjectURL(localAudioUrl);
        setLocalAudioUrl(URL.createObjectURL(blob));
        setState("recorded");
        if (timerRef.current) clearInterval(timerRef.current);
      };

      mediaRecorder.start(250);
      setState("recording");
      setElapsed(0);
      timerRef.current = setInterval(() => setElapsed((e) => e + 1), 1000);
    } catch {
      setError(
        "Kon geen toegang krijgen tot de microfoon. Controleer je browserinstellingen."
      );
      setState("idle");
    }
  };

  const stopRecording = () => {
    mediaRecorderRef.current?.stop();
    streamRef.current?.getTracks().forEach((t) => t.stop());
    if (timerRef.current) clearInterval(timerRef.current);
  };

  const reset = () => {
    if (localAudioUrl) URL.revokeObjectURL(localAudioUrl);
    setAudioBlob(null);
    setLocalAudioUrl(null);
    setState("idle");
    setElapsed(0);
    setError(null);
  };

  const handleSubmit = async () => {
    if (!audioBlob) return;
    setState("uploading");
    setError(null);

    try {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();

      if (!user) throw new Error("Niet ingelogd");

      const ext = audioBlob.type.includes("mp4") ? "mp4" : "webm";
      const filename = `${user.id}/${exerciseId}/${Date.now()}.${ext}`;

      const { error: uploadError } = await supabase.storage
        .from("recordings")
        .upload(filename, audioBlob, {
          contentType: audioBlob.type,
          upsert: false,
        });

      if (uploadError) throw uploadError;

      // Store the storage path (not a public URL); signed URLs are generated server-side
      await createSubmission(exerciseId, filename, selfScore);
      setState("submitted");
      onSubmitted?.();
    } catch (err) {
      setError(
        err instanceof Error ? err.message : "Upload mislukt. Probeer opnieuw."
      );
      setState("recorded");
    }
  };

  const formatTime = (s: number) =>
    `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;

  const attemptNumber = existingSubmissions.length + 1;

  return (
    <div className="flex flex-col gap-4">
      {/* Previous submissions */}
      {existingSubmissions.length > 0 && (
        <div className="callout text-sm">
          <p className="font-bold text-brand-blue mb-2">
            Eerdere pogingen ({existingSubmissions.length})
          </p>
          <div className="flex flex-col gap-2">
            {existingSubmissions.map((sub) => (
              <div
                key={sub.id}
                className="flex items-center gap-3 bg-white rounded-lg p-2"
              >
                <span className="text-xs text-gray-500 shrink-0">
                  Poging {sub.attempt_number}
                </span>
                {sub.audio_url && (
                  <audio
                    src={sub.audio_url}
                    controls
                    className="flex-1 h-8"
                    style={{ minWidth: 0 }}
                  />
                )}
                {sub.self_score !== null && (
                  <span className="text-xs shrink-0">
                    {"⭐".repeat(sub.self_score)}
                  </span>
                )}
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Recorder */}
      <div className="bg-white rounded-xl border-2 border-brand-blue p-5 flex flex-col gap-4">
        <div className="flex items-center justify-between">
          <h3
            className="text-lg text-brand-blue"
            style={{ fontFamily: "var(--font-bebas)" }}
          >
            POGING {attemptNumber}
          </h3>
          {state === "recording" && (
            <span className="flex items-center gap-2 text-red-500 text-sm font-bold animate-pulse-pink">
              <span className="w-2 h-2 rounded-full bg-red-500" />
              {formatTime(elapsed)}
            </span>
          )}
        </div>

        {error && (
          <p className="text-sm text-red-600 bg-red-50 rounded-lg p-3">
            {error}
          </p>
        )}

        {/* Controls */}
        {(state === "idle" || state === "requesting") && (
          <button
            onClick={startRecording}
            disabled={state === "requesting"}
            className="flex items-center justify-center gap-3 w-full py-5 rounded-xl bg-pink text-white font-bold text-lg hover:opacity-90 active:scale-95 transition disabled:opacity-50"
          >
            <MicIcon />
            {state === "requesting" ? "Microfoon activeren..." : "Begin opname"}
          </button>
        )}

        {state === "recording" && (
          <button
            onClick={stopRecording}
            className="flex items-center justify-center gap-3 w-full py-5 rounded-xl bg-red-500 text-white font-bold text-lg hover:opacity-90 active:scale-95 transition"
          >
            <StopIcon />
            Stop opname
          </button>
        )}

        {(state === "recorded" || state === "uploading" || state === "submitted") && (
          <div className="flex flex-col gap-4">
            {/* Playback */}
            {localAudioUrl && (
              <audio
                ref={audioRef}
                src={localAudioUrl}
                controls
                className="w-full"
              />
            )}

            {state !== "submitted" && (
              <>
                {/* Self assessment */}
                <div>
                  <p className="text-sm font-semibold text-gray-700 mb-2">
                    Hoe beoordeel je jezelf?
                  </p>
                  <StarRating value={selfScore} onChange={setSelfScore} />
                </div>

                {/* Action buttons */}
                <div className="flex gap-3">
                  <button
                    onClick={reset}
                    disabled={state === "uploading"}
                    className="flex-1 py-4 rounded-xl border-2 border-gray-300 text-gray-700 font-bold hover:bg-gray-50 active:scale-95 transition disabled:opacity-50"
                  >
                    Opnieuw opnemen
                  </button>
                  <button
                    onClick={handleSubmit}
                    disabled={state === "uploading"}
                    className="flex-1 py-4 rounded-xl bg-brand-blue text-white font-bold hover:opacity-90 active:scale-95 transition disabled:opacity-50"
                  >
                    {state === "uploading" ? "Bezig..." : "Indienen"}
                  </button>
                </div>
              </>
            )}

            {state === "submitted" && (
              <div className="callout text-center">
                <p className="text-lg font-bold text-brand-blue">
                  Ingediend! 🎉
                </p>
                <p className="text-sm text-gray-600 mt-1">
                  Je opname is opgeslagen. Je kunt altijd nog een nieuwe poging
                  doen.
                </p>
                <button
                  onClick={reset}
                  className="mt-3 px-6 py-3 rounded-xl bg-pink text-white font-bold hover:opacity-90 active:scale-95 transition"
                >
                  Nog een poging
                </button>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

function MicIcon() {
  return (
    <svg
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={2}
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <path d="M12 2a3 3 0 0 0-3 3v7a3 3 0 0 0 6 0V5a3 3 0 0 0-3-3Z" />
      <path d="M19 10v2a7 7 0 0 1-14 0v-2" />
      <line x1="12" x2="12" y1="19" y2="22" />
    </svg>
  );
}

function StopIcon() {
  return (
    <svg
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="currentColor"
    >
      <rect x="4" y="4" width="16" height="16" rx="2" />
    </svg>
  );
}
