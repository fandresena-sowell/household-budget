import 'jsr:@supabase/functions-js/edge-runtime.d.ts';
import { Anthropic } from 'npm:@anthropic-ai/sdk@latest';
import { writeLinearComment } from './writeLinearComment.ts';
import { summarizeLinearTicket } from './claude.ts';
import { createResponse } from './utils.ts';
// Define constants for clarity
const TARGET_TEAM_ID = '57166695-8437-4ea6-b7cb-69ba08c11298'; // UI Team
const TARGET_STATUS_ID = 'ce6f9816-5704-4bd8-8706-0b75b976b680'; // Todo Status
const TARGET_LABEL_NAME = 'Bug'; // Using name as placeholder, might need ID later

Deno.serve(async (req) => {
  // Guard: Only process POST requests
  if (req.method !== 'POST') {
    console.log(`Received ${req.method} request, expected POST. Skipping.`);
    return createResponse(405, { error: 'Method Not Allowed' });
  }

  try {
    const payload = await req.json();
    console.log('Received Linear Webhook Payload:', JSON.stringify(payload, null, 2));

    // Guard: Check if it's an issue creation event
    if (payload.action !== 'create' || payload.type !== 'Issue') {
      console.log('Webhook received, but not an issue creation event. Skipping.');
      return createResponse(200, { message: 'Webhook received, event not processed.' });
    }

    // Guard: Check if payload data exists
    if (!payload.data) {
      console.log('Issue creation event received, but payload data is missing. Skipping.');
      return createResponse(400, { error: 'Bad Request: Missing payload data.' });
    }

    const issueData = payload.data;

    // Guard: Verify team
    if (issueData.teamId !== TARGET_TEAM_ID) {
      console.log(`Issue ${issueData.id} is not in the target team (${TARGET_TEAM_ID}). Skipping.`);
      return createResponse(200, { message: 'Webhook received, team condition not met.' });
    }

    // Guard: Verify status
    if (issueData.stateId !== TARGET_STATUS_ID) {
      console.log(
        `Issue ${issueData.id} does not have the target status (${TARGET_STATUS_ID}). Skipping.`,
      );
      return createResponse(200, { message: 'Webhook received, status condition not met.' });
    }

    // Guard: Verify label
    const hasTargetLabel =
      issueData.labelIds?.includes(TARGET_LABEL_NAME) || // Check if label ID array exists and includes 'Bug' ID (if known)
      issueData.labels?.some((label: { name: string }) => label.name === TARGET_LABEL_NAME); // Fallback to checking label name array

    if (!hasTargetLabel) {
      console.log(
        `Issue ${issueData.id} does not have the target label (${TARGET_LABEL_NAME}). Skipping.`,
      );
      return createResponse(200, { message: 'Webhook received, label condition not met.' });
    }

    console.log(`Conditions met for Issue ID: ${issueData.id}. Triggering Claude logic.`);

    const issueId = issueData.id;
    const issueTitle = issueData.title;
    const issueDescription = issueData.description;

    const anthropicClient = new Anthropic({
      apiKey: Deno.env.get('ANTHROPIC_API_KEY'),
    });

    const aiResponse = await summarizeLinearTicket(
      anthropicClient,
      `Title: ${issueTitle}\nDescription: ${issueDescription}`,
    );

    const { success, error } = await writeLinearComment(issueId, aiResponse);

    console.log('Linear comment result:', { success, error });

    if (!success) {
      return createResponse(500, {
        error: error || 'Failed to write comment in Linear using GraphQL',
      });
    }

    return createResponse(200, {
      message: 'Comment written successfully via GraphQL',
    });
  } catch (error) {
    console.error('Error processing webhook:', error);
    // Differentiate between JSON parsing errors and other errors
    if (error instanceof SyntaxError) {
      return createResponse(400, { error: 'Bad Request: Invalid JSON payload.' });
    }
    return createResponse(500, { error: 'Internal Server Error' });
  }
});
