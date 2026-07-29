import { redirect } from "next/navigation";
import { createClient } from "../../../lib/supabase/server";
import { TeacherProfile } from "../../lib/types";
import TeacherShell from "./TeacherShell";

export default async function TeacherDashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
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
  const res = await fetch(`${apiUrl}/api/teachers/me`, {
    headers: { Authorization: `Bearer ${session?.access_token}` },
    cache: "no-store",
  });

  if (res.status === 404 || res.status === 403) {
    redirect("/teacher/onboarding");
  }

  if (!res.ok) {
    throw new Error("Could not load teacher profile from the backend.");
  }

  const teacher: TeacherProfile = await res.json();

  return <TeacherShell teacher={teacher}>{children}</TeacherShell>;
}
