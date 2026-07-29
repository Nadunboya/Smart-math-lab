"use client";

import { motion } from "framer-motion";
import { Unit } from "../../lib/types";
import NoteCard from "./NoteCard";

interface ShortNotesPageProps {
  units: Unit[];
  onReadMore: () => void;
}

export default function ShortNotesPage({
  units,
  onReadMore,
}: ShortNotesPageProps) {
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

      {units.length === 0 ? (
        <div className="rounded-2xl border border-white/[0.06] bg-card-navy p-10 text-center">
          <p className="text-white/70 font-medium mb-1">
            Content coming soon
          </p>
          <p className="text-sm text-slate">
            Notes for this grade haven&apos;t been added yet — check back
            soon.
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
          {units.map((unit, i) => (
            <NoteCard
              key={unit.id}
              unit={unit}
              index={i}
              onReadMore={onReadMore}
            />
          ))}
        </div>
      )}
    </motion.div>
  );
}
