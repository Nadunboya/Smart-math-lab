"use client";

import { motion } from "framer-motion";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { Concept } from "../../lib/types";
import { Icons } from "../../lib/icons";

export default function ConceptDetail({
  concept,
  unitAccent,
  onBack,
}: {
  concept: Concept;
  unitAccent: string;
  onBack: () => void;
}) {
  return (
    <motion.div
      key={`concept-${concept.id}`}
      initial={{ opacity: 0, x: 36 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -36 }}
      transition={{ duration: 0.4, ease: [0.4, 0, 0.2, 1] }}
    >
      <button
        onClick={onBack}
        className="flex items-center gap-2 text-sm text-slate hover:text-white transition-colors mb-6 group"
      >
        <Icons.chevLeft size={18} />
        <span className="group-hover:-translate-x-1 transition-transform inline-block">
          Back to concepts
        </span>
      </button>

      <div className="flex items-center gap-3 mb-6">
        <div
          className="w-11 h-11 rounded-xl flex items-center justify-center flex-shrink-0"
          style={{ background: `${unitAccent}15`, color: unitAccent }}
        >
          <Icons.launch size={22} color={unitAccent} />
        </div>
        <div>
          <p className="text-xs font-semibold uppercase tracking-wide" style={{ color: unitAccent }}>
            Launch Lab
          </p>
          <h2 className="font-heading font-bold text-2xl text-white">
            {concept.name}
          </h2>
        </div>
      </div>

      <div className="rounded-2xl border border-white/[0.06] bg-card-navy p-6 md:p-8">
        {concept.body ? (
          <div className="concept-markdown">
            <ReactMarkdown remarkPlugins={[remarkGfm]}>
              {concept.body}
            </ReactMarkdown>
          </div>
        ) : (
          <div className="text-center py-10">
            <p className="text-white/70 font-medium mb-1">
              Lesson content coming soon
            </p>
            <p className="text-sm text-slate">
              {concept.description}
            </p>
          </div>
        )}
      </div>
    </motion.div>
  );
}
