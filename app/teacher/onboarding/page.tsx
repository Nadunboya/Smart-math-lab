"use client";

import { useState, useEffect, FormEvent } from "react";
import { useRouter } from "next/navigation";
import { motion } from "framer-motion";
import { Icons } from "../../lib/icons";
import { createClient } from "../../../lib/supabase/client";

const GRADES = Array.from({ length: 13 }, (_, i) => i + 1);

export default function TeacherOnboardingPage() {
  const router = useRouter();
  const [email, setEmail] = useState<string | null>(null);
  const [checking, setChecking] = useState(true);
  const [fullName, setFullName] = useState("");
  const [phone, setPhone] = useState("");
  const [bio, setBio] = useState("");
  const [grades, setGrades] = useState<number[]>([]);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

  useEffect(() => {
    const supabase = createClient();

    (async () => {
      const {
        data: { session },
      } = await supabase.auth.getSession();

      if (!session) {
        router.replace("/login");
        return;
      }

      setEmail(session.user.email ?? null);

      const res = await fetch(`${apiUrl}/api/teachers/lookup`, {
        headers: { Authorization: `Bearer ${session.access_token}` },
        cache: "no-store",
      });

      if (!res.ok) {
        // Not an invited teacher — this page isn't for them.
        router.replace("/");
        return;
      }

      const invite = await res.json();
      if (invite.onboarded) {
        router.replace("/teacher");
        return;
      }

      setChecking(false);
    })();
  }, [router, apiUrl]);

  const toggleGrade = (grade: number) => {
    setGrades((prev) =>
      prev.includes(grade) ? prev.filter((g) => g !== grade) : [...prev, grade].sort((a, b) => a - b),
    );
  };

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setError(null);

    if (!fullName.trim() || !phone.trim() || grades.length === 0) {
      setError("Please fill in your name, phone number, and select at least one grade.");
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

    try {
      const res = await fetch(`${apiUrl}/api/teachers/complete`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${session.access_token}`,
        },
        body: JSON.stringify({
          full_name: fullName.trim(),
          phone: phone.trim(),
          bio: bio.trim() || null,
          grades,
        }),
      });

      if (!res.ok) {
        const body = await res.json().catch(() => null);
        throw new Error(body?.detail ?? "Could not save your profile.");
      }

      router.replace("/teacher");
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
              Welcome, teacher
            </h1>
            {email && (
              <p className="text-xs text-slate mt-0.5">Signed in as {email}</p>
            )}
          </div>
        </div>
        <p className="text-sm text-slate mb-6 mt-2">
          Tell us about yourself and which grades you teach — this determines
          which units you can create and edit.
        </p>

        <form onSubmit={handleSubmit} className="space-y-4">
          <label className="block">
            <span className="block text-xs font-medium text-white/70 mb-1.5">
              Full name<span className="text-cyan ml-1">*</span>
            </span>
            <input
              type="text"
              required
              value={fullName}
              onChange={(e) => setFullName(e.target.value)}
              placeholder="Your full name"
              className={inputClass}
            />
          </label>

          <label className="block">
            <span className="block text-xs font-medium text-white/70 mb-1.5">
              Phone number<span className="text-cyan ml-1">*</span>
            </span>
            <input
              type="tel"
              required
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
              placeholder="e.g. 077 123 4567"
              className={inputClass}
            />
          </label>

          <label className="block">
            <span className="block text-xs font-medium text-white/70 mb-1.5">
              Short bio
            </span>
            <textarea
              rows={3}
              value={bio}
              onChange={(e) => setBio(e.target.value)}
              placeholder="Optional — shown to students"
              className={`${inputClass} resize-none`}
            />
          </label>

          <div>
            <span className="block text-xs font-medium text-white/70 mb-2">
              Grades you teach<span className="text-cyan ml-1">*</span>
            </span>
            <div className="flex flex-wrap gap-2">
              {GRADES.map((g) => {
                const active = grades.includes(g);
                return (
                  <button
                    key={g}
                    type="button"
                    onClick={() => toggleGrade(g)}
                    className={`px-3 py-1.5 rounded-xl text-xs font-semibold border transition-colors ${
                      active
                        ? "bg-cyan/10 text-cyan border-cyan/30"
                        : "bg-deep text-slate border-white/[0.08] hover:border-white/20"
                    }`}
                  >
                    Grade {g}
                  </button>
                );
              })}
            </div>
          </div>

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
