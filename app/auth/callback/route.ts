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
      const authHeader = { Authorization: `Bearer ${data.session.access_token}` };

      try {
        // Invited teacher emails never go through student onboarding — check
        // this first so a pre-provisioned teacher account is routed correctly
        // regardless of whether onboarding is already complete.
        const teacherRes = await fetch(`${apiUrl}/api/teachers/lookup`, {
          headers: authHeader,
          cache: "no-store",
        });

        if (teacherRes.ok) {
          const teacher = await teacherRes.json();
          return NextResponse.redirect(
            `${origin}${teacher.onboarded ? "/teacher" : "/teacher/onboarding"}`,
          );
        }

        const studentRes = await fetch(`${apiUrl}/api/students/me`, {
          headers: authHeader,
          cache: "no-store",
        });

        if (studentRes.status === 404) {
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
