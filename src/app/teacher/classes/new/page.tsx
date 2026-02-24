"use client";

import { useTransition } from "react";
import { createClass } from "@/app/actions/classes";
import Link from "next/link";

export default function NewClassPage() {
  const [isPending, startTransition] = useTransition();

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);
    startTransition(() => createClass(formData));
  };

  return (
    <div className="flex flex-col gap-6">
      <div>
        <Link
          href="/teacher/dashboard"
          className="text-sm text-gray-500 hover:text-brand-blue transition"
        >
          ← Terug
        </Link>
        <h1
          className="text-4xl text-brand-blue mt-2"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          NIEUWE KLAS AANMAKEN
        </h1>
      </div>

      <div className="callout">
        <p className="text-sm text-gray-700">
          Na het aanmaken ontvang je automatisch een unieke 6-tekens klascode die
          je met je leerlingen deelt.
        </p>
      </div>

      <form onSubmit={handleSubmit} className="card flex flex-col gap-5">
        <div>
          <label className="block text-sm font-bold text-gray-700 mb-2">
            Naam van de klas
          </label>
          <input
            type="text"
            name="name"
            placeholder="bv. 5de jaar A – Stem & Audio"
            className="w-full border-2 border-gray-300 rounded-xl px-4 py-3 text-base focus:outline-none focus:border-brand-blue"
            required
            autoFocus
          />
        </div>

        <button
          type="submit"
          disabled={isPending}
          className="w-full py-4 bg-brand-blue text-white rounded-xl font-bold text-lg hover:opacity-90 active:scale-95 transition disabled:opacity-50"
        >
          {isPending ? "Aanmaken..." : "Klas aanmaken"}
        </button>
      </form>
    </div>
  );
}
