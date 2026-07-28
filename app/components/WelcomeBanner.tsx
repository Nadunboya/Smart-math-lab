"use client";

import { motion } from "framer-motion";
import { Icons } from "../lib/icons";

export default function WelcomeBanner() {
  return (
    <motion.div
      initial={{ opacity: 0, y: 24 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, ease: [0.4, 0, 0.2, 1] }}
      className="relative overflow-hidden rounded-3xl p-6 md:p-8 mb-8 border border-white/[0.06]"
      style={{
        background:
          "linear-gradient(135deg, rgba(91,79,229,0.15) 0%, rgba(0,217,192,0.08) 50%, rgba(139,92,246,0.1) 100%)",
      }}
    >
      {/* 装饰圆 */}
      <div className="absolute -top-8 -right-8 w-40 h-40 rounded-full bg-cosmic/10 blur-2xl" />
      <div className="absolute -bottom-6 -left-6 w-32 h-32 rounded-full bg-cyan/10 blur-2xl" />

      <div className="relative z-10">
        <p className="text-slate text-sm mb-1">Welcome back,</p>
        <h1 className="font-heading font-bold text-2xl md:text-3xl text-white mb-2">
          Kasun Perera
        </h1>
        <p className="text-white/60 text-sm md:text-base max-w-lg">
          Grade 6 Mathematics — 10 units ready to explore. Pick a topic below
          and start your learning journey in the Math Lab.
        </p>
        <div className="flex items-center gap-4 mt-4 flex-wrap">
          <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold bg-cyan/10 text-cyan border border-cyan/20">
            <Icons.check size={14} color="#00D9C0" /> 3 units started
          </span>
          <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold bg-nebula/10 text-nebula border border-nebula/20">
            7 to go
          </span>
        </div>
      </div>
    </motion.div>
  );
}
