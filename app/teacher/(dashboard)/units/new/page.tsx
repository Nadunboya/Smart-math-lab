import { redirect } from "next/navigation";
import { createClient } from "../../../../../lib/supabase/server";
import { TeacherProfile } from "../../../../lib/types";
import UnitEditorForm from "../UnitEditorForm";

export default async function NewUnitPage() {
  const supabase = await createClient();
  const {
    data: { session },
  } = await supabase.auth.getSession();

  if (!session) {
    redirect("/login");
  }

  const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";
  const res = await fetch(`${apiUrl}/api/teachers/me`, {
    headers: { Authorization: `Bearer ${session.access_token}` },
    cache: "no-store",
  });

  if (!res.ok) {
    redirect("/teacher/onboarding");
  }

  const teacher: TeacherProfile = await res.json();

  return <UnitEditorForm grades={teacher.grades} />;
}
