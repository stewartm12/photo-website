import type { NextRequest } from 'next/server';
import { getLocationSuggestions } from '@/graphql/queries/location';

export async function GET(request: NextRequest): Promise<Response> {
  const { searchParams } = new URL(request.url);
  const query = searchParams.get("query");

  // Optional: Add runtime check for null query
  if (!query) {
    return new Response(JSON.stringify({ error: "Missing 'query' parameter" }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }

  const results = await getLocationSuggestions(query);

  return Response.json({ locations: results });
}