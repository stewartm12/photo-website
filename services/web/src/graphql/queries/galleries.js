import { fetchData } from "@/utils/fetch-data";

export const gallerySlugsQuery = async () => {
  const query = `
    query {
      galleries {
        id
        name
        description
        slug
      }
    }
  `;
  const response = await fetchData(query);
  return response.data.galleries;
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
          }
        }
        photo {
          id
          fileKey
          altText
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
  `;
  const response = await fetchData(query);
  return response.data.galleries;
};
