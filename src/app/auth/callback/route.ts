import { createServerClient, type CookieOptions } from "@supabase/ssr";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");

  if (code) {
    // Collect cookies Supabase wants to set so we can attach them to the redirect response
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
      // Check if profile exists; if not, create one
      const { data: profile } = await supabase
        .from("profiles")
        .select("id, role")
        .eq("id", data.user.id)
        .single();

      if (!profile) {
        await supabase.from("profiles").insert({
          id: data.user.id,
          role: "student",
          display_name: data.user.user_metadata?.full_name ?? data.user.email,
          avatar_url: data.user.user_metadata?.avatar_url ?? null,
        });
      }

      const destination =
        !profile || profile.role !== "teacher"
          ? `${origin}/student/dashboard`
          : `${origin}/teacher/dashboard`;

      // Build the redirect and attach session cookies to it
      const response = NextResponse.redirect(destination);
      cookiesToSet.forEach(({ name, value, options }) =>
        response.cookies.set(name, value, options)
      );
      return response;
    }
  }

  return NextResponse.redirect(`${origin}/login?error=auth`);
}
