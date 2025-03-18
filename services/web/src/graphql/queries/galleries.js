export const gallerySlugsQuery = async(name) => {
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
            description
            slug
          }
        }
      `,
    }),
  }).then((res) => res.json());

  return response.data.galleries
};

export const photosBySlugQuery = async(name) => {
  const apiUrl = process.env.RAILS_API_URL;

  const response = await fetch(apiUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      query: `
        query {
          gallery(slug: "${name}") {
            id
            name
            description
            collections {
              id
              name
              photos {
                id
                fileKey
                altText
              }
            }
            photo {
              id
              fileKey
              altText
            }
          }
        }
      `,
    }),
  }).then((res) => res.json());

  return response.data.gallery
};

export const galleryPackageData = async() => {
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
            description
            photo {
              id
              fileKey
            }
            packages {
              id
              name
              price
              popular
              duration
              features
            }
            addOns {
              id
              name
              price
            }
          }
        }
      `
    })
  }).then((res) => res.json());

  return response.data.galleries
};
