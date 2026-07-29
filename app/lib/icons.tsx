import React from "react";

interface IconProps {
  size?: number;
  color?: string;
  className?: string;
}

export const Icons = {
  flask: ({ size = 24, color = "currentColor", className }: IconProps) => (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke={color}
      strokeWidth="1.75"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
    >
      <path d="M9 3h6v5l4 8a2 2 0 01-1.8 2.9H6.8A2 2 0 015 16l4-8V3z" />
      <line x1="9" y1="3" x2="15" y2="3" />
    </svg>
  ),

  file: ({ size = 24, color = "currentColor", className }: IconProps) => (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke={color}
      strokeWidth="1.75"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
    >
      <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
      <polyline points="14 2 14 8 20 8" />
      <line x1="16" y1="13" x2="8" y2="13" />
      <line x1="16" y1="17" x2="8" y2="17" />
    </svg>
  ),

  spark: ({ size = 24, color = "currentColor", className }: IconProps) => (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke={color}
      strokeWidth="1.75"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
    >
      <path d="M12 2l2.4 7.2L22 12l-7.6 2.8L12 22l-2.4-7.2L2 12l7.6-2.8z" />
    </svg>
  ),

  logout: ({ size = 24, color = "currentColor", className }: IconProps) => (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke={color}
      strokeWidth="1.75"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
    >
      <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4" />
      <polyline points="16 17 21 12 16 7" />
      <line x1="21" y1="12" x2="9" y2="12" />
    </svg>
  ),

  chevLeft: ({ size = 24, color = "currentColor", className }: IconProps) => (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke={color}
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
    >
      <polyline points="15 18 9 12 15 6" />
    </svg>
  ),

  arrowRight: ({ size = 20, color = "currentColor", className }: IconProps) => (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke={color}
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
    >
      <line x1="5" y1="12" x2="19" y2="12" />
      <polyline points="12 5 19 12 12 19" />
    </svg>
  ),

  user: ({ size = 24, color = "currentColor", className }: IconProps) => (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke={color}
      strokeWidth="1.75"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
    >
      <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2" />
      <circle cx="12" cy="7" r="4" />
    </svg>
  ),

  check: ({ size = 20, color = "currentColor", className }: IconProps) => (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke={color}
      strokeWidth="2.5"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
    >
      <polyline points="20 6 9 17 4 12" />
    </svg>
  ),

  trash: ({ size = 20, color = "currentColor", className }: IconProps) => (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke={color}
      strokeWidth="1.75"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
    >
      <polyline points="3 6 5 6 21 6" />
      <path d="M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2" />
      <line x1="10" y1="11" x2="10" y2="17" />
      <line x1="14" y1="11" x2="14" y2="17" />
    </svg>
  ),

  launch: ({ size = 20, color = "currentColor", className }: IconProps) => (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke={color}
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
    >
      <polygon points="5 3 19 12 5 21 5 3" fill={color} fillOpacity="0.2" />
    </svg>
  ),

  google: ({ size = 20, className }: IconProps) => (
    <svg
      width={size}
      height={size}
      viewBox="0 0 48 48"
      className={className}
      aria-hidden="true"
    >
      <path
        fill="#4285F4"
        d="M45.12 24.5c0-1.56-.14-3.06-.4-4.5H24v8.51h11.84c-.51 2.75-2.06 5.08-4.39 6.64v5.52h7.11c4.16-3.83 6.56-9.47 6.56-16.17z"
      />
      <path
        fill="#34A853"
        d="M24 46c5.94 0 10.92-1.97 14.56-5.33l-7.11-5.52c-1.97 1.32-4.49 2.1-7.45 2.1-5.73 0-10.58-3.87-12.31-9.07H4.34v5.7C7.96 41.07 15.4 46 24 46z"
      />
      <path
        fill="#FBBC05"
        d="M11.69 28.18A13.98 13.98 0 0110.94 24c0-1.45.25-2.86.7-4.18v-5.7H4.34A21.98 21.98 0 002 24c0 3.55.85 6.91 2.34 9.88z"
      />
      <path
        fill="#EA4335"
        d="M24 10.75c3.23 0 6.13 1.11 8.41 3.29l6.31-6.31C34.91 4.18 29.93 2 24 2 15.4 2 7.96 6.93 4.34 14.12l7.35 5.7c1.73-5.2 6.58-9.07 12.31-9.07z"
      />
    </svg>
  ),
};

/* 数学单元专属图标 */
export const UnitIcons: Record<
  string,
  React.FC<{ size?: number; color?: string }>
