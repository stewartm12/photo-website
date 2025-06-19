import { fetchData } from "@/utils/fetch-data";

export const gallerySlugsQuery = async () => {
  const query = `
    query {
      store {
        photo {
          imageUrl
        }
      }
      galleries {
        id
        name
        description
        slug
      }
    }
  `;
  const response = await fetchData(query);
  return response.data;
};

export const photosBySlugQuery = async (name) => {
  const query = `
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
            imageUrl
          }
        }
        photo {
          id
          fileKey
          altText
          imageUrl
        }
      }
    }
  `;
  const response = await fetchData(query);
  return response.data.gallery;
};

export const galleryPackageData = async () => {
  const query = `
    query {
      services {
        id
        name
        description
        photo {
          id
          fileKey
          imageUrl
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
  `;
  const response = await fetchData(query);
  return response.data.services;
};
