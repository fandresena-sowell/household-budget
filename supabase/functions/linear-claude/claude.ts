import type { Anthropic } from 'npm:@anthropic-ai/sdk@latest';
import { fetchDoc } from './utils.ts';

// URLs for the documentation files in Supabase Storage
const ARCHITECTURE_URL =
  'https://shlmxjcwcyrlhqxhhdem.supabase.co/storage/v1/object/public/docs//architecture.md';
const TECH_STACK_URL =
  'https://shlmxjcwcyrlhqxhhdem.supabase.co/storage/v1/object/public/docs//tech-stack.md';

export const summarizeLinearTicket = async (client: Anthropic, linearTicketContent: string) => {
  const architectureContent = await fetchDoc(ARCHITECTURE_URL);
  const techStackContent = await fetchDoc(TECH_STACK_URL);

  const SYSTEM_PROMPT = `You are tasked with translating a customer Linear ticket into an actionable context document and implementation guidelines for our development teams. This process involves carefully analyzing the ticket, extracting key information, and presenting it in a clear, structured format that aligns with our app Architecture `;

  const BASE_TEXT_PROMPT = `First, review the customer ticket:
  {{LINEAR_TICKET_CONTENT}}

  To complete this task, follow these steps:

  1. Analyze the customer ticket:
    - Identify the main issue or feature request
    - Note any specific requirements or constraints mentioned
    - Highlight any technical details provided
    - Recognize any urgency or priority indicators

  2. Create an actionable context document:
    - Summarize the issue or feature request in 2-3 sentences
    - List key points from the ticket that are crucial for understanding the context
    - Identify any potential impacts on existing systems or features
    - Note any dependencies or prerequisites for implementation

  3. Develop implementation guidelines:
    - Outline the suggested steps for addressing the issue or implementing the feature
    - Highlight any specific technical considerations or challenges
    - Reference relevant sections of the company guidelines that apply to this task
    - Suggest any additional resources or expertise that may be required

  4. Format your response:
    Present your analysis in the following structure, using appropriate Markdown format:

    ## Actionable context
    [Include your summary and key points here]

    ## Implementation guidelines
    [Include your step-by-step guidelines here]

  Remember to maintain a professional tone throughout your response. Focus on clarity and actionability, ensuring that the development team can easily understand and act upon the information provided.

  Your final output should consist of only the actionable context and Implementation guidelines sections. Do not include any additional commentary or explanations outside of these sections.`;

  // Construct the final TEXT_PROMPT
  const TEXT_PROMPT = `
  -----
  Here are some additional contexts:
  [ARCHITECTURE]
  ${architectureContent}
  -----
  [TECH STACK]
  ${techStackContent}
  -----
  ${BASE_TEXT_PROMPT}
  `;

  const msg = await client.messages.create({
    model: 'claude-3-7-sonnet-20250219',
    max_tokens: 20000,
    temperature: 1,
    system: SYSTEM_PROMPT,
    messages: [
      {
        role: 'user',
        content: [
          {
            type: 'text',
            text: TEXT_PROMPT.replace('{{LINEAR_TICKET_CONTENT}}', linearTicketContent),
          },
        ],
      },
    ],
  });
  if (msg.content[0].type === 'text') {
    return msg.content[0].text;
  } else {
    throw new Error('No text content found');
  }
};
