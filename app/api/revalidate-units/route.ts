import { NextResponse } from "next/server";
import { revalidateTag } from "next/cache";

// Called by the teacher UI right after a unit is created/updated/deleted, so
// students see the change immediately instead of waiting out the 5-minute
// cache window on the public units fetch. Low-risk to leave unauthenticated:
// worst case is an extra cache refresh of already-public curriculum content.
export async function POST() {
  // { expire: 0 } forces immediate expiration rather than Next 16's default
  // stale-while-revalidate — this route is called by an external fetch
  // right after a write, not a Server Action, so read-your-own-writes via
  // updateTag isn't available here.
  revalidateTag("units", { expire: 0 });
  return NextResponse.json({ revalidated: true });
}
