# Audio Woord – Setup gids

## Vereisten

- Node.js 18+
- Supabase account (supabase.com)
- Google Cloud Console project (voor OAuth)

---

## Stap 1: Supabase project aanmaken

1. Ga naar [supabase.com](https://supabase.com) en maak een nieuw project aan
2. Noteer je **Project URL** en **Anon Key** (Settings → API)

---

## Stap 2: Database instellen

Ga in Supabase naar **SQL Editor** en voer de volgende bestanden uit (in volgorde):

1. `supabase/schema.sql` – tabellen + RLS policies
2. `supabase/storage.sql` – storage bucket voor opnames
3. `supabase/seed.sql` – cursusinhoud (modules, lessen, oefeningen, badges)

---

## Stap 3: Google OAuth instellen

1. Ga naar [Google Cloud Console](https://console.cloud.google.com)
2. Maak een nieuw project of gebruik een bestaand
3. Ga naar **APIs & Services → Credentials → OAuth 2.0 Client IDs**
4. Voeg toe als Authorized redirect URI:
   ```
   https://<jouw-project>.supabase.co/auth/v1/callback
   ```
5. Kopieer Client ID en Client Secret

In Supabase:
- Ga naar **Authentication → Providers → Google**
- Plak Client ID en Client Secret
- Schakel Google in

---

## Stap 4: Storage bucket instellen

Als `supabase/storage.sql` niet werkt:
1. Ga naar **Storage** in Supabase Dashboard
2. Klik **New bucket** → naam: `recordings` → zet **Public** aan
3. Voeg de storage policies uit `storage.sql` manueel toe via **Storage → Policies**

---

## Stap 5: Environment variables

Kopieer het voorbeeld bestand:
```bash
cp .env.local.example .env.local
```

Vul in:
```
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=jouw-anon-key
```

---

## Stap 6: Eerste leerkracht aanmaken

Na het aanmaken van je eerste account (via Google OAuth) wordt automatisch een **student** profiel aangemaakt.

Om een leerkracht te maken:
1. Log in als de te promoveren gebruiker
2. Ga in Supabase naar **Table Editor → profiles**
3. Zoek het record en verander `role` van `student` naar `teacher`

Of via SQL:
```sql
UPDATE profiles SET role = 'teacher' WHERE id = 'jouw-user-id';
```

---

## Stap 7: Opstarten

```bash
cd woord-app
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000)

---

## Productie (Vercel)

1. Push naar GitHub
2. Importeer repo in [vercel.com](https://vercel.com)
3. Voeg environment variables toe (zelfde als `.env.local`)
4. In Supabase → Authentication → URL Configuration:
   - Site URL: `https://jouw-app.vercel.app`
   - Redirect URLs: `https://jouw-app.vercel.app/**`

---

## Pagina-overzicht

| URL | Rol | Beschrijving |
|-----|-----|--------------|
| `/login` | Iedereen | Google OAuth inlogpagina |
| `/student/dashboard` | Leerling | Voortgang + modules + badges |
| `/student/join` | Leerling | Klas joinen via code |
| `/student/module/:slug` | Leerling | Lessenlijst per module |
| `/student/module/:slug/:lesson` | Leerling | Les + opname-interface |
| `/student/profile` | Leerling | Profiel + badges |
| `/teacher/dashboard` | Leerkracht | Klassen-overzicht |
| `/teacher/classes/new` | Leerkracht | Nieuwe klas aanmaken |
| `/teacher/classes/:id` | Leerkracht | Klas + leerlingenlijst |
| `/teacher/classes/:id/students/:studentId` | Leerkracht | Leerling-voortgang |
| `/teacher/submissions` | Leerkracht | Alle opnames |
| `/teacher/submissions/:id` | Leerkracht | Opname beluisteren + feedback |
