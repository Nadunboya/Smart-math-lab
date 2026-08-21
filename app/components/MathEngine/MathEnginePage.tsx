"use client";

import { FormEvent, useCallback, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import { Icons } from "../../lib/icons";
import { createClient } from "../../../lib/supabase/client";
import { AnswerResult, NextQuestion, StudentProfile } from "../../lib/types";

const DIFFICULTY_COLOR: Record<string, string> = {
  easy: "#00D9C0",
  medium: "#FF7A45",
  hard: "#8B5CF6",
};

const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

export default function MathEnginePage({ profile }: { profile: StudentProfile }) {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [question, setQuestion] = useState<NextQuestion | null>(null);
  const [done, setDone] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [answer, setAnswer] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [result, setResult] = useState<AnswerResult | null>(null);

  const authHeaders = useCallback(async () => {
    const supabase = createClient();
    const {
      data: { session },
    } = await supabase.auth.getSession();

    if (!session) {
      router.replace("/login");
      return null;
    }

    return { Authorization: `Bearer ${session.access_token}` };
  }, [router]);

  const loadNextQuestion = useCallback(async () => {
    setLoading(true);
    setError(null);
    setResult(null);
    setAnswer("");

    const headers = await authHeaders();
    if (!headers) return;

    try {
      const res = await fetch(
        `${apiUrl}/api/math-engine/next-question?grade=${profile.grade}`,
        { headers, cache: "no-store" },
      );

      if (res.status === 404) {
        setDone(true);
        setQuestion(null);
        return;
      }

      if (!res.ok) {
        throw new Error("Could not load the next question.");
      }

      setDone(false);
      setQuestion(await res.json());
    } catch (err) {
      setError(err instanceof Error ? err.message : "Something went wrong.");
    } finally {
      setLoading(false);
    }
  }, [authHeaders, profile.grade]);

  useEffect(() => {
    (async () => {
      await loadNextQuestion();
    })();
  }, [loadNextQuestion]);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (!question || !answer.trim() || submitting) return;

    setSubmitting(true);
    setError(null);

    const headers = await authHeaders();
    if (!headers) return;

    try {
      const res = await fetch(`${apiUrl}/api/math-engine/answer`, {
        method: "POST",
        headers: { ...headers, "Content-Type": "application/json" },
        body: JSON.stringify({
          question_id: question.question_id,
          student_answer: answer.trim(),
        }),
      });

      if (!res.ok) {
        throw new Error("Could not check that answer.");
      }

      setResult(await res.json());
    } catch (err) {
      setError(err instanceof Error ? err.message : "Something went wrong.");
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-24">
        <p className="text-sm text-slate">Loading your next question…</p>
      </div>
    );
  }

  if (done) {
    return (
      <motion.div
        initial={{ opacity: 0, y: 12 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.4 }}
        className="flex flex-col items-center justify-center text-center py-20"
      >
        <div className="w-16 h-16 rounded-2xl bg-card-navy border border-white/[0.06] flex items-center justify-center mb-5">
          <Icons.check size={28} color="#00D9C0" />
        </div>
        <h2 className="font-heading font-bold text-xl text-white mb-2">
          All caught up!
        </h2>
        <p className="text-sm text-white/50 max-w-sm">
          You&apos;ve solved every practice question available for Grade{" "}
          {profile.grade} right now. Check back once more are added.
        </p>
      </motion.div>
    );
  }

  return (
    <div className="max-w-2xl mx-auto py-6 md:py-10">
      <div className="flex items-center gap-2.5 mb-6">
        <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-cosmic to-nebula flex items-center justify-center">
          <Icons.spark size={16} color="#fff" />
        </div>
        <div>
          <h2 className="font-heading font-bold text-lg text-white">
            AI Math Engine
          </h2>
          <p className="text-xs text-white/40">Grade {profile.grade} practice</p>
        </div>
      </div>

      {error && (
        <div className="mb-4 rounded-xl border border-red-400/20 bg-red-400/10 px-4 py-3 text-sm text-red-300">
          {error}
        </div>
      )}

      {question && (
        <motion.div
          key={question.question_id}
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4, ease: [0.4, 0, 0.2, 1] }}
          className="bg-card-navy border border-white/[0.06] rounded-3xl p-6 md:p-8 shadow-card-dark"
        >
          <div className="flex items-center gap-2 mb-4">
            <span
              className="text-[11px] font-semibold px-2.5 py-1 rounded-full capitalize"
              style={{
                color: DIFFICULTY_COLOR[question.difficulty] ?? "#00D9C0",
                background: `${DIFFICULTY_COLOR[question.difficulty] ?? "#00D9C0"}18`,
              }}
            >
              {question.difficulty}
            </span>
            {question.subtopic && (
              <span className="text-[11px] text-white/35">
                {question.subtopic}
              </span>
            )}
          </div>

          <p className="font-heading text-base md:text-lg text-white leading-relaxed mb-6">
            {question.prompt}
          </p>

          {!result?.correct && (
            <form onSubmit={handleSubmit} className="space-y-3">
              <input
                type="text"
                value={answer}
                onChange={(e) => setAnswer(e.target.value)}
                placeholder="Type your answer…"
                disabled={submitting}
                className="w-full rounded-xl bg-deep border border-white/[0.08] text-white text-sm placeholder:text-slate/60 px-4 py-3 focus:outline-none focus:border-cyan/50 transition-colors"
              />
              <button
                type="submit"
                disabled={submitting || !answer.trim()}
                className="w-full rounded-xl bg-gradient-to-r from-cosmic to-nebula text-white font-medium text-sm py-3 shadow-glow-cosmic hover:opacity-90 transition-opacity disabled:opacity-60 disabled:cursor-not-allowed"
              >
                {submitting ? "Checking…" : "Check answer"}
              </button>
            </form>
          )}

          <AnimatePresence mode="wait">
            {result && !result.correct && (
              <motion.div
                key="hint"
                initial={{ opacity: 0, y: 8 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0 }}
                className="mt-4 rounded-xl border border-solar/20 bg-solar/10 px-4 py-3"
              >
                <p className="text-xs font-semibold text-solar mb-1">
                  Not quite — attempt {result.attempts}
                </p>
                <p className="text-sm text-white/70">
                  {result.hint ??
                    "Take another look at the question and try again."}
                </p>
              </motion.div>
            )}

            {result?.correct && (
              <motion.div
                key="correct"
                initial={{ opacity: 0, y: 8 }}
                animate={{ opacity: 1, y: 0 }}
                className="mt-4"
              >
                <div className="rounded-xl border border-cyan/20 bg-cyan/10 px-4 py-3 mb-4">
                  <p className="text-sm font-semibold text-cyan mb-2">
                    Correct!
                  </p>
                  {result.solution_steps && (
                    <ol className="list-decimal list-inside space-y-1 text-sm text-white/70">
                      {result.solution_steps.map((step, i) => (
                        <li key={i}>{step}</li>
                      ))}
                    </ol>
                  )}
                </div>
                <button
                  onClick={loadNextQuestion}
                  className="w-full rounded-xl bg-gradient-to-r from-cosmic to-nebula text-white font-medium text-sm py-3 shadow-glow-cosmic hover:opacity-90 transition-opacity"
                >
                  Next question
                </button>
              </motion.div>
            )}
          </AnimatePresence>
        </motion.div>
      )}
    </div>
  );
}
