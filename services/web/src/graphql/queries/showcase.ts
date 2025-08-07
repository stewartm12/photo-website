import type { Showcase } from "@/types/showcase";
import { fetchData } from "@/utils/fetch-data";

export const showcaseQuery = async(name: string): Promise<Showcase> => {
  const query = `
    query GetShowcaseByName($name: String!) {
      showcase(name: $name) {
        id
        name
        photos {
          id
          fileKey
          altText
          sectionKey
          position
          imageUrl(size: "masonry")
        }
      }
    }
  `;
  
  const variables = { name };
  const response = await fetchData<{showcase: Showcase}>(query, variables);
  if (!response.data) throw new Error("No data returned from GraphQL");
  return response.data.showcase;
};
