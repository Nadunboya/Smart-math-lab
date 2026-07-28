"use client";

import { motion, AnimatePresence } from "framer-motion";
import { Icons } from "../lib/icons";
import { Toast } from "../../hooks/useToast";

const borderColors: Record<Toast["type"], string> = {
  success: "border-green-500/30",
  error: "border-red-500/30",
  info: "border-blue-500/30",
};

const iconMap: Record<Toast["type"], React.ReactNode> = {
  success: <Icons.check size={18} color="#22C55E" />,
  error: <Icons.check size={18} color="#EF4444" />,
  info: <Icons.spark size={16} color="#3B82F6" />,
};

export default function ToastContainer({ toasts }: { toasts: Toast[] }) {
  return (
    <div className="fixed top-20 right-4 z-[100] flex flex-col gap-3 max-w-xs pointer-events-none">
      <AnimatePresence mode="popLayout">
        {toasts.map((toast) => (
          <motion.div
            key={toast.id}
            initial={{ opacity: 0, x: 60, scale: 0.95 }}
            animate={{ opacity: 1, x: 0, scale: 1 }}
            exit={{ opacity: 0, x: 60, scale: 0.95 }}
            transition={{ duration: 0.3, ease: [0.4, 0, 0.2, 1] }}
            className={`flex items-center gap-3 px-4 py-3 rounded-2xl border shadow-lg shadow-black/30 bg-card-navy pointer-events-auto ${borderColors[toast.type]}`}
          >
            {iconMap[toast.type]}
            <span className="text-sm text-white/90">{toast.message}</span>
          </motion.div>
        ))}
      </AnimatePresence>
    </div>
  );
}
