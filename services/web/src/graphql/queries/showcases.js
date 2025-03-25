import { fetchData } from "@/utils/fetch-data";

export const slideshowQuery = async(name) => {
  const query = `
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
  `;

  const response = await fetchData(query)
  return response.data.showcase
}

export const serviceCardQuery = async(name) => {
  const query = `
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
  `;

  const response = await fetchData(query)
  return response.data.showcase
}