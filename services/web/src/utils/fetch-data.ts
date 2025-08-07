type GraphQLError = {
  message: string;
  path?: string[];
  extensions?: Record<string, unknown>;
};

type GraphQLResponse<T> = {
  data?: T;
  errors?: GraphQLError[];
};

export const fetchData = async <T>(query: string, variables?: Record<string, unknown>): Promise<GraphQLResponse<T>> => {
  const isServer = typeof window === 'undefined';
  const apiUrl = isServer
  ? process.env.RAILS_API_URL // 'http://api:3000/graphql'
  : 'http://localhost:3001/graphql';
  const accessToken = process.env.API_ACCESS_TOKEN;
  const storeDomain = process.env.STORE_DOMAIN_URL;

  if (typeof apiUrl == "undefined" || typeof accessToken == "undefined" || typeof storeDomain == "undefined") {
    throw new Error(`apiUrl:${apiUrl} / accessToken:${accessToken} / storeDomain:${storeDomain}`);
  }

  const response = await fetch(apiUrl, {
    method: "POST",
    headers: {
      "Authorization": accessToken,
      "Content-Type": "application/json",
      "X-Store-Domain": storeDomain,
    },
    body: JSON.stringify({
      query,
      variables,
    }),
  });

  const result = await response.json();
  return result;
};
