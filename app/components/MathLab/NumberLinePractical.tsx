"use client";

import { useEffect, useRef, useState } from "react";
import { motion } from "framer-motion";
import { Icons } from "../../lib/icons";

declare global {
  interface Window {
    MathJax?: {
      typesetPromise?: (elements?: HTMLElement[]) => Promise<void>;
      typesetClear?: (elements?: HTMLElement[]) => void;
      tex?: Record<string, unknown>;
      svg?: Record<string, unknown>;
    };
  }
}

const MATHJAX_SCRIPT_ID = "mathjax-cdn-script";
const MIN = -10;
const MAX = 10;
const TICKS = Array.from({ length: MAX - MIN + 1 }, (_, i) => MIN + i);

function percent(value: number): number {
  return ((value - MIN) / (MAX - MIN)) * 100;
}

export default function NumberLinePractical({
  accentColor = "#06B6D4",
}: {
  accentColor?: string;
}) {
  const [value, setValue] = useState(0);
  const [history, setHistory] = useState<number[]>([]);
  const exprRef = useRef<HTMLDivElement>(null);

  const applyStep = (delta: number) => {
    setValue((prev) => {
      const next = prev + delta;
      if (next < MIN || next > MAX) return prev;
      setHistory((h) => [...h, delta]);
      return next;
    });
  };

  const reset = () => {
    setValue(0);
    setHistory([]);
  };

  const allowDrop = (e: React.DragEvent) => e.preventDefault();

  const expression =
    history.length === 0
      ? "\\(0\\)"
      : `\\(0 ${history
          .map((d) => `${d > 0 ? "+" : "-"} ${Math.abs(d)}`)
          .join(" ")} = ${value}\\)`;

  useEffect(() => {
    function typeset() {
      if (!exprRef.current || !window.MathJax?.typesetPromise) return;
      window.MathJax.typesetClear?.([exprRef.current]);
      window.MathJax.typesetPromise([exprRef.current]);
    }

    if (window.MathJax?.typesetPromise) {
      typeset();
      return;
    }

    if (document.getElementById(MATHJAX_SCRIPT_ID)) {
      const check = window.setInterval(() => {
        if (window.MathJax?.typesetPromise) {
          window.clearInterval(check);
          typeset();
        }
      }, 150);
      return () => window.clearInterval(check);
    }

    window.MathJax = {
      tex: { inlineMath: [["\\(", "\\)"]] },
      svg: { fontCache: "global" },
    };

    const script = document.createElement("script");
    script.id = MATHJAX_SCRIPT_ID;
    script.src =
      "https://cdnjs.cloudflare.com/ajax/libs/mathjax/3.2.2/es5/tex-mml-chtml.js";
    script.async = true;
    script.onload = typeset;
    document.head.appendChild(script);
  }, [expression]);

  return (
    <div className="rounded-2xl border border-white/[0.06] bg-card-navy p-6 md:p-8 mt-8">
      <div className="flex items-center gap-2 mb-1">
        <Icons.spark size={16} color={accentColor} />
        <h3 className="font-heading font-semibold text-base text-white">
          Practical: Adding &amp; Subtracting Integers
        </h3>
      </div>
      <p className="text-xs text-white/45 mb-6 max-w-md">
        Drag a token onto the number line — or just tap it — to move the
        marker and build the expression.
      </p>

      <div className="relative h-16 mb-2" onDragOver={allowDrop}>
        <div className="absolute left-0 right-0 top-1/2 h-[2px] bg-white/15 -translate-y-1/2" />
        {TICKS.map((t) => (
          <div
            key={t}
            className="absolute flex flex-col items-center"
            style={{ left: `${percent(t)}%`, top: "50%", transform: "translate(-50%, -50%)" }}
          >
            <div className={`w-px ${t % 5 === 0 ? "h-3 bg-white/40" : "h-1.5 bg-white/20"}`} />
            {t % 5 === 0 && (
              <span className="text-[10px] text-white/35 mt-1 font-mono">{t}</span>
            )}
          </div>
        ))}
        <motion.div
          className="absolute w-4 h-4 rounded-full"
          style={{ top: "50%", background: accentColor, transform: "translate(-50%, -50%)" }}
          animate={{ left: `${percent(value)}%` }}
          transition={{ type: "spring", stiffness: 260, damping: 22 }}
        />
      </div>

      <div
        className="flex items-center justify-center gap-6 py-6 mt-4 rounded-xl border border-dashed border-white/10"
        onDragOver={allowDrop}
        onDrop={(e) => {
          const op = e.dataTransfer.getData("op");
          if (op === "add") applyStep(1);
          if (op === "sub") applyStep(-1);
        }}
      >
        <button
          type="button"
          draggable
          onDragStart={(e) => e.dataTransfer.setData("op", "add")}
          onClick={() => applyStep(1)}
          disabled={value >= MAX}
          aria-label="Add 1"
          className="w-14 h-14 rounded-full bg-cyan text-deep font-heading font-bold text-2xl flex items-center justify-center shadow-glow-strong cursor-grab active:cursor-grabbing active:scale-95 transition-transform disabled:opacity-30 disabled:cursor-not-allowed"
        >
          +
        </button>
        <button
          type="button"
          draggable
          onDragStart={(e) => e.dataTransfer.setData("op", "sub")}
          onClick={() => applyStep(-1)}
          disabled={value <= MIN}
          aria-label="Subtract 1"
          className="w-14 h-14 rounded-full bg-solar text-deep font-heading font-bold text-2xl flex items-center justify-center cursor-grab active:cursor-grabbing active:scale-95 transition-transform disabled:opacity-30 disabled:cursor-not-allowed"
        >
          −
        </button>
      </div>

      <div className="flex items-center justify-between mt-6">
        <div ref={exprRef} className="text-white text-lg font-mono min-h-[28px]">
          <span key={expression}>{expression}</span>
        </div>
        <button
          type="button"
          onClick={reset}
          className="text-xs text-white/40 hover:text-white transition-colors"
        >
          Reset
        </button>
      </div>
    </div>
  );
}
