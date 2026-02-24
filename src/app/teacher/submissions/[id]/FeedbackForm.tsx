"use client";

import { useState, useTransition } from "react";
import { submitFeedback } from "@/app/actions/submissions";

export default function FeedbackForm({ submissionId }: { submissionId: string }) {
  const [text, setText] = useState("");
  const [sent, setSent] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!text.trim()) return;
    setError(null);
    startTransition(async () => {
      try {
        await submitFeedback(submissionId, text.trim());
        setSent(true);
        setText("");
      } catch {
        setError("Feedback kon niet opgeslagen worden. Probeer opnieuw.");
      }
    });
  };

  return (
    <form onSubmit={handleSubmit} className="card flex flex-col gap-4">
      <h3
        className="text-lg text-brand-blue"
        style={{ fontFamily: "var(--font-bebas)" }}
      >
        FEEDBACK TOEVOEGEN
      </h3>

      {sent && (
        <div className="callout text-sm text-gray-700">
          ✓ Feedback opgeslagen! De leerling kan dit nu lezen.
        </div>
      )}

      {error && (
        <p className="text-sm text-red-600 bg-red-50 rounded-lg p-3">{error}</p>
      )}

      <textarea
        value={text}
        onChange={(e) => setText(e.target.value)}
        placeholder="Typ hier je feedback voor de leerling..."
        rows={4}
        className="w-full border-2 border-gray-300 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-brand-blue resize-none"
        required
      />

      <button
        type="submit"
        disabled={isPending || !text.trim()}
        className="w-full py-4 bg-brand-blue text-white rounded-xl font-bold hover:opacity-90 active:scale-95 transition disabled:opacity-50"
      >
        {isPending ? "Opslaan..." : "Feedback indienen"}
      </button>
    </form>
  );
}
