import { fetchData } from "@/utils/fetch-data";

export async function getLocationSuggestions(search_query) {
  const query = `
    query {
      autocompleteLocation(query: "${search_query}") {
        address
      }
    }
  `;

  const response = await fetchData(query)
  return response.data.autocompleteLocation;
};
