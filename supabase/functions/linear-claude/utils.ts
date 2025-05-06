export const createResponse = (status: number, body: Record<string, any>) => {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
};

export const fetchDoc = async (url: string): Promise<string> => {
  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`Failed to fetch ${url}: ${response.statusText}`);
    }
    return await response.text();
  } catch (error) {
    console.error(`Error fetching documentation from ${url}:`, error);
    return `Error fetching documentation from ${url}. Please check the URL and bucket permissions.`; // Return error message instead of throwing
  }
};
