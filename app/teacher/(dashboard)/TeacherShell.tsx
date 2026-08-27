"use client";

import { useRouter, usePathname } from "next/navigation";
import Link from "next/link";
import { Icons } from "../../lib/icons";
import { TeacherProfile } from "../../lib/types";
import { createClient } from "../../../lib/supabase/client";

export default function TeacherShell({
  teacher,
  children,
}: {
  teacher: TeacherProfile;
  children: React.ReactNode;
}) {
  const router = useRouter();
  const pathname = usePathname();

  const handleLogout = async () => {
    const supabase = createClient();
    await supabase.auth.signOut();
    router.replace("/login");
  };

  return (
    <div className="min-h-screen relative z-[1]">
      <nav className="border-b border-white/[0.06] bg-deep">
        <div className="max-w-5xl mx-auto px-4 md:px-8 h-16 flex items-center justify-between">
          <Link href="/teacher" className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-cosmic to-nebula flex items-center justify-center">
              <Icons.flask size={16} color="#fff" />
            </div>
            <span className="font-heading font-bold text-sm text-white">
              SmartMathLab <span className="text-slate font-normal">— Teacher</span>
            </span>
          </Link>

          <div className="flex items-center gap-4">
            <div className="text-right hidden sm:block">
              <p className="text-sm text-white font-medium">{teacher.full_name}</p>
              <p className="text-xs text-slate">
                Grades {teacher.grades.join(", ")}
              </p>
            </div>
            <button
              onClick={handleLogout}
              className="flex items-center gap-2 px-3 py-2 rounded-xl text-sm text-slate hover:text-white hover:bg-white/5 transition-all border border-white/[0.06]"
            >
              <Icons.logout size={16} />
              <span className="hidden sm:inline">Log Out</span>
            </button>
          </div>
        </div>
      </nav>

      <div className="border-b border-white/[0.06] bg-deep">
        <div className="max-w-5xl mx-auto px-4 md:px-8 flex items-center gap-6">
          <Link
            href="/teacher"
            className={`nav-tab ${pathname === "/teacher" ? "active" : ""}`}
          >
            Units
          </Link>
          <Link
            href="/teacher/progress"
            className={`nav-tab ${pathname === "/teacher/progress" ? "active" : ""}`}
          >
            Progress
          </Link>
        </div>
      </div>

      <main className="max-w-5xl mx-auto px-4 md:px-8 py-10">{children}</main>
    </div>
  );
}
