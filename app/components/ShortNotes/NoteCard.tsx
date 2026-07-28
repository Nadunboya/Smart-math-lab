"use client";

import { motion } from "framer-motion";
import { Unit } from "../../lib/data";
import { UnitIcons, Icons } from "../../lib/icons";

interface NoteCardProps {
  unit: Unit;
  index: number;
  onReadMore: () => void;
}

export default function NoteCard({ unit, index, onReadMore }: NoteCardProps) {
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
      className="note-card"
      whileHover={{ y: -6 }}
    >
      <div className="flex items-center gap-3 mb-4">
        <div
          className="w-11 h-11 rounded-xl flex items-center justify-center flex-shrink-0"
          style={{ background: `${unit.accent}12` }}
        >
          {IconComponent && <IconComponent size={32} color={unit.accent} />}
        </div>
        <div>
          <h3 className="font-heading font-semibold text-sm text-white">
            {unit.name}
          </h3>
          <p
            className="text-[11px]"
            style={{
              fontFamily: '"Noto Sans Sinhala", sans-serif',
              color: `${unit.accent}99`,
            }}
          >
            {unit.sinhala}
          </p>
        </div>
      </div>

      <ul className="space-y-2.5 mb-5">
        {unit.notes.map((note, ni) => (
          <li
            key={ni}
            className="flex items-start gap-2.5 text-sm text-white/55 leading-relaxed"
          >
            <span
              className="w-1.5 h-1.5 rounded-full mt-1.5 flex-shrink-0"
              style={{ background: unit.accent }}
            />
            {note}
          </li>
        ))}
      </ul>

      <button
        onClick={onReadMore}
        className="flex items-center gap-1.5 text-sm font-medium transition-all hover:gap-2.5"
        style={{ color: unit.accent }}
      >
        Read Full Notes <Icons.arrowRight size={14} color={unit.accent} />
      </button>
    </motion.div>
  );
}
