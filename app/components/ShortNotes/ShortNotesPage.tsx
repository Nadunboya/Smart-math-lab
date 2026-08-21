"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { Unit } from "../../lib/types";
import { UnitIcons, Icons } from "../../lib/icons";
import NoteCard from "./NoteCard";

interface ShortNotesPageProps {
  units: Unit[];
}

export default function ShortNotesPage({ units }: ShortNotesPageProps) {
  const [selectedUnit, setSelectedUnit] = useState<Unit | null>(null);

  if (selectedUnit) {
    const UnitIcon = UnitIcons[selectedUnit.icon_key];

    return (
      <AnimatePresence mode="wait">
        <motion.div
          key={`notes-detail-${selectedUnit.id}`}
          initial={{ opacity: 0, x: 36 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: -36 }}
          transition={{ duration: 0.4, ease: [0.4, 0, 0.2, 1] }}
        >
          <button
            onClick={() => setSelectedUnit(null)}
            className="flex items-center gap-2 text-sm text-slate hover:text-white transition-colors mb-6 group"
          >
            <Icons.chevLeft size={18} />
            <span className="group-hover:-translate-x-1 transition-transform inline-block">
              Back to short notes
            </span>
          </button>

          <div className="flex items-center gap-4 mb-8">
            <div
              className="w-14 h-14 rounded-2xl flex items-center justify-center flex-shrink-0"
              style={{ background: `${selectedUnit.accent_color}15` }}
            >
              {UnitIcon && <UnitIcon size={36} color={selectedUnit.accent_color} />}
            </div>
            <div>
              <h2 className="font-heading font-bold text-2xl text-white">
                {selectedUnit.name}
              </h2>
              {selectedUnit.sinhala_name && (
                <p
                  className="text-sm mt-0.5"
                  style={{
                    fontFamily: '"Noto Sans Sinhala", sans-serif',
                    color: selectedUnit.accent_color,
                  }}
                >
                  {selectedUnit.sinhala_name}
                </p>
              )}
            </div>
          </div>

          {selectedUnit.concepts.length === 0 ? (
            <div className="rounded-2xl border border-white/[0.06] bg-card-navy p-10 text-center">
              <p className="text-white/70 font-medium mb-1">
                Full notes coming soon
              </p>
              <p className="text-sm text-slate">
                Lesson content for this unit hasn&apos;t been added yet.
              </p>
            </div>
          ) : (
            <div className="space-y-6">
              {selectedUnit.concepts.map((concept) => (
                <div
                  key={concept.id}
                  className="rounded-2xl border border-white/[0.06] bg-card-navy p-6 md:p-8"
                >
                  <h3
                    className="font-heading font-semibold text-lg mb-4"
                    style={{ color: selectedUnit.accent_color }}
                  >
                    {concept.name}
                  </h3>
                  {concept.body ? (
                    <div className="concept-markdown">
                      <ReactMarkdown remarkPlugins={[remarkGfm]}>
                        {concept.body}
                      </ReactMarkdown>
                    </div>
                  ) : (
                    <p className="text-sm text-slate">{concept.description}</p>
                  )}
                </div>
              ))}
            </div>
          )}
        </motion.div>
      </AnimatePresence>
    );
  }

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
              onReadMore={() => setSelectedUnit(unit)}
            />
          ))}
        </div>
      )}
    </motion.div>
  );
}
