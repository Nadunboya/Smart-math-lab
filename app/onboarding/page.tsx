"use client";

import { useState, useEffect, FormEvent } from "react";
import { useRouter } from "next/navigation";
import { motion } from "framer-motion";
import { Icons } from "../lib/icons";
import { createClient } from "../../lib/supabase/client";

const GRADES = Array.from({ length: 6 }, (_, i) => i + 6);

interface FormState {
  studentName: string;
  grade: string;
  guardianName: string;
  guardianPhone: string;
  otherPhone: string;
  address: string;
}

const INITIAL_STATE: FormState = {
  studentName: "",
  grade: "",
  guardianName: "",
  guardianPhone: "",
  otherPhone: "",
  address: "",
};

export default function OnboardingPage() {
  const router = useRouter();
  const [email, setEmail] = useState<string | null>(null);
  const [checking, setChecking] = useState(true);
  const [form, setForm] = useState<FormState>(INITIAL_STATE);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const supabase = createClient();
    const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

    (async () => {
      const {
        data: { session },
      } = await supabase.auth.getSession();

      if (!session) {
        router.replace("/login");
        return;
      }

      setEmail(session.user.email ?? null);

      // If the profile already exists (e.g. user navigated back here), skip straight to home.
      const res = await fetch(`${apiUrl}/api/students/me`, {
        headers: { Authorization: `Bearer ${session.access_token}` },
        cache: "no-store",
      });

      if (res.ok) {
        router.replace("/");
        return;
      }

      setChecking(false);
    })();
  }, [router]);

  const update =
    (field: keyof FormState) =>
    (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) =>
      setForm((prev) => ({ ...prev, [field]: e.target.value }));

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setError(null);

    if (
      !form.studentName.trim() ||
      !form.grade ||
      !form.guardianName.trim() ||
      !form.guardianPhone.trim() ||
      !form.address.trim()
    ) {
      setError("Please fill in all required fields.");
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

    const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

    try {
      const res = await fetch(`${apiUrl}/api/students`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${session.access_token}`,
        },
        body: JSON.stringify({
          student_name: form.studentName.trim(),
          grade: Number(form.grade),
          guardian_name: form.guardianName.trim(),
          guardian_phone: form.guardianPhone.trim(),
          other_phone: form.otherPhone.trim() || null,
          address: form.address.trim(),
        }),
      });

      if (!res.ok) {
        const body = await res.json().catch(() => null);
        throw new Error(body?.detail ?? "Could not save your profile.");
      }

      router.replace("/");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Something went wrong.");
      setSubmitting(false);
    }
  };

  if (checking) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className="text-slate text-sm">Loading…</p>
      </div>
    );
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-4 py-12">
      <motion.div
        initial={{ opacity: 0, y: 24 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5, ease: [0.4, 0, 0.2, 1] }}
        className="w-full max-w-lg rounded-3xl border border-white/[0.06] bg-card-navy p-8 md:p-10 shadow-card-dark"
      >
        <div className="flex items-center gap-3 mb-2">
          <div className="w-11 h-11 rounded-xl bg-gradient-to-br from-cosmic to-nebula flex items-center justify-center shadow-glow-cosmic">
            <Icons.user size={22} color="#fff" />
          </div>
          <div>
            <h1 className="font-heading font-bold text-xl text-white">
              Just one more step
            </h1>
            {email && (
              <p className="text-xs text-slate mt-0.5">Signed in as {email}</p>
            )}
          </div>
        </div>
        <p className="text-sm text-slate mb-6 mt-2">
          Tell us a bit about the student so we can personalize the learning
          guide.
        </p>

        <form onSubmit={handleSubmit} className="space-y-4">
          <Field label="Student name" required>
            <input
              type="text"
              required
              value={form.studentName}
              onChange={update("studentName")}
              placeholder="Full name of the student"
              className={inputClass}
            />
          </Field>

          <Field label="Grade" required>
            <select
              required
              value={form.grade}
              onChange={update("grade")}
              className={inputClass}
            >
              <option value="" disabled>
                Select grade
              </option>
              {GRADES.map((g) => (
                <option key={g} value={g}>
                  Grade {g}
                </option>
              ))}
            </select>
          </Field>

          <Field label="Guardian name" required>
            <input
              type="text"
              required
              value={form.guardianName}
              onChange={update("guardianName")}
              placeholder="Parent / guardian full name"
              className={inputClass}
            />
          </Field>

          <Field label="Guardian phone number" required>
            <input
              type="tel"
              required
              value={form.guardianPhone}
              onChange={update("guardianPhone")}
              placeholder="e.g. 077 123 4567"
              className={inputClass}
            />
          </Field>

          <Field label="Other phone number">
            <input
              type="tel"
              value={form.otherPhone}
              onChange={update("otherPhone")}
              placeholder="Optional alternate contact number"
              className={inputClass}
            />
          </Field>

          <Field label="Address" required>
            <textarea
              required
              rows={3}
              value={form.address}
              onChange={update("address")}
              placeholder="Home address"
              className={`${inputClass} resize-none`}
            />
          </Field>

          {error && <p className="text-red-400 text-sm">{error}</p>}

          <button
            type="submit"
            disabled={submitting}
            className="w-full rounded-xl bg-gradient-to-r from-cosmic to-nebula text-white font-medium text-sm py-3.5 mt-2 shadow-glow-cosmic hover:opacity-90 transition-opacity disabled:opacity-60 disabled:cursor-not-allowed"
          >
            {submitting ? "Saving…" : "Continue"}
          </button>
        </form>
      </motion.div>
    </div>
  );
}

const inputClass =
  "w-full rounded-xl bg-deep border border-white/[0.08] text-white text-sm placeholder:text-slate/60 px-4 py-3 focus:outline-none focus:border-cyan/50 transition-colors";

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
