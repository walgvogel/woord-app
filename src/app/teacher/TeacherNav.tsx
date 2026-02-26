"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import type { Profile } from "@/types/database";

export default function TeacherNav({ profile }: { profile: Profile }) {
  const pathname = usePathname();
  const router = useRouter();

  const handleSignOut = async () => {
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push("/login");
  };

  const navLinks = [
    { href: "/teacher/dashboard", label: "Klassen" },
    { href: "/teacher/submissions", label: "Opnames" },
  ];

  return (
    <nav className="bg-brand-blue text-white sticky top-0 z-50 shadow-md">
      <div className="max-w-3xl mx-auto px-4 h-14 flex items-center justify-between">
        <Link
          href="/teacher/dashboard"
          className="font-heading text-2xl text-pink"
          style={{ fontFamily: "var(--font-bebas)" }}
        >
          AUDIO WOORD
        </Link>

        <div className="flex items-center gap-3">
          {navLinks.map((link) => (
            <Link
              key={link.href}
              href={link.href}
              className={`text-sm font-semibold px-3 py-1 rounded-lg transition ${
                pathname.startsWith(link.href)
                  ? "bg-pink text-white"
                  : "hover:bg-white/10"
              }`}
            >
              {link.label}
            </Link>
          ))}
          <Link
            href="/teacher/profile"
            className={`text-sm font-semibold px-3 py-1 rounded-lg transition ${
              pathname === "/teacher/profile"
                ? "bg-pink text-white"
                : "hover:bg-white/10"
            }`}
          >
            {profile.display_name ?? "Profiel"}
          </Link>
          <button
            onClick={handleSignOut}
            style={{ cursor: "pointer" }}
            className="text-sm font-semibold px-3 py-1 rounded-lg text-white hover:bg-white/10 transition"
          >
            Uitloggen
          </button>
        </div>
      </div>
    </nav>
  );
}
