import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");
  const next = searchParams.get("next") ?? "/";

  if (code) {
    const cookieStore = await cookies();
    const supabase = createServerClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
      {
        cookies: {
          getAll() {
            return cookieStore.getAll();
          },
          setAll(cookiesToSet) {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            );
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
        // Create a new student profile by default
        // Teachers can be upgraded manually via Supabase dashboard or a separate flow
        await supabase.from("profiles").insert({
          id: data.user.id,
          role: "student",
          display_name: data.user.user_metadata?.full_name ?? data.user.email,
          avatar_url: data.user.user_metadata?.avatar_url ?? null,
        });

        return NextResponse.redirect(`${origin}/student/dashboard`);
      }

      const destination =
        profile.role === "teacher"
          ? `${origin}/teacher/dashboard`
          : `${origin}/student/dashboard`;

      return NextResponse.redirect(destination);
    }
  }

  return NextResponse.redirect(`${origin}/login?error=auth`);
}
