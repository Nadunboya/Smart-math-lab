export interface StudentProfile {
  id: string;
  email: string;
  student_name: string;
  grade: number;
  guardian_name: string;
  guardian_phone: string;
  other_phone: string | null;
  address: string;
  created_at: string;
}

export interface Concept {
  id: number;
  name: string;
  description: string;
  body: string | null;
}

export interface ShortNote {
  id: number;
  content: string;
}

export interface Unit {
  id: number;
  grade: number;
  name: string;
  sinhala_name: string | null;
  accent_color: string;
  icon_key: string;
  description: string;
  sort_order: number;
  concepts: Concept[];
  short_notes: ShortNote[];
}

export interface TeacherProfile {
  email: string;
  full_name: string | null;
  phone: string | null;
  bio: string | null;
  grades: number[];
  onboarded: boolean;
}
