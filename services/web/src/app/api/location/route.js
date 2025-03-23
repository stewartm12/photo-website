import { getLocationSuggestions } from '@/graphql/queries/location';

export async function GET(request) {
  const { searchParams } = new URL(request.url)
  const query = searchParams.get("query")

  const results = await getLocationSuggestions(query)

  return Response.json({ locations: results })
}
