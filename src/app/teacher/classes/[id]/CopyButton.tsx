"use client";

import { useState } from "react";

export default function CopyButton({ code }: { code: string }) {
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    await navigator.clipboard.writeText(code);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <button
      onClick={handleCopy}
      className="px-5 py-3 rounded-xl bg-pink text-white font-bold text-sm hover:opacity-90 active:scale-95 transition shrink-0"
    >
      {copied ? "Gekopieerd! ✓" : "Kopieer code"}
    </button>
  );
}
