"use client";

import { motion } from "framer-motion";
import { Icons } from "../lib/icons";
import { StudentProfile } from "../lib/types";

interface ProfilePageProps {
  profile: StudentProfile;
  onEdit: () => void;
}

const statistics = [
  { label: "Lessons Completed", value: "42" },
  { label: "Average Accuracy", value: "87%" },
  { label: "Current Streak", value: "12 days" },
  { label: "Study Time", value: "18h" },
];

const topics = [
  { name: "Algebra", progress: 82 },
  { name: "Geometry", progress: 68 },
  { name: "Fractions", progress: 91 },
];

export default function ProfilePage({ profile, onEdit }: ProfilePageProps) {
  return (
    <section className="mx-auto max-w-5xl space-y-6">
      {/* Profile header */}
      <motion.section
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        className="rounded-3xl border border-white/[0.08] bg-card-navy p-6 md:p-8"
      >
        <div className="flex flex-col gap-5 sm:flex-row sm:items-center">
          <div
            className="flex h-24 w-24 shrink-0 items-center justify-center
                         rounded-full border-2 border-cyan bg-cyan/10"
            style={{ boxShadow: "0 0 24px rgba(0,217,192,0.2)" }}
          >
            <Icons.user size={42} color="#00D9C0" />
          </div>

          <div className="flex-1">
            <p className="mb-1 text-sm font-medium text-cyan">
              Student Profile
            </p>

            <h1 className="font-heading text-2xl font-bold text-white md:text-3xl">
              {profile.student_name}
            </h1>

            <p className="mt-1 text-slate">
              Grade {profile.grade} · Mathematics
            </p>
          </div>

          <button
            onClick={onEdit}
            className="rounded-xl border border-cyan/30 bg-cyan/10 px-5 py-2.5
                         text-sm font-semibold text-cyan transition-colors
                         hover:bg-cyan/20"
          >
            Edit Profile
          </button>
        </div>
      </motion.section>

      {/* Statistics */}
      <section className="grid grid-cols-2 gap-4 lg:grid-cols-4">
        {statistics.map((stat, index) => (
          <motion.article
            key={stat.label}
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.06 }}
            className="rounded-2xl border border-white/[0.08]
                         bg-card-navy p-5"
          >
            <p className="text-2xl font-bold text-white">{stat.value}</p>
            <p className="mt-1 text-sm text-slate">{stat.label}</p>
          </motion.article>
        ))}
      </section>

      {/* Topic progress */}
      <section className="rounded-3xl border border-white/[0.08] bg-card-navy p-6">
        <h2 className="font-heading text-lg font-semibold text-white">
          Topic Progress
        </h2>

        <div className="mt-6 space-y-5">
          {topics.map((topic) => (
            <div key={topic.name}>
              <div className="mb-2 flex justify-between text-sm">
                <span className="font-medium text-white">{topic.name}</span>
                <span className="text-cyan">{topic.progress}%</span>
              </div>

              <div className="h-2 overflow-hidden rounded-full bg-white/[0.06]">
                <motion.div
                  initial={{ width: 0 }}
                  animate={{ width: `${topic.progress}%` }}
                  transition={{ duration: 0.7 }}
                  className="h-full rounded-full bg-gradient-to-r
                               from-cosmic to-cyan"
                />
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* Recent activity */}
      <section className="rounded-3xl border border-white/[0.08] bg-card-navy p-6">
        <h2 className="font-heading text-lg font-semibold text-white">
          Recent Activity
        </h2>

        <div className="mt-4 divide-y divide-white/[0.06]">
          <Activity
            title="Completed Algebra Practice"
            detail="18 of 20 answers correct"
            time="Today"
          />
          <Activity
            title="Reviewed Geometry Notes"
            detail="Triangles and angles"
            time="Yesterday"
          />
          <Activity
            title="Earned a New Badge"
            detail="Seven-day learning streak"
            time="3 days ago"
          />
        </div>
      </section>
    </section>
  );
}

function Activity({
  title,
  detail,
  time,
}: {
  title: string;
  detail: string;
  time: string;
}) {
  return (
    <article className="flex items-center justify-between gap-4 py-4">
      <div>
        <h3 className="text-sm font-medium text-white">{title}</h3>
        <p className="mt-1 text-xs text-slate">{detail}</p>
      </div>

      <time className="shrink-0 text-xs text-white/40">{time}</time>
    </article>
  );
}
