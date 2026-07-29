"use client";

import { useState } from "react";
import Link from "next/link";
import { Unit } from "../../lib/types";
import { Icons } from "../../lib/icons";
import { createClient } from "../../../lib/supabase/client";

export default function TeacherDashboardClient({
  grades,
  initialGrade,
  initialUnits,
}: {
  grades: number[];
  initialGrade: number;
  initialUnits: Unit[];
}) {
  const [grade, setGrade] = useState(initialGrade);
  const [units, setUnits] = useState(initialUnits);
  const [loading, setLoading] = useState(false);
  const [deletingId, setDeletingId] = useState<number | null>(null);
  const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

  const loadGrade = async (g: number) => {
    setGrade(g);
    setLoading(true);
    const res = await fetch(`${apiUrl}/api/units?grade=${g}`, {
      cache: "no-store",
    });
    setUnits(res.ok ? await res.json() : []);
    setLoading(false);
  };

  const handleDelete = async (unitId: number) => {
    if (!confirm("Delete this unit? This also removes its concepts and short notes.")) {
      return;
    }
    setDeletingId(unitId);
    const supabase = createClient();
    const {
      data: { session },
    } = await supabase.auth.getSession();

    await fetch(`${apiUrl}/api/units/${unitId}`, {
      method: "DELETE",
      headers: { Authorization: `Bearer ${session?.access_token}` },
    });

    setUnits((prev) => prev.filter((u) => u.id !== unitId));
    setDeletingId(null);
  };

  return (
    <div>
      <div className="flex items-center justify-between mb-6 flex-wrap gap-4">
        <div>
          <h1 className="font-heading font-bold text-2xl text-white mb-1">
            Units
          </h1>
          <p className="text-sm text-slate">
            Manage the Math Lab content students see.
          </p>
        </div>
        <Link
          href="/teacher/units/new"
          className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-gradient-to-r from-cosmic to-nebula text-white text-sm font-medium shadow-glow-cosmic hover:opacity-90 transition-opacity"
        >
          + New Unit
        </Link>
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
      ) : units.length === 0 ? (
        <div className="rounded-2xl border border-white/[0.06] bg-card-navy p-10 text-center">
          <p className="text-white/70 font-medium mb-1">No units yet</p>
          <p className="text-sm text-slate">
            Create the first unit for Grade {grade}.
          </p>
        </div>
      ) : (
        <div className="space-y-3">
          {units.map((unit) => (
            <div
              key={unit.id}
              className="flex items-center justify-between gap-4 rounded-2xl border border-white/[0.06] bg-card-navy p-4"
            >
              <div className="min-w-0">
                <div className="flex items-center gap-2">
                  <span
                    className="w-2 h-2 rounded-full flex-shrink-0"
                    style={{ background: unit.accent_color }}
                  />
                  <h3 className="font-heading font-semibold text-sm text-white truncate">
                    {unit.name}
                  </h3>
                </div>
                <p className="text-xs text-slate mt-1 truncate">
                  {unit.concepts.length} concepts · {unit.short_notes.length}{" "}
                  short notes
                </p>
              </div>
              <div className="flex items-center gap-2 flex-shrink-0">
                <Link
                  href={`/teacher/units/${unit.id}`}
                  className="px-3 py-1.5 rounded-lg text-xs font-medium text-white/70 hover:text-white hover:bg-white/5 border border-white/[0.06] transition-colors"
                >
                  Edit
                </Link>
                <button
                  onClick={() => handleDelete(unit.id)}
                  disabled={deletingId === unit.id}
                  className="p-1.5 rounded-lg text-red-400 hover:text-red-300 hover:bg-red-500/5 transition-colors disabled:opacity-50"
                  aria-label={`Delete ${unit.name}`}
                >
                  <Icons.trash size={14} color="currentColor" />
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
