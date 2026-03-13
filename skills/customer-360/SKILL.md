---
name: customer-360
description: Get a complete customer profile by aggregating contact details, conversation history, notes, and relevant knowledge base articles into a single unified view. Use when the user wants to see everything about a customer, look up a contact's full history, or prepare for a customer call.
allowed-tools: mcp__corebee__get_contact,mcp__corebee__list_contacts,mcp__corebee__list_conversations,mcp__corebee__get_conversation,mcp__corebee__search_knowledge,mcp__corebee__update_contact,mcp__corebee__add_contact_note
argument-hint: "Customer name or email"
user-invocable: true
---

# Customer 360

Build a complete, unified view of any customer by aggregating their contact profile, conversation history, support topics, notes, and relevant knowledge base articles into a single structured summary.

## Process

### Step 1: Look Up the Contact

1. If the user provides an email address, use `get_contact` or `list_contacts` to find the exact contact
2. If the user provides a name, use `list_contacts` to search by name
3. If multiple contacts match, present the list and ask the user to confirm which one
4. If no contact is found, report it and offer to create one using **/contact-onboard**

### Step 2: Fetch Conversation History

1. Use `list_conversations` filtered to the contact to retrieve all their conversations
2. Sort conversations by most recent first
3. For the most recent 5 conversations, use `get_conversation` to read the full message threads
4. For older conversations, include only the subject, status, date, and assigned agent

### Step 3: Identify Topics and Patterns

1. Analyze the conversation threads to identify recurring topics (e.g., billing, setup, integrations, bugs)
2. Note the customer's communication style and preferences (formal/informal, preferred channel)
3. Identify any unresolved issues or pending follow-ups
4. Track sentiment trajectory — is the customer generally satisfied, neutral, or frustrated?

### Step 4: Search Knowledge Base

1. Extract the top 3 topics from the customer's conversation history
2. Use `search_knowledge` for each topic to find relevant KB articles
3. Include articles that could help resolve open issues or anticipate future questions

### Step 5: Present Unified View

Compile everything into the structured profile card format below.

## Output Format

**Customer 360: [Full Name]**

---

**Profile**
- **Email**: [email]
- **Phone**: [phone or "Not provided"]
- **Company**: [company or "Not provided"]
- **Tags**: [list of tags]
- **Created**: [date first seen]
- **Last active**: [date of most recent conversation]

---

**Conversation History** ([total count] total)

| # | Subject | Status | Date | Agent | Channel |
|---|---------|--------|------|-------|---------|
| 1 | Password reset not working | Open | Mar 12 | Sarah M. | Email |
| 2 | Billing question | Resolved | Mar 8 | James K. | Chat |
| 3 | Setup help | Resolved | Feb 22 | Priya R. | Email |

**Recent Thread Summary:**
- **Password reset not working** (Open): Customer reports the reset link expires before they can use it. Sarah responded asking for browser details. Awaiting customer reply.
- **Billing question** (Resolved): Customer asked about upgrading from Pro to Enterprise. James provided pricing and the customer confirmed they will upgrade next month.

---

**Topics & Patterns**
- **Primary topics**: Account access (2 conversations), Billing (1 conversation)
- **Communication style**: Professional, concise, prefers email
- **Sentiment**: Generally positive — mild frustration on the password reset issue
- **Open issues**: Password reset link expiration (conversation #1)

---

**Relevant Knowledge Base Articles**
- "How to reset your password" — directly relevant to open issue
- "Upgrading your plan" — referenced in billing conversation
- "Browser compatibility requirements" — may help diagnose the reset issue

---

**Notes**
- [Date]: [Note content] — added by [agent]

When `show_ids` is enabled, include contact ID, conversation IDs, and article IDs.

## Examples

- **"Tell me about john@acme.com"** — Looks up the contact by email, fetches all conversations, analyzes topics, and presents the full 360 view.
- **"Customer 360 for Sarah Chen"** — Searches contacts by name, confirms the match, and builds the profile.
- **"Prepare me for a call with Acme Corp"** — Searches for contacts at Acme Corp, builds profiles for key contacts, and highlights open issues and recent interactions.
- **"What's the history with this customer?"** — If a conversation is already in context, identifies the contact from it and builds their 360 view.
- **"Add a note that this customer is considering churning"** — After viewing the 360, adds a contact note using `add_contact_note`.
- **"Update their phone number to 555-0123"** — Uses `update_contact` to modify the contact record.

## Edge Cases

- **Customer not found**: Report that no contact matches the search. Offer to search with alternate spellings or suggest creating a new contact with **/contact-onboard**.
- **No conversations yet**: Show the contact profile with an empty conversation section. Note "No conversation history — this is a new contact" and suggest relevant KB articles based on their company or tags.
- **Multiple contacts with the same name**: Present all matches with their email addresses and ask the user to confirm. Do not guess.
- **Very long history (50+ conversations)**: Show full threads for the 5 most recent conversations only. Summarize older conversations as a count by status and topic. Offer to dive deeper into specific older conversations on request.
- **Contact has no email**: Display available identifiers (phone, name, company). Note the missing email for data completeness.
- **KB search returns no results**: Skip the knowledge base section and note "No relevant KB articles found for this customer's topics."

## Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `show_ids` | false | Show contact, conversation, and article IDs in output |
| `timezone` | UTC | Timezone for displaying dates and activity times |

## Cross-Skill References

- Use **/contact-onboard** to create a new contact if the customer is not found in the system.
- Use **/escalation-manager** if the 360 view reveals an open critical issue that needs immediate attention.
- The **conversation-helper** agent can act on conversations surfaced during the 360 review (reply, assign, close).
- Use **/inbox-triage** to see where this customer's conversations sit in the overall queue priority.

## Guidelines

- Always present the most recent and relevant information first
- Summarize conversation threads concisely — the user needs context, not transcripts
- Highlight open issues and pending follow-ups prominently so nothing falls through the cracks
- When preparing for a call, emphasize actionable context: what is the customer's current issue, what has been tried, and what is the expected next step
- Respect data privacy — do not include sensitive information (payment details, passwords) in the profile view
- If the customer appears frustrated based on conversation sentiment, flag this clearly so the user can approach the interaction with care
- Keep the profile scannable — use the structured format consistently so the user can find information quickly
