"use client";

import { motion, AnimatePresence } from "framer-motion";
import { Icons } from "../lib/icons";
import { Unit } from "../lib/data";
import { StudentProfile } from "../lib/types";

type TabKey = "lab" | "notes" | "engine";

interface NavbarProps {
  activeTab: TabKey;
  setActiveTab: (tab: TabKey) => void;
  scrolled: boolean;
  profileOpen: boolean;
  setProfileOpen: (open: boolean) => void;
  onLogout: () => void;
  profile: StudentProfile;
}

const tabs: {
  key: TabKey;
  label: string;
  Icon: React.FC<{ size?: number; color?: string }>;
}[] = [
  { key: "lab", label: "Math Lab", Icon: Icons.flask },
  { key: "notes", label: "Short Notes", Icon: Icons.file },
  { key: "engine", label: "Math Engine", Icon: Icons.spark },
];

export default function Navbar({
  activeTab,
  setActiveTab,
  scrolled,
  profileOpen,
  setProfileOpen,
  onLogout,
  profile,
}: NavbarProps) {
  return (
    <nav
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        scrolled
          ? "bg-deep/90 backdrop-blur-xl border-b border-white/5 shadow-lg shadow-black/20"
          : "bg-deep border-b border-transparent"
      }`}
      style={{ height: 72 }}
      role="navigation"
      aria-label="Main navigation"
    >
      <div className="max-w-7xl mx-auto h-full px-4 md:px-8 flex items-center justify-between">
        {/* Logo */}
        <button
          onClick={() => setActiveTab("lab")}
          className="flex items-center gap-2.5 group"
          aria-label="SmartMathLab Home"
        >
          <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-cosmic to-nebula flex items-center justify-center shadow-glow-cosmic group-hover:shadow-[0_6px_24px_rgba(91,79,229,0.45)] transition-shadow">
            <Icons.flask size={20} color="#fff" />
          </div>
          <span className="font-heading font-bold text-lg text-white hidden sm:block">
            SmartMathLab
          </span>
        </button>

        {/* Desktop Tabs */}
        <div className="hidden md:flex items-center gap-8" role="tablist">
          {tabs.map((t) => (
            <button
              key={t.key}
              role="tab"
              aria-selected={activeTab === t.key}
              className={`nav-tab flex items-center gap-2 ${
                activeTab === t.key ? "active" : ""
              }`}
              onClick={() => setActiveTab(t.key)}
            >
              <t.Icon
                size={18}
                color={activeTab === t.key ? "#00D9C0" : "#6B7280"}
              />
              {t.label}
            </button>
          ))}
        </div>

        {/* Right Side */}
        <div className="flex items-center gap-3">
          {/* Grade Badge */}
          <span className="hidden md:inline-flex px-3 py-1 rounded-full text-xs font-semibold bg-cyan/10 text-cyan border border-cyan/20">
            Grade {profile.grade}
          </span>

          {/* Avatar */}
          <div className="relative">
            <button
              onClick={() => setProfileOpen(!profileOpen)}
              className="w-10 h-10 rounded-full bg-card-navy border-2 border-cyan flex items-center justify-center hover:border-cyan/80 transition-colors focus:outline-none"
              style={{ boxShadow: "0 0 12px rgba(0,217,192,0.2)" }}
              aria-label="Profile menu"
              aria-expanded={profileOpen}
            >
              <Icons.user size={20} color="#00D9C0" />
            </button>

            {/* Dropdown */}
            <AnimatePresence>
              {profileOpen && (
                <motion.div
                  initial={{ opacity: 0, y: -8, scale: 0.96 }}
                  animate={{ opacity: 1, y: 0, scale: 1 }}
                  exit={{ opacity: 0, y: -8, scale: 0.96 }}
                  transition={{ duration: 0.2, ease: [0.4, 0, 0.2, 1] }}
                  className="absolute right-0 top-14 w-56 bg-card-navy border border-white/[0.08] rounded-2xl shadow-2xl shadow-black/40 overflow-hidden"
                  role="menu"
                >
                  <div className="px-4 py-3 border-b border-white/[0.06]">
                    <p className="font-heading font-semibold text-sm text-white">
                      {profile.student_name}
                    </p>
                    <p className="text-xs text-slate mt-0.5">
                      Grade {profile.grade} — Mathematics
                    </p>
                  </div>
                  <div className="py-1.5">
                    {["My Profile", "Settings"].map((item) => (
                      <button
                        key={item}
                        role="menuitem"
                        className="w-full text-left px-4 py-2.5 text-sm text-white/70 hover:text-white hover:bg-white/5 transition-colors"
                      >
                        {item}
                      </button>
                    ))}
                  </div>
                  <div className="border-t border-white/[0.06] py-1.5">
                    <button
                      role="menuitem"
                      onClick={onLogout}
                      className="w-full text-left px-4 py-2.5 text-sm text-red-400 hover:text-red-300 hover:bg-red-500/5 transition-colors flex items-center gap-2"
                    >
                      <Icons.logout size={16} color="#EF4444" /> Log Out
                    </button>
                  </div>
                </motion.div>
              )}
            </AnimatePresence>
          </div>

          {/* Desktop Logout */}
          <button
            onClick={onLogout}
            className="hidden md:flex items-center gap-2 px-4 py-2 rounded-xl text-sm font-medium text-slate hover:text-white hover:bg-white/5 transition-all border border-white/[0.06]"
            aria-label="Log out"
          >
            <Icons.logout size={16} />
            <span className="hidden lg:inline">Log Out</span>
          </button>
        </div>
      </div>
    </nav>
  );
}
