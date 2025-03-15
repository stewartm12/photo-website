export const gallerySlugQueries = async(name) => {
  const apiUrl = process.env.RAILS_API_URL;

  const response = await fetch(apiUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      query: `
        query {
          galleries {
            id
            name
            slug
          }
        }
      `,
    }),
  }).then((res) => res.json());

  return response.data.galleries
};
