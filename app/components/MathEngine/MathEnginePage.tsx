"use client";

import { motion } from "framer-motion";
import { Icons } from "../../lib/icons";

export default function MathEnginePage() {
  const features = [
    {
      color: "#00D9C0",
      title: "Step-by-Step Help",
      desc: "See every step of a solution",
    },
    {
      color: "#8B5CF6",
      title: "Smart Hints",
      desc: "Get a nudge, not the full answer",
    },
    {
      color: "#FF7A45",
      title: "Concept Explanations",
      desc: "Understand the why behind each step",
    },
  ];

  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.97 }}
      animate={{ opacity: 1, scale: 1 }}
      transition={{ duration: 0.5, ease: [0.4, 0, 0.2, 1] }}
      className="flex flex-col items-center justify-center text-center py-16 md:py-24"
    >
      {/* AI 图标 + 旋转边框 */}
      <motion.div
        className="relative mb-8"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.15, duration: 0.5 }}
      >
        <div
          className="ai-border-spin p-[2.5px] rounded-[30px]"
          style={{
            background:
              "conic-gradient(from 0deg, #00D9C0, #8B5CF6, #FF7A45, #00D9C0)",
          }}
        >
          <div className="w-28 h-28 rounded-[28px] bg-card-navy flex items-center justify-center">
            <Icons.spark size={48} color="#fff" />
          </div>
        </div>

        {/* 浮动粒子 */}
        <motion.div
          className="absolute -top-3 -right-3 w-4 h-4 rounded-full"
          style={{ background: "rgba(0,217,192,0.6)" }}
          animate={{
            y: [0, -8, 0],
            scale: [1, 1.15, 1],
            opacity: [0.6, 1, 0.6],
          }}
          transition={{ duration: 2.5, repeat: Infinity, ease: "easeInOut" }}
        />
        <motion.div
          className="absolute -bottom-2 -left-4 w-3 h-3 rounded-full"
          style={{ background: "rgba(139,92,246,0.5)" }}
          animate={{
            y: [0, -8, 0],
            scale: [1, 1.15, 1],
            opacity: [0.5, 0.9, 0.5],
          }}
          transition={{
            duration: 3,
            repeat: Infinity,
            ease: "easeInOut",
            delay: 0.8,
          }}
        />
        <motion.div
          className="absolute top-1/2 -right-6 w-2.5 h-2.5 rounded-full"
          style={{ background: "rgba(255,122,69,0.5)" }}
          animate={{
            y: [0, -8, 0],
            scale: [1, 1.15, 1],
            opacity: [0.5, 0.9, 0.5],
          }}
          transition={{
            duration: 2.8,
            repeat: Infinity,
            ease: "easeInOut",
            delay: 1.5,
          }}
        />
      </motion.div>

      {/* 标签 */}
      <motion.span
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.25 }}
        className="inline-flex items-center gap-1.5 px-4 py-1.5 rounded-full text-xs font-semibold bg-solar/10 text-solar border border-solar/20 mb-5"
      >
        Coming Soon
      </motion.span>

      {/* 标题 */}
      <motion.h2
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3 }}
        className="font-heading font-bold text-2xl md:text-3xl text-white mb-3"
      >
        AI Math Engine
      </motion.h2>
      <motion.p
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.35 }}
        className="text-sm text-white/50 max-w-md leading-relaxed mb-8"
      >
        We are building a smart assistant that will help you solve problems step
        by step, give you hints when you are stuck, and explain concepts in a
        way that is easy to understand.
      </motion.p>

      {/* 功能预览卡片 */}
      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.45 }}
        className="grid grid-cols-1 sm:grid-cols-3 gap-4 max-w-lg w-full"
      >
        {features.map((f, i) => (
          <div
            key={i}
            className="bg-card-navy/60 border border-white/[0.05] rounded-2xl p-4 text-center"
          >
            <div className="flex justify-center mb-2">
              <Icons.spark size={20} color={f.color} />
            </div>
            <p className="text-xs font-semibold text-white/80 mb-0.5">
              {f.title}
            </p>
            <p className="text-[11px] text-white/35 leading-snug">{f.desc}</p>
          </div>
        ))}
      </motion.div>
    </motion.div>
  );
}
