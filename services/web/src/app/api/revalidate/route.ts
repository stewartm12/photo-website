import { revalidateTag } from "next/cache";
import { NextResponse, NextRequest } from "next/server";

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const tags = body.tags;
    const secret = process.env.REVALIDATE_SECRET;

    // 🔒 Security check
    if (!body.secret || body.secret !== secret) {
      return NextResponse.json(
        { revalidated: false, error: "Unauthorized" },
        { status: 401 }
      );
    }

    if (!tags || !Array.isArray(tags)) {
      return NextResponse.json({ message: 'Missing or invalid tags' }, { status: 400 });
    }

    // 🔁 Revalidate each tag
    tags.forEach((tag: string) => revalidateTag(tag));

    return NextResponse.json({ revalidated: true, tags });
  } catch (err) {
    return NextResponse.json({ message: 'Error revalidating' }, { status: 500 });
  }
}
