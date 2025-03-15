export const slideshowQuery = async(name) => {
  const apiUrl = process.env.RAILS_API_URL;

  const response = await fetch(apiUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      query: `
        query {
          slideshow(name: "homepage") {
            id
            photos {
              id
              fileKey
              altText
            }
          }
        }
      `,
    }),
  }).then((res) => res.json());

  return response.data.slideshow
}