> = {
  hash: ({ size = 48, color }) => (
    <svg width={size} height={size} viewBox="0 0 48 48">
      <text
        x="24"
        y="33"
        textAnchor="middle"
        fill={color}
        fontFamily="Space Grotesk"
        fontWeight="700"
        fontSize="30"
      >
        #
      </text>
    </svg>
  ),
  ops: ({ size = 48, color }) => (
    <svg width={size} height={size} viewBox="0 0 48 48">
      <text
        x="24"
        y="31"
        textAnchor="middle"
        fill={color}
        fontFamily="JetBrains Mono"
        fontWeight="500"
        fontSize="20"
      >
        + − ×
      </text>
    </svg>
  ),
  frac: ({ size = 48, color }) => (
    <svg width={size} height={size} viewBox="0 0 48 48">
      <text
        x="24"
        y="18"
        textAnchor="middle"
        fill={color}
        fontFamily="JetBrains Mono"
        fontWeight="500"
        fontSize="16"
      >
        3
      </text>
      <line x1="12" y1="24" x2="36" y2="24" stroke={color} strokeWidth="2" />
      <text
        x="24"
        y="40"
        textAnchor="middle"
        fill={color}
        fontFamily="JetBrains Mono"
        fontWeight="500"
        fontSize="16"
      >
        4
      </text>
    </svg>
  ),
  dec: ({ size = 48, color }) => (
    <svg width={size} height={size} viewBox="0 0 48 48">
      <text
        x="15"
        y="33"
        textAnchor="middle"
        fill={color}
        fontFamily="JetBrains Mono"
        fontWeight="500"
        fontSize="28"
      >
        3.
      </text>
      <text
        x="36"
        y="33"
        textAnchor="middle"
        fill={color}
        fontFamily="JetBrains Mono"
        fontWeight="500"
        fontSize="28"
        opacity="0.45"
      >
        14
      </text>
    </svg>
  ),
  int: ({ size = 48, color }) => (
    <svg width={size} height={size} viewBox="0 0 48 48">
      <line
        x1="4"
        y1="24"
        x2="44"
        y2="24"
        stroke={color}
        strokeWidth="1.5"
        opacity="0.4"
      />
      {[12, 20, 28, 36].map((x, i) => (
        <circle
          key={x}
          cx={x}
          cy={24}
          r={3}
          fill={color}
          opacity={0.4 + i * 0.2}
        />
      ))}
      <text x="3" y="19" fill={color} fontFamily="JetBrains Mono" fontSize="11">
        −
      </text>
      <text
        x="39"
        y="19"
        fill={color}
        fontFamily="JetBrains Mono"
        fontSize="11"
      >
        +
      </text>
    </svg>
  ),
  alg: ({ size = 48, color }) => (
    <svg width={size} height={size} viewBox="0 0 48 48">
      <rect
        x="8"
        y="8"
        width="32"
        height="32"
        rx="8"
        stroke={color}
        strokeWidth="2"
        fill={color}
        fillOpacity="0.08"
      />
      <text
        x="24"
        y="33"
        textAnchor="middle"
        fill={color}
        fontFamily="Space Grotesk"
        fontWeight="700"
        fontSize="26"
        fontStyle="italic"
      >
        x
      </text>
    </svg>
  ),
  geo: ({ size = 48, color }) => (
    <svg width={size} height={size} viewBox="0 0 48 48">
      <polygon
        points="24,8 42,40 6,40"
        stroke={color}
        strokeWidth="2"
        fill={color}
        fillOpacity="0.1"
        strokeLinejoin="round"
      />
    </svg>
  ),
  meas: ({ size = 48, color }) => (
    <svg width={size} height={size} viewBox="0 0 48 48">
      <rect
        x="8"
        y="14"
        width="32"
        height="20"
        rx="3"
        stroke={color}
        strokeWidth="2"
        fill={color}
        fillOpacity="0.08"
      />
      {[14, 22, 30, 38].map((x, i) => (
        <line
          key={x}
          x1={x}
          y1="14"
          x2={x}
          y2={20 + i * 2}
          stroke={color}
          strokeWidth="1.5"
        />
      ))}
    </svg>
  ),
  stat: ({ size = 48, color }) => (
    <svg width={size} height={size} viewBox="0 0 48 48">
      <rect
        x="8"
        y="28"
        width="8"
        height="12"
        rx="1.5"
        fill={color}
        opacity="0.4"
      />
      <rect
        x="20"
        y="18"
        width="8"
        height="22"
        rx="1.5"
        fill={color}
        opacity="0.7"
      />
      <rect x="32" y="8" width="8" height="32" rx="1.5" fill={color} />
    </svg>
  ),
  pat: ({ size = 48, color }) => (
    <svg width={size} height={size} viewBox="0 0 48 48">
      {[
        { x: 10, r: 4, o: 0.35 },
        { x: 22, r: 5, o: 0.6 },
        { x: 34, r: 6.5, o: 0.9 },
      ].map((p) => (
        <circle key={p.x} cx={p.x} cy="24" r={p.r} fill={color} opacity={p.o} />
      ))}
    </svg>
  ),
};
