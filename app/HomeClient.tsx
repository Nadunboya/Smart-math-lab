"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import Navbar from "./components/Navbar";
import BottomTabBar from "./components/BottomTabBar";
import MathLabPage from "./components/MathLab/MathLabPage";
import ShortNotesPage from "./components/ShortNotes/ShortNotesPage";
import MathEnginePage from "./components/MathEngine/MathEnginePage";
import ToastContainer from "./components/ToastContainer";
import { useToast } from "../hooks/useToast";
import { Unit, StudentProfile } from "./lib/types";
import { createClient } from "../lib/supabase/client";

type TabKey = "lab" | "notes" | "engine";

export default function HomeClient({
  profile,
  units,
}: {
  profile: StudentProfile;
  units: Unit[];
}) {
  const router = useRouter();
  const [activeTab, setActiveTab] = useState<TabKey>("lab");
  const [selectedUnit, setSelectedUnit] = useState<Unit | null>(null);
  const [scrolled, setScrolled] = useState(false);
  const [profileOpen, setProfileOpen] = useState(false);
  const { toasts, showToast } = useToast();
  const [tabKey, setTabKey] = useState(0);

  /* Scroll listener */
  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 10);
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  /* Close dropdown on outside click */
  useEffect(() => {
    if (!profileOpen) return;
    const close = (e: MouseEvent) => {
      const target = e.target as HTMLElement;
      if (
        !target.closest('[aria-label="Profile menu"]') &&
        !target.closest('[role="menu"]')
      ) {
        setProfileOpen(false);
      }
    };
    document.addEventListener("click", close);
    return () => document.removeEventListener("click", close);
  }, [profileOpen]);

  /* Tab switching */
  const handleTabChange = useCallback(
    (tab: TabKey) => {
      if (tab === activeTab) return;
      setSelectedUnit(null);
      setTabKey((k) => k + 1);
      setActiveTab(tab);
      window.scrollTo({ top: 0, behavior: "smooth" });
    },
    [activeTab],
  );

  /* Logout */
  const handleLogout = useCallback(async () => {
    setProfileOpen(false);
    const supabase = createClient();
    await supabase.auth.signOut();
    showToast("You have been logged out", "success");
    router.replace("/login");
  }, [showToast, router]);

  /* Concept click */
  const handleConceptClick = useCallback(() => {
    showToast(
      "Lab visualization will load here — connect to backend to enable",
      "info",
    );
  }, [showToast]);

  /* Notes read more */
  const handleReadMore = useCallback(() => {
    showToast("Full notes will load here — connect to backend", "info");
  }, [showToast]);

  return (
    <div className="min-h-screen relative z-[1]">
      <Navbar
        activeTab={activeTab}
        setActiveTab={handleTabChange}
        scrolled={scrolled}
        profileOpen={profileOpen}
        setProfileOpen={setProfileOpen}
        onLogout={handleLogout}
        profile={profile}
      />
      <BottomTabBar activeTab={activeTab} setActiveTab={handleTabChange} />

      <main
        className="max-w-7xl mx-auto px-4 md:px-8 pt-[88px] md:pt-[96px] pb-24 md:pb-16"
        role="main"
      >
        <div key={tabKey}>
          {activeTab === "lab" && (
            <MathLabPage
              units={units}
              selectedUnit={selectedUnit}
              setSelectedUnit={setSelectedUnit}
              onConceptClick={handleConceptClick}
              profile={profile}
            />
          )}
          {activeTab === "notes" && (
            <ShortNotesPage units={units} onReadMore={handleReadMore} />
          )}
          {activeTab === "engine" && <MathEnginePage />}
        </div>
      </main>

      <ToastContainer toasts={toasts} />
    </div>
  );
}
