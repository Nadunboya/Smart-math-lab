import { NextResponse } from "next/server";
import { createClient } from "../../../lib/supabase/server";

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");

  if (code) {
    const supabase = await createClient();
    const { data, error } = await supabase.auth.exchangeCodeForSession(code);

    if (!error && data.session) {
      const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

      try {
        const res = await fetch(`${apiUrl}/api/students/me`, {
          headers: { Authorization: `Bearer ${data.session.access_token}` },
          cache: "no-store",
        });

        if (res.status === 404) {
          return NextResponse.redirect(`${origin}/onboarding`);
        }
      } catch {
        // Backend unreachable — send to onboarding, which re-checks before creating a profile.
        return NextResponse.redirect(`${origin}/onboarding`);
      }

      return NextResponse.redirect(`${origin}/`);
    }
  }

  return NextResponse.redirect(`${origin}/login?error=auth_failed`);
}
