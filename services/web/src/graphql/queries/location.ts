import type { Location } from "@/types/location"
import { fetchData } from "@/utils/fetch-data";

export async function getLocationSuggestions(search: string): Promise<Location[]> {
  const query = `
    query {
      autocompleteLocation(query: "${search}") {
        address
      }
    }
  `;

  const response = await fetchData<Location[]>(query)
  if (!response.data) throw new Error("No data returned from GraphQL");
  return response.data;
};
