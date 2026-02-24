import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import Link from "next/link";
import StudentNav from "./StudentNav";

export default async function StudentLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect("/login");

  const { data: profile } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user.id)
    .single();

  if (!profile || profile.role !== "student") redirect("/login");

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      <StudentNav profile={profile} />
      <main className="flex-1 w-full max-w-2xl mx-auto px-4 py-6">
        {children}
      </main>
    </div>
  );
}
