This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Authentication

Sign-in is Google OAuth via Supabase Auth. First-time users are sent to
`/onboarding` to provide grade, student name, guardian name, guardian phone
number, an optional other phone number, and address; returning users land
directly on the home page. See `backend/README.md` for the FastAPI service
that stores this profile data and `backend/supabase_schema.sql` for the
`students` table.

1. Copy `.env.example` to `.env.local` and fill in your Supabase project URL
   and anon key (Project Settings > API), plus the FastAPI backend URL.
2. In Supabase, enable the Google provider (Authentication > Providers) and
   add `http://localhost:3000/auth/callback` (and your production URL) as an
   authorized redirect.
3. Set up and run the backend per `backend/README.md`.

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.
