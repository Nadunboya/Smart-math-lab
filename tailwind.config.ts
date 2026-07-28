import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./lib/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        cosmic: "#5B4FE5",
        nebula: "#8B5CF6",
        cyan: {
          DEFAULT: "#00D9C0",
          50: "#E6FAF7",
          100: "#B3F2E9",
          200: "#80EADB",
          300: "#4DE2CD",
          400: "#00D9C0",
          500: "#00B89E",
          600: "#008A77",
          700: "#005C50",
          800: "#002E28",
          900: "#001514",
        },
        solar: "#FF7A45",
        deep: "#0B1220",
        "card-navy": "#151A33",
        ink: "#1E2233",
        mist: "#F4F6FB",
        slate: "#6B7280",
      },
      fontFamily: {
        heading: ['"Space Grotesk"', "sans-serif"],
        body: ['"Inter"', "sans-serif"],
        mono: ['"JetBrains Mono"', "monospace"],
      },
      borderRadius: {
        "2xl": "20px",
        "3xl": "28px",
      },
      boxShadow: {
        glow: "0 0 20px rgba(0, 217, 192, 0.15)",
        "glow-strong": "0 0 40px rgba(0, 217, 192, 0.3)",
        "glow-cosmic": "0 6px 16px rgba(91, 79, 229, 0.35)",
        card: "0 4px 24px rgba(11, 18, 32, 0.08)",
        "card-dark": "0 4px 24px rgba(0, 0, 0, 0.3)",
      },
      animation: {
        "conic-spin": "conicSpin 3s linear infinite",
        "sparkle-float": "sparkleFloat 2.5s ease-in-out infinite",
        "mesh-drift": "meshDrift 25s ease-in-out infinite",
      },
      keyframes: {
        conicSpin: {
          to: { transform: "rotate(360deg)" },
        },
        sparkleFloat: {
          "0%, 100%": { transform: "translateY(0) scale(1)", opacity: "0.6" },
          "50%": { transform: "translateY(-8px) scale(1.15)", opacity: "1" },
        },
        meshDrift: {
          "0%, 100%": { transform: "translate(0, 0) scale(1)" },
          "33%": { transform: "translate(25px, -20px) scale(1.02)" },
          "66%": { transform: "translate(-15px, 15px) scale(0.98)" },
        },
      },
    },
  },
  plugins: [],
};

export default config;
