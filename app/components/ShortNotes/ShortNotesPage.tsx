"use client";

import { motion } from "framer-motion";
import { grade6Units } from "../../lib/data";
import NoteCard from "./NoteCard";

interface ShortNotesPageProps {
  onReadMore: () => void;
}

export default function ShortNotesPage({ onReadMore }: ShortNotesPageProps) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 24 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, ease: [0.4, 0, 0.2, 1] }}
    >
      <div className="mb-8">
        <h2 className="font-heading font-bold text-2xl md:text-3xl text-white mb-2">
          Short Notes
        </h2>
        <p className="text-sm text-slate max-w-lg">
          Quick revision notes for every unit. Read these to remember the key
          ideas before you practise.
        </p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
        {grade6Units.map((unit, i) => (
          <NoteCard
            key={unit.id}
            unit={unit}
            index={i}
            onReadMore={onReadMore}
          />
        ))}
      </div>
    </motion.div>
  );
}
