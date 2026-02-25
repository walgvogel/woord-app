"use client";

import { useState, useTransition } from "react";
import { createSubmission } from "@/app/actions/submissions";

export default function MarkExerciseDoneButton({ exerciseId }: { exerciseId: string }) {
  const [done, setDone] = useState(false);
  const [reflectionText, setReflectionText] = useState("");
  const [isPending, startTransition] = useTransition();

  const handleClick = () => {
    startTransition(async () => {
      await createSubmission(exerciseId, "", 0, reflectionText.trim() || undefined);
      setDone(true);
    });
  };

  if (done) {
    return (
      <div className="callout text-sm text-gray-700">
        ✓ Voltooid
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-3">
      <textarea
        value={reflectionText}
        onChange={(e) => setReflectionText(e.target.value)}
        placeholder="Reflectie (optioneel) – wat heb je geleerd of geoefend?"
        rows={3}
        className="w-full rounded-xl border-2 border-gray-200 px-3 py-2 text-sm text-gray-700 resize-none focus:outline-none focus:border-brand-blue transition"
      />
      <button
        onClick={handleClick}
        disabled={isPending}
        className="w-full py-3 rounded-xl bg-brand-blue text-white font-bold hover:opacity-90 active:scale-95 transition disabled:opacity-50"
      >
        {isPending ? "Laden..." : "Markeer als voltooid"}
      </button>
    </div>
  );
}
