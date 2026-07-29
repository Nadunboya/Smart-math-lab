import { redirect } from "next/navigation";
import { createClient } from "../lib/supabase/server";
import HomeClient from "./HomeClient";
import { StudentProfile, Unit } from "./lib/types";

export default async function Page() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect("/login");
  }

  const {
    data: { session },
  } = await supabase.auth.getSession();

  const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";
  const profileRes = await fetch(`${apiUrl}/api/students/me`, {
    headers: { Authorization: `Bearer ${session?.access_token}` },
    cache: "no-store",
  });

  if (profileRes.status === 404) {
    redirect("/onboarding");
  }

  if (!profileRes.ok) {
    throw new Error("Could not load student profile from the backend.");
  }

  const profile: StudentProfile = await profileRes.json();

  // Curriculum content is the same for every student in a grade and the
  // endpoint requires no auth, so this fetch is cached and shared across
  // every student in the grade rather than hitting the backend per user.
  const unitsRes = await fetch(`${apiUrl}/api/units?grade=${profile.grade}`, {
    next: { revalidate: 300 },
  });

  if (!unitsRes.ok) {
    throw new Error("Could not load units from the backend.");
  }

  const units: Unit[] = await unitsRes.json();

  return <HomeClient profile={profile} units={units} />;
}
