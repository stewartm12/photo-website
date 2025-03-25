export const fetchData = async (query, variables = {}) => {
  const apiUrl = process.env.RAILS_API_URL;

  const response = await fetch(apiUrl, {
    method: "POST",
    headers: {
      "Authorization": process.env.API_ACCESS_TOKEN,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      query,
      variables,
    }),
  });

  const result = await response.json();
  return result;
};
