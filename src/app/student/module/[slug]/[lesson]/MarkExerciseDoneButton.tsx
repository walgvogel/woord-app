"use client";

import { useState, useTransition } from "react";
import { createSubmission } from "@/app/actions/submissions";

export default function MarkExerciseDoneButton({ exerciseId }: { exerciseId: string }) {
  const [done, setDone] = useState(false);
  const [isPending, startTransition] = useTransition();

  const handleClick = () => {
    startTransition(async () => {
      await createSubmission(exerciseId, "", 0);
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
    <button
      onClick={handleClick}
      disabled={isPending}
      className="w-full py-3 rounded-xl bg-brand-blue text-white font-bold hover:opacity-90 active:scale-95 transition disabled:opacity-50"
    >
      {isPending ? "Laden..." : "Markeer als voltooid"}
    </button>
  );
}
