"use client";

import { useState, useTransition } from "react";
import {
  createClassExercise,
  updateClassExercise,
  deleteClassExercise,
} from "@/app/actions/exercises";

interface ClassExercise {
  id: string;
  title: string;
  instructions: string | null;
}

export default function ClassExercisesSection({
  classId,
  initialExercises,
}: {
  classId: string;
  initialExercises: ClassExercise[];
}) {
  const [exercises, setExercises] = useState<ClassExercise[]>(initialExercises);
  const [title, setTitle] = useState("");
  const [instructions, setInstructions] = useState("");
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editTitle, setEditTitle] = useState("");
  const [editInstructions, setEditInstructions] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();

  const handleAdd = () => {
    if (!title.trim()) return;
    setError(null);
    startTransition(async () => {
      try {
        const ex = await createClassExercise(classId, title.trim(), instructions);
        setExercises((prev) => [...prev, ex as ClassExercise]);
        setTitle("");
        setInstructions("");
      } catch {
        setError("Kon de oefening niet aanmaken. Probeer opnieuw.");
      }
    });
  };

  const handleStartEdit = (ex: ClassExercise) => {
    setEditingId(ex.id);
    setEditTitle(ex.title);
    setEditInstructions(ex.instructions ?? "");
  };

  const handleSaveEdit = () => {
    if (!editingId || !editTitle.trim()) return;
    setError(null);
    startTransition(async () => {
      try {
        await updateClassExercise(editingId, classId, editTitle.trim(), editInstructions);
        setExercises((prev) =>
          prev.map((ex) =>
            ex.id === editingId
              ? { ...ex, title: editTitle.trim(), instructions: editInstructions.trim() || null }
              : ex
          )
        );
        setEditingId(null);
      } catch {
        setError("Kon de oefening niet opslaan. Probeer opnieuw.");
      }
    });
  };

  const handleDelete = (id: string) => {
    setError(null);
    startTransition(async () => {
      try {
        await deleteClassExercise(id, classId);
        setExercises((prev) => prev.filter((ex) => ex.id !== id));
      } catch {
        setError("Kon de oefening niet verwijderen. Probeer opnieuw.");
      }
    });
  };

  return (
    <section className="flex flex-col gap-4">
      <h2
        className="text-2xl text-brand-blue"
        style={{ fontFamily: "var(--font-bebas)" }}
      >
        EIGEN TEKSTEN ({exercises.length})
      </h2>

      {error && (
        <p className="text-sm text-red-600 bg-red-50 rounded-lg p-3">{error}</p>
      )}

      {/* Toevoegen */}
      <div className="card flex flex-col gap-3">
        <p className="text-sm font-semibold text-gray-700">Nieuwe tekst toevoegen</p>
        <input
          type="text"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          placeholder="Titel (bijv. 'Introductietekst week 3')"
          className="w-full rounded-xl border-2 border-gray-200 px-3 py-2 text-sm focus:outline-none focus:border-brand-blue transition"
        />
        <textarea
          value={instructions}
          onChange={(e) => setInstructions(e.target.value)}
          placeholder="Tekst om in te spreken..."
          rows={4}
          className="w-full rounded-xl border-2 border-gray-200 px-3 py-2 text-sm resize-none focus:outline-none focus:border-brand-blue transition"
        />
        <button
          onClick={handleAdd}
          disabled={!title.trim() || isPending}
          className="self-end px-6 py-2 rounded-xl bg-brand-blue text-white text-sm font-bold hover:opacity-90 active:scale-95 transition disabled:opacity-50"
        >
          {isPending ? "Bezig..." : "+ Toevoegen"}
        </button>
      </div>

      {/* Lijst */}
      {exercises.length === 0 ? (
        <div className="callout text-center py-4">
          <p className="text-sm text-gray-500">
            Nog geen eigen teksten. Voeg er een toe hierboven.
          </p>
        </div>
      ) : (
        <div className="flex flex-col gap-3">
          {exercises.map((ex) =>
            editingId === ex.id ? (
              <div key={ex.id} className="card flex flex-col gap-3 border-pink">
                <input
                  type="text"
                  value={editTitle}
                  onChange={(e) => setEditTitle(e.target.value)}
                  className="w-full rounded-xl border-2 border-gray-200 px-3 py-2 text-sm focus:outline-none focus:border-brand-blue transition"
                />
                <textarea
                  value={editInstructions}
                  onChange={(e) => setEditInstructions(e.target.value)}
                  rows={4}
                  className="w-full rounded-xl border-2 border-gray-200 px-3 py-2 text-sm resize-none focus:outline-none focus:border-brand-blue transition"
                />
                <div className="flex gap-2">
                  <button
                    onClick={handleSaveEdit}
                    disabled={isPending || !editTitle.trim()}
                    className="flex-1 py-2 rounded-xl bg-brand-blue text-white text-sm font-bold hover:opacity-90 transition disabled:opacity-50"
                  >
                    Opslaan
                  </button>
                  <button
                    onClick={() => setEditingId(null)}
                    className="flex-1 py-2 rounded-xl border-2 border-gray-300 text-gray-700 text-sm font-bold hover:bg-gray-50 transition"
                  >
                    Annuleren
                  </button>
                </div>
              </div>
            ) : (
              <div key={ex.id} className="card flex items-start gap-3">
                <div className="flex-1 min-w-0">
                  <p className="font-bold text-brand-blue">{ex.title}</p>
                  {ex.instructions && (
                    <p className="text-sm text-gray-600 mt-1 whitespace-pre-wrap line-clamp-3">
                      {ex.instructions}
                    </p>
                  )}
                </div>
                <div className="flex gap-2 shrink-0">
                  <button
                    onClick={() => handleStartEdit(ex)}
                    className="text-xs px-3 py-1 rounded-lg border-2 border-brand-blue text-brand-blue font-bold hover:bg-brand-blue hover:text-white transition"
                  >
                    Bewerken
                  </button>
                  <button
                    onClick={() => handleDelete(ex.id)}
                    disabled={isPending}
                    className="text-xs px-3 py-1 rounded-lg border-2 border-red-300 text-red-500 font-bold hover:bg-red-50 transition disabled:opacity-50"
                  >
                    Verwijderen
                  </button>
                </div>
              </div>
            )
          )}
        </div>
      )}
    </section>
  );
}
