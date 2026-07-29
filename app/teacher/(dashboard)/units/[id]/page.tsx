import { notFound, redirect } from "next/navigation";
import { createClient } from "../../../../../lib/supabase/server";
import { TeacherProfile, Unit } from "../../../../lib/types";
import UnitEditorForm from "../UnitEditorForm";

export default async function EditUnitPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;

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

  const unitRes = await fetch(`${apiUrl}/api/units/${id}`, {
    cache: "no-store",
  });

  if (unitRes.status === 404) {
    notFound();
  }

  if (!unitRes.ok) {
    throw new Error("Could not load this unit from the backend.");
  }

  const unit: Unit = await unitRes.json();

  return <UnitEditorForm grades={teacher.grades} initialUnit={unit} />;
}
