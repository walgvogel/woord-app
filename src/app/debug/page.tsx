import { createClient } from "@/lib/supabase/server";

export default async function DebugPage() {
  const supabase = await createClient();
  const { data: { user }, error: userError } = await supabase.auth.getUser();
  const { data: { session } } = await supabase.auth.getSession();

  let profile = null;
  let profileError = null;
  if (user) {
    const result = await supabase
      .from("profiles")
      .select("*")
      .eq("id", user.id)
      .single();
    profile = result.data;
    profileError = result.error;
  }

  return (
    <div style={{ fontFamily: "monospace", padding: "2rem", maxWidth: "800px" }}>
      <h1>Debug – Sessie Status</h1>

      <h2>Gebruiker</h2>
      {userError && <p style={{ color: "red" }}>Fout: {userError.message}</p>}
      {user ? (
        <pre style={{ background: "#f0f0f0", padding: "1rem" }}>
          {JSON.stringify({ id: user.id, email: user.email, provider: user.app_metadata?.provider }, null, 2)}
        </pre>
      ) : (
        <p style={{ color: "red" }}>❌ Geen gebruiker – sessie niet aanwezig</p>
      )}

      <h2>Sessie</h2>
      {session ? (
        <p style={{ color: "green" }}>✅ Sessie actief</p>
      ) : (
        <p style={{ color: "red" }}>❌ Geen sessie</p>
      )}

      <h2>Profiel in database</h2>
      {profileError && <p style={{ color: "red" }}>Fout: {profileError.message}</p>}
      {profile ? (
        <pre style={{ background: "#f0f0f0", padding: "1rem" }}>
          {JSON.stringify(profile, null, 2)}
        </pre>
      ) : user ? (
        <p style={{ color: "red" }}>❌ Geen profiel gevonden voor deze gebruiker</p>
      ) : (
        <p>–</p>
      )}
    </div>
  );
}
