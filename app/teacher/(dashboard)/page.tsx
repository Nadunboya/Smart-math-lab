import { redirect } from "next/navigation";
import { createClient } from "../../../lib/supabase/server";
import { TeacherProfile, Unit } from "../../lib/types";
import TeacherDashboardClient from "./TeacherDashboardClient";

export default async function TeacherDashboardPage() {
  const supabase = await createClient();
  const {
    data: { session },
  } = await supabase.auth.getSession();

  if (!session) {
    redirect("/login");
  }

  const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

  const teacherRes = await fetch(`${apiUrl}/api/teachers/me`, {
    headers: { Authorization: `Bearer ${session.access_token}` },
    cache: "no-store",
  });

  if (!teacherRes.ok) {
    redirect("/teacher/onboarding");
  }

  const teacher: TeacherProfile = await teacherRes.json();
  const initialGrade = teacher.grades[0];

  const unitsRes = await fetch(`${apiUrl}/api/units?grade=${initialGrade}`, {
    cache: "no-store",
  });
  const initialUnits: Unit[] = unitsRes.ok ? await unitsRes.json() : [];

  return (
    <TeacherDashboardClient
      grades={teacher.grades}
      initialGrade={initialGrade}
      initialUnits={initialUnits}
    />
  );
}
