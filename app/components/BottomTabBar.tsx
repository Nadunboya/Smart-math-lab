"use client";

import { Icons } from "../lib/icons";

type TabKey = "lab" | "notes" | "engine";

interface BottomTabBarProps {
  activeTab: TabKey;
  setActiveTab: (tab: TabKey) => void;
}

const tabs: {
  key: TabKey;
  label: string;
  Icon: React.FC<{ size?: number; color?: string }>;
}[] = [
  { key: "lab", label: "Math Lab", Icon: Icons.flask },
  { key: "notes", label: "Notes", Icon: Icons.file },
  { key: "engine", label: "AI Engine", Icon: Icons.spark },
];

export default function BottomTabBar({
  activeTab,
  setActiveTab,
}: BottomTabBarProps) {
  return (
    <div
      className="md:hidden fixed bottom-0 left-0 right-0 z-50 bg-deep/95 backdrop-blur-xl border-t border-white/[0.06]"
      style={{ height: 64, paddingBottom: "env(safe-area-inset-bottom, 0px)" }}
      role="tablist"
      aria-label="Mobile navigation"
    >
      <div className="h-full flex items-center justify-around px-2">
        {tabs.map((t) => {
          const isActive = activeTab === t.key;
          return (
            <button
              key={t.key}
              role="tab"
              aria-selected={isActive}
              className={`bottom-tab ${isActive ? "active" : ""}`}
              onClick={() => setActiveTab(t.key)}
            >
              <t.Icon size={22} color={isActive ? "#00D9C0" : "#6B7280"} />
              <span className="font-medium">{t.label}</span>
              <div
                className="rounded-full bg-cyan"
                style={{
                  width: isActive ? 4 : 0,
                  height: isActive ? 4 : 0,
                  boxShadow: isActive ? "0 0 8px rgba(0,217,192,0.6)" : "none",
                  marginTop: 2,
                  transition: "all 0.25s",
                }}
              />
            </button>
          );
        })}
      </div>
    </div>
  );
}
