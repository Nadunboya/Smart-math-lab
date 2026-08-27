"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Unit, Concept, StudentProfile } from "../../lib/types";
import { UnitIcons, Icons } from "../../lib/icons";
import UnitCard from "./UnitCard";
import ConceptCard from "./ConceptCard";
import ConceptDetail from "./ConceptDetail";
import NumberLinePractical from "./NumberLinePractical";
import WelcomeBanner from "../WelcomeBanner";

interface MathLabPageProps {
  units: Unit[];
  selectedUnit: Unit | null;
  setSelectedUnit: (unit: Unit | null) => void;
  profile: StudentProfile;
}

export default function MathLabPage({
  units,
  selectedUnit,
  setSelectedUnit,
  profile,
}: MathLabPageProps) {
  const [selectedConcept, setSelectedConcept] = useState<Concept | null>(null);

  const backToUnits = () => {
    setSelectedUnit(null);
    setSelectedConcept(null);
  };

  if (selectedUnit && selectedConcept) {
    return (
      <AnimatePresence mode="wait">
        <ConceptDetail
          concept={selectedConcept}
          unitAccent={selectedUnit.accent_color}
          onBack={() => setSelectedConcept(null)}
        />
      </AnimatePresence>
    );
  }

  if (selectedUnit) {
    const UnitIcon = UnitIcons[selectedUnit.icon_key];

    return (
      <AnimatePresence mode="wait">
        <motion.div
          key={`detail-${selectedUnit.id}`}
          initial={{ opacity: 0, x: 36 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: -36 }}
          transition={{ duration: 0.4, ease: [0.4, 0, 0.2, 1] }}
        >
          {/* 返回按钮 */}
          <button
            onClick={backToUnits}
            className="flex items-center gap-2 text-sm text-slate hover:text-white transition-colors mb-6 group"
          >
            <Icons.chevLeft size={18} />
            <span className="group-hover:-translate-x-1 transition-transform inline-block">
              Back to all units
            </span>
          </button>

          {/* 单元标题 */}
          <div className="flex items-start gap-4 mb-8">
            <div
              className="w-16 h-16 rounded-2xl flex items-center justify-center flex-shrink-0"
              style={{ background: `${selectedUnit.accent_color}15` }}
            >
              {UnitIcon && (
                <UnitIcon size={44} color={selectedUnit.accent_color} />
              )}
            </div>
            <div>
              <h2 className="font-heading font-bold text-2xl md:text-3xl text-white">
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
              <p className="text-sm text-white/50 mt-2 max-w-lg">
                {selectedUnit.description}
              </p>
            </div>
          </div>

          {/* 概念网格 */}
          <h3 className="font-heading font-semibold text-base text-white/70 mb-4">
            Concepts in this unit
          </h3>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {selectedUnit.concepts.map((c, i) => (
              <ConceptCard
                key={c.id}
                concept={c}
                index={i}
                unitAccent={selectedUnit.accent_color}
                onClick={() => setSelectedConcept(c)}
              />
            ))}
          </div>

          {selectedUnit.name === "Number Line" && (
            <NumberLinePractical accentColor={selectedUnit.accent_color} />
          )}
        </motion.div>
      </AnimatePresence>
    );
  }

  return (
    <AnimatePresence mode="wait">
      <motion.div
        key="unit-grid"
        initial={{ opacity: 0, x: -36 }}
        animate={{ opacity: 1, x: 0 }}
        exit={{ opacity: 0, x: 36 }}
        transition={{ duration: 0.4, ease: [0.4, 0, 0.2, 1] }}
      >
        <WelcomeBanner profile={profile} />

        <div className="flex items-center justify-between mb-6">
          <div>
            <h2 className="font-heading font-bold text-xl md:text-2xl text-white">
              All Units
            </h2>
            <p className="text-sm text-slate mt-0.5">
              Grade {profile.grade} Local Syllabus
            </p>
          </div>
          <span className="px-3 py-1.5 rounded-xl text-xs font-mono font-medium bg-white/5 text-white/40 border border-white/[0.06]">
            {units.length} units
          </span>
        </div>

        {units.length === 0 ? (
          <div className="rounded-2xl border border-white/[0.06] bg-card-navy p-10 text-center">
            <p className="text-white/70 font-medium mb-1">
              Content coming soon
            </p>
            <p className="text-sm text-slate">
              Grade {profile.grade} units haven&apos;t been added yet — check
              back soon.
            </p>
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
            {units.map((unit, i) => (
              <UnitCard
                key={unit.id}
                unit={unit}
                index={i}
                onClick={() => setSelectedUnit(unit)}
              />
            ))}
          </div>
        )}
      </motion.div>
    </AnimatePresence>
  );
}
