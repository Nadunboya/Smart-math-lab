"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Icons } from "../lib/icons";
import { createClient } from "../../lib/supabase/client";

export default function LoginPage() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleGoogleSignIn = async () => {
    setError(null);
    setLoading(true);
    const supabase = createClient();

    const { error: signInError } = await supabase.auth.signInWithOAuth({
      provider: "google",
      options: {
        redirectTo: `${window.location.origin}/auth/callback`,
      },
    });

    if (signInError) {
      setError(signInError.message);
      setLoading(false);
    }
    // On success the browser is redirected to Google, so there's nothing else to do here.
  };

  return (
    <div className="min-h-screen flex items-center justify-center px-4">
      <motion.div
        initial={{ opacity: 0, y: 24 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5, ease: [0.4, 0, 0.2, 1] }}
        className="w-full max-w-md rounded-3xl border border-white/[0.06] bg-card-navy p-8 md:p-10 shadow-card-dark relative overflow-hidden"
      >
        <div className="absolute -top-10 -right-10 w-40 h-40 rounded-full bg-cosmic/10 blur-2xl pointer-events-none" />
        <div className="absolute -bottom-10 -left-10 w-32 h-32 rounded-full bg-cyan/10 blur-2xl pointer-events-none" />

        <div className="relative z-10">
          <div className="flex flex-col items-center text-center mb-8">
            <div className="w-14 h-14 rounded-2xl bg-gradient-to-br from-cosmic to-nebula flex items-center justify-center shadow-glow-cosmic mb-4">
              <Icons.flask size={28} color="#fff" />
            </div>
            <h1 className="font-heading font-bold text-2xl text-white">
              Welcome to SmartMathLab
            </h1>
            <p className="text-sm text-slate mt-2 max-w-xs">
              Sign in with your Google account to start your interactive
              mathematics learning journey.
            </p>
          </div>

          <button
            onClick={handleGoogleSignIn}
            disabled={loading}
            className="w-full flex items-center justify-center gap-3 rounded-xl bg-white text-ink font-medium text-sm py-3.5 px-4 hover:bg-white/90 transition-colors disabled:opacity-60 disabled:cursor-not-allowed"
          >
            <Icons.google size={20} />
            {loading ? "Redirecting to Google…" : "Continue with Google"}
          </button>

          {error && (
            <p className="text-red-400 text-sm mt-4 text-center">{error}</p>
          )}

          <p className="text-xs text-slate text-center mt-8">
            New here? Signing in with Google will ask for a few details about
            the student before your first visit to the Math Lab.
          </p>
        </div>
      </motion.div>
    </div>
  );
}
