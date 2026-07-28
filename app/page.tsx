import { redirect } from "next/navigation";
import { createClient } from "../lib/supabase/server";
import HomeClient from "./HomeClient";
import { StudentProfile } from "./lib/types";

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
  const res = await fetch(`${apiUrl}/api/students/me`, {
    headers: { Authorization: `Bearer ${session?.access_token}` },
    cache: "no-store",
  });

  if (res.status === 404) {
    redirect("/onboarding");
  }

  if (!res.ok) {
    throw new Error("Could not load student profile from the backend.");
  }

  const profile: StudentProfile = await res.json();

  return <HomeClient profile={profile} />;
}
