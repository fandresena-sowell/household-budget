export async function writeLinearComment(
  issueId: string,
  body: string,
): Promise<{ success: boolean; error?: string }> {
  const linearApiKey = Deno.env.get('LINEAR_API_KEY');
  if (!linearApiKey) {
    console.error('LINEAR_API_KEY environment variable not set.');
    return { success: false, error: 'Missing Linear API Key configuration.' };
  }

  const graphqlEndpoint = 'https://api.linear.app/graphql';
  const mutation = `
    mutation CommentCreate($issueId: String!, $body: String!) {
      commentCreate(input: { issueId: $issueId, body: $body }) {
        success
        comment {
          id
          body
        }
      }
    }
  `;

  const variables = {
    issueId: issueId,
    body: body,
  };

  try {
    const response = await fetch(graphqlEndpoint, {
      method: 'POST',
      headers: {
        Authorization: linearApiKey, // Use API Key directly as per docs for personal scripts/keys
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        query: mutation,
        variables: variables,
      }),
    });

    if (!response.ok) {
      const errorBody = await response.text();
      console.error(
        `Linear API request failed: ${response.status} ${response.statusText}`,
        errorBody,
      );
      return {
        success: false,
        error: `Linear API Error: ${response.status} - ${errorBody}`,
      };
    }

    const result = await response.json();

    if (result.errors) {
      console.error('Linear GraphQL Error:', JSON.stringify(result.errors, null, 2));
      return { success: false, error: `GraphQL Error: ${result.errors[0]?.message}` };
    }

    if (result.data?.commentCreate?.success) {
      console.log(`Successfully created comment on issue ${issueId}`);
      return { success: true };
    } else {
      console.error('Linear commentCreate mutation was not successful.', result.data);
      return { success: false, error: 'Comment creation failed.' };
    }
  } catch (error) {
    console.error('Error calling Linear API:', error);
    // Check if error is an instance of Error to safely access message
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    return { success: false, error: errorMessage };
  }
}
