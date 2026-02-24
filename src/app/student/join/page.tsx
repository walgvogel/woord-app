"use client";

import { useState, useTransition } from "react";
import { joinClass } from "@/app/actions/classes";
import Link from "next/link";

export default function JoinPage() {
  const [code, setCode] = useState("");
  const [result, setResult] = useState<{ error?: string; success?: boolean; className?: string } | null>(null);
  const [isPending, startTransition] = useTransition();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const formData = new FormData();
    formData.set("code", code);
    startTransition(async () => {
      const res = await joinClass(formData);
      setResult(res);
    });
  };

  return (
    <div className="flex flex-col gap-6">
      <div>
        <Link href="/student/dashboard" className="text-sm text-gray-500 hover:text-brand-blue transition">
          ← Terug
        </Link>
        <h1
          className="text-4xl text-brand-blue mt-2"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          KLAS JOINEN
        </h1>
      </div>

      <div className="callout">
        <p className="text-sm text-gray-700">
          Vraag je leerkracht om de 6-tekens klascode en vul hem hieronder in.
        </p>
      </div>

      {result?.success ? (
        <div className="card text-center flex flex-col gap-3">
          <span className="text-5xl">🎉</span>
          <h2
            className="text-2xl text-brand-blue"
            style={{ fontFamily: "var(--font-bebas)" }}
          >
            WELKOM IN DE KLAS!
          </h2>
          <p className="text-gray-600">Je bent nu lid van <strong>{result.className}</strong>.</p>
          <Link
            href="/student/dashboard"
            className="inline-block mt-2 px-6 py-3 bg-pink text-white rounded-xl font-bold hover:opacity-90 transition"
          >
            Naar dashboard
          </Link>
        </div>
      ) : (
        <form onSubmit={handleSubmit} className="card flex flex-col gap-5">
          <div>
            <label className="block text-sm font-bold text-gray-700 mb-2">
              Klascode
            </label>
            <input
              type="text"
              value={code}
              onChange={(e) => setCode(e.target.value.toUpperCase())}
              maxLength={6}
              placeholder="bv. ABC123"
              className="w-full text-center text-3xl font-bold tracking-widest border-2 border-gray-300 rounded-xl p-4 focus:outline-none focus:border-brand-blue uppercase"
              required
            />
          </div>

          {result?.error && (
            <p className="text-sm text-red-600 bg-red-50 rounded-lg p-3">
              {result.error}
            </p>
          )}

          <button
            type="submit"
            disabled={isPending || code.length !== 6}
            className="w-full py-4 bg-brand-blue text-white rounded-xl font-bold text-lg hover:opacity-90 active:scale-95 transition disabled:opacity-50"
          >
            {isPending ? "Laden..." : "Klas joinen"}
          </button>
        </form>
      )}
    </div>
  );
}
