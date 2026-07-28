"use client";

import { motion } from "framer-motion";
import { Concept } from "../../lib/data";
import { Icons } from "../../lib/icons";

interface ConceptCardProps {
  concept: Concept;
  index: number;
  unitAccent: string;
  onClick: () => void;
}

export default function ConceptCard({
  concept,
  index,
  unitAccent,
  onClick,
}: ConceptCardProps) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 28 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{
        duration: 0.45,
        delay: index * 0.07,
        ease: [0.4, 0, 0.2, 1],
      }}
      className="bg-card-navy border border-white/[0.06] rounded-2xl p-5 group hover:border-white/[0.12] transition-all cursor-pointer"
      onClick={onClick}
      role="button"
      tabIndex={0}
      onKeyDown={(e) => e.key === "Enter" && onClick()}
      whileHover={{ y: -4 }}
    >
      <div className="flex items-start justify-between mb-3">
        <div
          className="w-10 h-10 rounded-xl flex items-center justify-center text-sm font-mono font-semibold"
          style={{ background: `${unitAccent}15`, color: unitAccent }}
        >
          {String(index + 1).padStart(2, "0")}
        </div>
        <Icons.launch size={18} color={unitAccent} />
      </div>
      <h4 className="font-heading font-semibold text-sm text-white mb-1">
        {concept.name}
      </h4>
      <p className="text-xs text-white/45 leading-relaxed">{concept.desc}</p>
      <div
        className="mt-4 flex items-center gap-1.5 text-xs font-medium transition-colors group-hover:text-white"
        style={{ color: unitAccent }}
      >
        Launch Lab <Icons.arrowRight size={14} color={unitAccent} />
      </div>
    </motion.div>
  );
}
