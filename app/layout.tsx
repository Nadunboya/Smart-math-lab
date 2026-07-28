import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "SmartMathLab — Grade 6 Mathematics",
  description:
    "A futuristic mathematics learning platform for Sri Lankan local syllabus students. Interactive Math Lab, Short Notes, and AI Problem Solving.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="antialiased">
        {/* 全局背景层 */}
        <div
          className="fixed inset-0 z-0 pointer-events-none animate-mesh-drift"
          style={{
            background: `
              radial-gradient(ellipse at 15% 30%, rgba(91,79,229,0.07) 0%, transparent 55%),
              radial-gradient(ellipse at 85% 15%, rgba(139,92,246,0.05) 0%, transparent 50%),
              radial-gradient(ellipse at 55% 85%, rgba(0,217,192,0.04) 0%, transparent 50%)
            `,
          }}
        />
        <div className="fixed inset-0 z-0 pointer-events-none dot-grid" />
        {children}
      </body>
    </html>
  );
}
