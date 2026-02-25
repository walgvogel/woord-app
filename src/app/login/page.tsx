"use client";

import { createClient } from "@/lib/supabase/client";
import { useState } from "react";

export default function LoginPage() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleGoogleLogin = async () => {
    setLoading(true);
    setError(null);
    const supabase = createClient();
    const { error } = await supabase.auth.signInWithOAuth({
      provider: "google",
      options: {
        redirectTo: `${window.location.origin}/auth/callback`,
      },
    });
    if (error) {
      setError("Inloggen mislukt. Probeer opnieuw.");
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-light-pink px-4">
      {/* Logo / header */}
      <div className="mb-10 text-center">
        <h1
          className="text-7xl text-brand-blue leading-none"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          AUDIO
        </h1>
        <h1
          className="text-7xl text-pink leading-none -mt-2"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          WOORD
        </h1>
        <p className="mt-3 text-base text-gray-600 font-medium">
          Stemoefeningen voor de klas
        </p>
      </div>

      {/* Card */}
      <div className="w-full max-w-sm bg-white rounded-2xl border-2 border-brand-blue shadow-lg p-8 flex flex-col gap-5">
        <div className="text-center">
          <h2
            className="text-2xl text-brand-blue"
            style={{ fontFamily: "var(--font-bebas)" }}
          >
            WELKOM TERUG
          </h2>
          <p className="text-sm text-gray-500 mt-1">
            Log in met je Google-account om verder te gaan.
          </p>
        </div>

        {error && (
          <div className="callout text-sm text-red-700">{error}</div>
        )}

        <button
          onClick={handleGoogleLogin}
          disabled={loading}
          className="flex items-center justify-center gap-3 w-full py-4 rounded-xl bg-brand-blue text-white font-bold text-base hover:opacity-90 active:scale-95 transition disabled:opacity-60"
        >
          {loading ? (
            <span>Laden...</span>
          ) : (
            <>
              <GoogleIcon />
              <span>Inloggen met Google</span>
            </>
          )}
        </button>

        <p className="text-center text-xs text-gray-400">
          Door in te loggen ga je akkoord met het gebruik van deze app voor
          educatieve doeleinden.
        </p>
      </div>

      {/* Footer */}
      <p className="mt-8 text-xs text-gray-400">
        Audio Woord cursus – Emma Ducheyne &amp; Emi Catteeuw
      </p>
    </div>
  );
}

function GoogleIcon() {
  return (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
      <path
        d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
        fill="#4285F4"
      />
      <path
        d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
        fill="#34A853"
      />
      <path
        d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
        fill="#FBBC05"
      />
      <path
        d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
        fill="#EA4335"
      />
    </svg>
  );
}
