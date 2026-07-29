"use client";

import { useState, FormEvent } from "react";
import { useRouter } from "next/navigation";
import { Unit } from "../../../lib/types";
import { UnitIcons } from "../../../lib/icons";
import { createClient } from "../../../../lib/supabase/client";

const ICON_KEYS = Object.keys(UnitIcons);

interface ConceptRow {
  name: string;
  description: string;
}

interface NoteRow {
  content: string;
}

export default function UnitEditorForm({
  grades,
  initialUnit,
}: {
  grades: number[];
  initialUnit?: Unit;
}) {
  const router = useRouter();
  const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";
  const isEditing = Boolean(initialUnit);

  const [grade, setGrade] = useState(initialUnit?.grade ?? grades[0]);
  const [name, setName] = useState(initialUnit?.name ?? "");
  const [sinhalaName, setSinhalaName] = useState(initialUnit?.sinhala_name ?? "");
  const [accentColor, setAccentColor] = useState(initialUnit?.accent_color ?? "#5B4FE5");
  const [iconKey, setIconKey] = useState(initialUnit?.icon_key ?? ICON_KEYS[0]);
  const [description, setDescription] = useState(initialUnit?.description ?? "");
  const [sortOrder, setSortOrder] = useState(initialUnit?.sort_order ?? 0);
  const [concepts, setConcepts] = useState<ConceptRow[]>(
    initialUnit?.concepts.map((c) => ({ name: c.name, description: c.description })) ?? [],
  );
  const [notes, setNotes] = useState<NoteRow[]>(
    initialUnit?.short_notes.map((n) => ({ content: n.content })) ?? [],
  );
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const updateConcept = (i: number, field: keyof ConceptRow, value: string) =>
    setConcepts((prev) => prev.map((c, ci) => (ci === i ? { ...c, [field]: value } : c)));

  const updateNote = (i: number, value: string) =>
    setNotes((prev) => prev.map((n, ni) => (ni === i ? { content: value } : n)));

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setError(null);

    if (!name.trim() || !description.trim()) {
      setError("Name and description are required.");
      return;
    }

    setSubmitting(true);
    const supabase = createClient();
    const {
      data: { session },
    } = await supabase.auth.getSession();

    if (!session) {
      router.replace("/login");
      return;
    }

    const body = {
      grade,
      name: name.trim(),
      sinhala_name: sinhalaName.trim() || null,
      accent_color: accentColor,
      icon_key: iconKey,
      description: description.trim(),
      sort_order: sortOrder,
      concepts: concepts
        .filter((c) => c.name.trim() && c.description.trim())
        .map((c, i) => ({ name: c.name.trim(), description: c.description.trim(), sort_order: i })),
      short_notes: notes
        .filter((n) => n.content.trim())
        .map((n, i) => ({ content: n.content.trim(), sort_order: i })),
    };

    try {
      const res = await fetch(
        isEditing ? `${apiUrl}/api/units/${initialUnit!.id}` : `${apiUrl}/api/units`,
        {
          method: isEditing ? "PUT" : "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${session.access_token}`,
          },
          body: JSON.stringify(body),
        },
      );

      if (!res.ok) {
        const errBody = await res.json().catch(() => null);
        throw new Error(errBody?.detail ?? "Could not save the unit.");
      }

      await fetch("/api/revalidate-units", { method: "POST" });
      router.replace("/teacher");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Something went wrong.");
      setSubmitting(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6 max-w-2xl">
      <div>
        <h1 className="font-heading font-bold text-2xl text-white mb-1">
          {isEditing ? "Edit Unit" : "New Unit"}
        </h1>
        <p className="text-sm text-slate">
          {isEditing
            ? "Changes apply immediately for students on this grade."
            : "This unit becomes visible to students on the selected grade right away."}
        </p>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <Field label="Grade" required>
          <select
            value={grade}
            onChange={(e) => setGrade(Number(e.target.value))}
            className={inputClass}
          >
            {grades.map((g) => (
              <option key={g} value={g}>
                Grade {g}
              </option>
            ))}
          </select>
        </Field>

        <Field label="Icon" required>
          <select
            value={iconKey}
            onChange={(e) => setIconKey(e.target.value)}
            className={inputClass}
          >
            {ICON_KEYS.map((key) => (
              <option key={key} value={key}>
                {key}
              </option>
            ))}
          </select>
        </Field>
      </div>

      <Field label="Sort order">
        <input
          type="number"
          value={sortOrder}
          onChange={(e) => setSortOrder(Number(e.target.value))}
          className={inputClass}
        />
        <span className="block text-xs text-slate mt-1">
          Lower numbers appear first among Grade {grade} units.
        </span>
      </Field>

      <Field label="Unit name" required>
        <input
          type="text"
          required
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="e.g. Fractions"
          className={inputClass}
        />
      </Field>

      <Field label="Sinhala name">
        <input
          type="text"
          value={sinhalaName}
          onChange={(e) => setSinhalaName(e.target.value)}
          placeholder="Optional"
          className={inputClass}
        />
      </Field>

      <Field label="Accent color">
        <div className="flex items-center gap-3">
          <input
            type="color"
            value={accentColor}
            onChange={(e) => setAccentColor(e.target.value)}
            className="w-12 h-10 rounded-lg border border-white/[0.08] bg-deep"
          />
          <input
            type="text"
            value={accentColor}
            onChange={(e) => setAccentColor(e.target.value)}
            className={inputClass}
          />
        </div>
      </Field>

      <Field label="Description" required>
        <textarea
          required
          rows={3}
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          className={`${inputClass} resize-none`}
        />
      </Field>

      <div>
        <div className="flex items-center justify-between mb-2">
          <span className="text-xs font-medium text-white/70">Concepts</span>
          <button
            type="button"
            onClick={() => setConcepts((prev) => [...prev, { name: "", description: "" }])}
            className="text-xs text-cyan hover:underline"
          >
            + Add concept
          </button>
        </div>
        <div className="space-y-3">
          {concepts.map((c, i) => (
            <div key={i} className="rounded-xl border border-white/[0.06] bg-deep p-3 space-y-2">
              <div className="flex items-center gap-2">
                <input
                  type="text"
                  value={c.name}
                  onChange={(e) => updateConcept(i, "name", e.target.value)}
                  placeholder="Concept name"
                  className={inputClass}
                />
                <button
                  type="button"
                  onClick={() => setConcepts((prev) => prev.filter((_, ci) => ci !== i))}
                  className="text-xs text-red-400 hover:text-red-300 flex-shrink-0"
                >
                  Remove
                </button>
              </div>
              <textarea
                value={c.description}
                onChange={(e) => updateConcept(i, "description", e.target.value)}
                placeholder="Concept description"
                rows={2}
                className={`${inputClass} resize-none`}
              />
            </div>
          ))}
        </div>
      </div>

      <div>
        <div className="flex items-center justify-between mb-2">
          <span className="text-xs font-medium text-white/70">Short notes</span>
          <button
            type="button"
            onClick={() => setNotes((prev) => [...prev, { content: "" }])}
            className="text-xs text-cyan hover:underline"
          >
            + Add note
          </button>
        </div>
        <div className="space-y-2">
          {notes.map((n, i) => (
            <div key={i} className="flex items-center gap-2">
              <input
                type="text"
                value={n.content}
                onChange={(e) => updateNote(i, e.target.value)}
                placeholder="Short note"
                className={inputClass}
              />
              <button
                type="button"
                onClick={() => setNotes((prev) => prev.filter((_, ni) => ni !== i))}
                className="text-xs text-red-400 hover:text-red-300 flex-shrink-0"
              >
                Remove
              </button>
            </div>
          ))}
        </div>
      </div>

      {error && <p className="text-red-400 text-sm">{error}</p>}

      <button
        type="submit"
        disabled={submitting}
        className="rounded-xl bg-gradient-to-r from-cosmic to-nebula text-white font-medium text-sm px-6 py-3 shadow-glow-cosmic hover:opacity-90 transition-opacity disabled:opacity-60 disabled:cursor-not-allowed"
      >
        {submitting ? "Saving…" : isEditing ? "Save Changes" : "Create Unit"}
      </button>
    </form>
  );
}

const inputClass =
  "w-full rounded-xl bg-deep border border-white/[0.08] text-white text-sm placeholder:text-slate/60 px-4 py-2.5 focus:outline-none focus:border-cyan/50 transition-colors";

function Field({
  label,
  required,
  children,
}: {
  label: string;
  required?: boolean;
  children: React.ReactNode;
}) {
  return (
    <label className="block">
      <span className="block text-xs font-medium text-white/70 mb-1.5">
        {label}
        {required && <span className="text-cyan ml-1">*</span>}
      </span>
      {children}
    </label>
  );
}
