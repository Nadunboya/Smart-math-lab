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
