import { revalidatePath, revalidateTag } from "next/cache";
import { NextResponse, NextRequest } from "next/server";

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();

    // 🔒 Security check
    // const secret = process.env.REVALIDATE_SECRET;
    // if (!body.secret || body.secret !== secret) {
    //   return NextResponse.json(
    //     { revalidated: false, error: "Unauthorized" },
    //     { status: 401 }
    //   );
    // }


    console.log("Revalidation request received with body:", body);
    const tags = body.tags;

    if (!tags || !Array.isArray(tags)) {
      return NextResponse.json({ message: 'Missing or invalid tags' }, { status: 400 });
    }

    // 🔁 Revalidate each tag
    tags.forEach((tag: string) => revalidateTag(tag));

    console.log('✅ Revalidated tags:', tags);
    return NextResponse.json({ revalidated: true, tags });
  } catch (err) {
    console.error('❌ Error revalidating:', err);
    return NextResponse.json({ message: 'Error revalidating' }, { status: 500 });
}



    // 🏷 Revalidate by tag
    // if (body.tags) {
    //   revalidateTag(body.tag);
    //   return NextResponse.json({ revalidated: true, type: "tag", target: body.tag });
    // }

  //   // 📄 Revalidate by path
  //   if (body.path) {
  //     revalidatePath(body.path);
  //     return NextResponse.json({ revalidated: true, type: "path", target: body.path });
  //   }

  //   return NextResponse.json(
  //     { revalidated: false, error: "Missing tag or path" },
  //     { status: 400 }
  //   );
//   } catch (error) {
//     console.error("Revalidation error:", error);
//     return NextResponse.json(
//       { revalidated: false, error: "Internal Server Error" },
//       { status: 500 }
//     );
//   }
}
