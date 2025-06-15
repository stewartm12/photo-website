
import { fetchData } from "@/utils/fetch-data";

export const showcaseQuery = async(name) => {
  const query = `
    query {
      showcase(name: "${name}") {
        id
        name
        photos {
          id
          fileKey
          altText
          sectionKey
          position
          imageUrl
        }
      }
    }
  `;

  const response = await fetchData(query);
  return response.data.showcase;
};
