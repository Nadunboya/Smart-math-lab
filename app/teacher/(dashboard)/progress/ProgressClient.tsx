"use client";

import { useState } from "react";
import { StudentProgress } from "../../../lib/types";
import { createClient } from "../../../../lib/supabase/client";

export default function ProgressClient({
  grades,
  initialGrade,
  initialProgress,
}: {
  grades: number[];
  initialGrade: number;
  initialProgress: StudentProgress[];
}) {
  const [grade, setGrade] = useState(initialGrade);
  const [progress, setProgress] = useState(initialProgress);
  const [loading, setLoading] = useState(false);
  const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

  const loadGrade = async (g: number) => {
    setGrade(g);
    setLoading(true);

    const supabase = createClient();
    const {
      data: { session },
    } = await supabase.auth.getSession();

    const res = await fetch(`${apiUrl}/api/teachers/progress?grade=${g}`, {
      headers: { Authorization: `Bearer ${session?.access_token}` },
      cache: "no-store",
    });
    setProgress(res.ok ? await res.json() : []);
    setLoading(false);
  };

  return (
    <div>
      <div className="mb-6">
        <h1 className="font-heading font-bold text-2xl text-white mb-1">
          Student Progress
        </h1>
        <p className="text-sm text-slate">
          How each student is doing on Math Engine practice questions.
        </p>
      </div>

      <div className="flex flex-wrap gap-2 mb-6">
        {grades.map((g) => (
          <button
            key={g}
            onClick={() => loadGrade(g)}
            className={`px-3 py-1.5 rounded-xl text-xs font-semibold border transition-colors ${
              grade === g
                ? "bg-cyan/10 text-cyan border-cyan/30"
                : "bg-card-navy text-slate border-white/[0.08] hover:border-white/20"
            }`}
          >
            Grade {g}
          </button>
        ))}
      </div>

      {loading ? (
        <p className="text-sm text-slate">Loading…</p>
      ) : progress.length === 0 ? (
        <div className="rounded-2xl border border-white/[0.06] bg-card-navy p-10 text-center">
          <p className="text-white/70 font-medium mb-1">No students yet</p>
          <p className="text-sm text-slate">
            No onboarded students in Grade {grade} yet.
          </p>
        </div>
      ) : (
        <div className="rounded-2xl border border-white/[0.06] bg-card-navy overflow-hidden">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-white/[0.06] text-left">
                <th className="px-4 py-3 font-medium text-slate">Student</th>
                <th className="px-4 py-3 font-medium text-slate">Solved</th>
                <th className="px-4 py-3 font-medium text-slate">Passed</th>
                <th className="px-4 py-3 font-medium text-slate">Attempted</th>
                <th className="px-4 py-3 font-medium text-slate">Progress</th>
                <th className="px-4 py-3 font-medium text-slate">
                  Last active
                </th>
              </tr>
            </thead>
            <tbody>
              {progress.map((p) => {
                const pct =
                  p.questions_total > 0
                    ? Math.round((p.questions_solved / p.questions_total) * 100)
                    : 0;
                return (
                  <tr
                    key={p.student_id}
                    className="border-b border-white/[0.04] last:border-0"
                  >
                    <td className="px-4 py-3 text-white font-medium">
                      {p.student_name}
                    </td>
                    <td className="px-4 py-3 text-white/70">
                      {p.questions_solved}
                    </td>
                    <td className="px-4 py-3 text-white/70">
                      {p.questions_passed}
                    </td>
                    <td className="px-4 py-3 text-white/70">
                      {p.questions_attempted}
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-2">
                        <div className="w-24 h-1.5 rounded-full bg-white/10 overflow-hidden">
                          <div
                            className="h-full rounded-full bg-cyan"
                            style={{ width: `${pct}%` }}
                          />
                        </div>
                        <span className="text-xs text-slate">
                          {pct}% of {p.questions_total}
                        </span>
                      </div>
                    </td>
                    <td className="px-4 py-3 text-xs text-slate">
                      {p.last_activity_at
                        ? new Date(p.last_activity_at).toLocaleDateString()
                        : "—"}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
