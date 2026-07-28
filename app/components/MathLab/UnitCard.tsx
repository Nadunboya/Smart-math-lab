"use client";

import { motion } from "framer-motion";
import { Unit } from "../../lib/data";
import { UnitIcons, Icons } from "../../lib/icons";

interface UnitCardProps {
  unit: Unit;
  index: number;
  onClick: () => void;
}

export default function UnitCard({ unit, index, onClick }: UnitCardProps) {
  const IconComponent = UnitIcons[unit.iconKey];

  return (
    <motion.div
      initial={{ opacity: 0, y: 28 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{
        duration: 0.5,
        delay: index * 0.055,
        ease: [0.4, 0, 0.2, 1],
      }}
      className="unit-card group"
      onClick={onClick}
      role="button"
      tabIndex={0}
      aria-label={`Open ${unit.name} unit`}
      onKeyDown={(e) => e.key === "Enter" && onClick()}
      whileHover={{ y: -6 }}
      onMouseEnter={(e) => {
        e.currentTarget.style.boxShadow = `0 8px 32px ${unit.accent}22`;
        e.currentTarget.style.borderColor = "rgba(255,255,255,0.12)";
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.boxShadow = "none";
        e.currentTarget.style.borderColor = "rgba(255,255,255,0.06)";
      }}
    >
      {/* 图标 */}
      <div
        className="w-14 h-14 rounded-2xl flex items-center justify-center mb-4 transition-transform duration-200 group-hover:scale-110"
        style={{ background: `${unit.accent}12` }}
      >
        {IconComponent && <IconComponent size={40} color={unit.accent} />}
      </div>

      {/* 标题 */}
      <h3 className="font-heading font-semibold text-base text-white mb-0.5">
        {unit.name}
      </h3>
      <p
        className="text-xs text-slate mb-2"
        style={{ fontFamily: '"Noto Sans Sinhala", sans-serif' }}
      >
        {unit.sinhala}
      </p>
      <p className="text-sm text-white/50 leading-relaxed mb-4 line-clamp-2">
        {unit.desc}
      </p>

      {/* 底部 */}
      <div className="flex items-center justify-between">
        <span className="text-xs text-white/30 font-mono">
          {unit.concepts.length} concepts
        </span>
        <span
          className="w-8 h-8 rounded-xl flex items-center justify-center transition-transform duration-200 group-hover:translate-x-1"
          style={{ background: `${unit.accent}15`, color: unit.accent }}
        >
          <Icons.arrowRight size={16} color={unit.accent} />
        </span>
      </div>
    </motion.div>
  );
}
