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
          showcase(name: "slideshow") {
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

  return response.data.showcase
}

export const serviceCardQuery = async(name) => {
  const apiUrl = process.env.RAILS_API_URL;

  const response = await fetch(apiUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      query: `
        query {
          showcase(name: "service_card") {
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

  return response.data.showcase
}