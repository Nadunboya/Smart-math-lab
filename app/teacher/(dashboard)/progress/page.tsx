import { redirect } from "next/navigation";
import { createClient } from "../../../../lib/supabase/server";
import { TeacherProfile, StudentProgress } from "../../../lib/types";
import ProgressClient from "./ProgressClient";

export default async function TeacherProgressPage() {
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

  const progressRes = await fetch(
    `${apiUrl}/api/teachers/progress?grade=${initialGrade}`,
    {
      headers: { Authorization: `Bearer ${session.access_token}` },
      cache: "no-store",
    },
  );
  const initialProgress: StudentProgress[] = progressRes.ok
    ? await progressRes.json()
    : [];

  return (
    <ProgressClient
      grades={teacher.grades}
      initialGrade={initialGrade}
      initialProgress={initialProgress}
    />
  );
}
