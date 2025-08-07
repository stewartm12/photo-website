import type { GallerySlugsResponse } from "@/types/gallery";
import type { GalleryWithCollectionsResponse } from "@/types/collection";
import type { ServiceResponse } from "@/types/service"
import { fetchData } from "@/utils/fetch-data";

export const gallerySlugsQuery = async ():Promise<GallerySlugsResponse> => {
  const query = `
    query {
      store {
        photo {
          imageUrl(size: "hero")
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
  const response = await fetchData<GallerySlugsResponse>(query);
  if (!response.data) throw new Error("No data returned from GraphQL");
  return response.data;
};

export const photosBySlugQuery = async (slug: string):Promise<GalleryWithCollectionsResponse> => {
  const query = `
    query GetGalleryBySlug($slug: String!) {
      gallery(slug: $slug) {
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
            imageUrl(size: "masonry")
          }
        }
        photo {
          id
          fileKey
          altText
          imageUrl(size: "hero")
        }
      }
    }
  `;

  const variables = { slug };
  const response = await fetchData<GalleryWithCollectionsResponse>(query, variables);
  if (!response.data) throw new Error("No data returned from GraphQL");
  return response.data;
};

export const galleryPackageData = async ():Promise<ServiceResponse> => {
  const query = `
    query {
      services {
        id
        name
        description
        photo {
          id
          fileKey
          imageUrl(size: "hero")
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
  const response = await fetchData<ServiceResponse>(query);
  if (!response.data) throw new Error("No data returned from GraphQL");
  return response.data;
};
