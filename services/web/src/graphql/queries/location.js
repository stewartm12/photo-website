export async function getLocationSuggestions(query) {
  const apiUrl = process.env.RAILS_API_URL;

  const response = await fetch(apiUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      query: `
        query {
          autocompleteLocation(query: "${query}") {
            address
          }
        }
      `,
    }),
  }).then((res) => res.json());

  return response.data.autocompleteLocation;
};
