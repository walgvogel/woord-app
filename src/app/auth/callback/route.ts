import { createServerClient, type CookieOptions } from "@supabase/ssr";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");

  if (code) {
    const cookiesToSet: { name: string; value: string; options: CookieOptions }[] = [];

    const supabase = createServerClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
      {
        cookies: {
          getAll() {
            return request.cookies.getAll();
          },
          setAll(cookies) {
            cookiesToSet.push(...cookies);
          },
        },
      }
    );

    const { data, error } = await supabase.auth.exchangeCodeForSession(code);

    if (!error && data.user) {
      // Profile is created by DB trigger — may need a moment to propagate.
      // Retry up to 3 times with short delays.
      let profile: { role: string } | null = null;
      for (let i = 0; i < 3; i++) {
        const { data: p } = await supabase
          .from("profiles")
          .select("role")
          .eq("id", data.user.id)
          .single();
        if (p) {
          profile = p;
          break;
        }
        await new Promise((r) => setTimeout(r, 200));
      }

      const destination =
        profile?.role === "teacher"
          ? `${origin}/teacher/dashboard`
          : `${origin}/student/dashboard`;

      const response = NextResponse.redirect(destination);
      cookiesToSet.forEach(({ name, value, options }) =>
        response.cookies.set(name, value, options)
      );
      return response;
    }
  }

  return NextResponse.redirect(`${origin}/login?error=auth`);
}
