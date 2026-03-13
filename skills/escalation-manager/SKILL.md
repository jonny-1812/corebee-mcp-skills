---
name: escalation-manager
description: Handle urgent customer conversations end-to-end — identify critical issues, assign to the best available agent, log escalation notes, and optionally draft an immediate response. Use when the user says something is urgent, needs escalation, or wants to handle a critical ticket.
allowed-tools: mcp__corebee__list_conversations,mcp__corebee__get_conversation,mcp__corebee__reply_to_conversation,mcp__corebee__assign_conversation,mcp__corebee__close_conversation,mcp__corebee__list_team_members,mcp__corebee__add_contact_note
argument-hint: "Conversation ID or 'scan for urgent'"
user-invocable: true
---

# Escalation Manager

Handle critical customer conversations from detection through resolution — escalate, assign, respond, and de-escalate with full audit trails.

## Workflow Modes

### Escalate Specific Conversation

Escalate a known conversation by ID, assigning it to the best available agent and logging the escalation.

1. Fetch the conversation using `get_conversation` with the provided conversation ID
2. Fetch team members using `list_team_members` to find available agents
3. Evaluate the conversation: read the full thread to understand severity, customer sentiment, and topic
4. Select the best agent using the agent selection criteria below
5. Assign the conversation using `assign_conversation` to the selected agent
6. Log an escalation note on the contact using `add_contact_note` with the escalation reason, assigned agent, and timestamp
7. Optionally draft an immediate acknowledgment response — present it to the user for approval before sending via `reply_to_conversation`
8. Present the escalation summary

### Scan for Urgent Items

Proactively scan the inbox for conversations that meet escalation criteria and present them for action.

1. Fetch all open conversations using `list_conversations` with `status: "open"`
2. Fetch team members using `list_team_members` to check availability
3. For each open conversation, evaluate against the escalation criteria below
4. For conversations that meet criteria, use `get_conversation` to read the full thread and confirm urgency
5. Present a ranked list of conversations needing escalation, ordered by severity
6. Ask the user which conversations to escalate
7. For each confirmed escalation, run the Escalate Specific Conversation workflow

### De-escalate

Close a resolved escalation, log the resolution, and optionally notify the customer.

1. Fetch the conversation using `get_conversation` to confirm it is resolved
2. Verify the customer's issue has been addressed by reviewing the thread
3. Log a de-escalation note on the contact using `add_contact_note` with resolution details
4. Optionally draft a closing message for the customer — present for approval before sending
5. Close the conversation using `close_conversation`
6. Present a de-escalation summary with resolution time and outcome

## Escalation Criteria

A conversation qualifies for escalation if any of the following are true:

- **High priority flag**: The conversation is marked as high or urgent priority
- **SLA breach**: No response within the `sla_threshold_hours` window (default: 4 hours)
- **VIP customer**: The contact is tagged as VIP, enterprise, or high-value
- **Repeated contacts**: The customer has opened 3+ conversations in the past 7 days
- **Negative sentiment**: The conversation contains frustration indicators (e.g., "unacceptable", "cancel", "escalate", "speak to a manager")
- **Unassigned and aging**: No agent assigned and the conversation is older than 2 hours

## Agent Selection Criteria

When picking the best agent for an escalation, evaluate in this order:

1. **Online status**: Agent must be currently available or online
2. **Expertise match**: Prefer agents whose role or past conversations align with the issue topic
3. **Current workload**: Prefer agents with fewer active conversations (under 8 is ideal)
4. **Recency**: If the customer has spoken to a specific agent before, prefer that agent for continuity

If no agents are available, flag the escalation as unassignable and recommend the user check team schedules or handle it personally.

## Output Format

Present escalation results as a structured summary:

**Escalation Summary:**
- **Conversation**: [Subject] — [Contact Name] ([email])
- **Severity**: [Critical / High / Medium]
- **Reason**: [Why this was escalated — e.g., "SLA breach: 6 hours without response"]
- **Assigned to**: [Agent name]
- **Escalation note**: Logged on contact record
- **Response drafted**: [Yes — pending approval / No — not requested]

When `show_ids` is enabled, include conversation and contact IDs.

## Examples

- **"Escalate conversation 123"** — Runs Escalate Specific Conversation. Reads the thread, picks the best agent, assigns, logs the note, and offers to draft a response.
- **"Scan for anything urgent"** — Runs Scan for Urgent Items. Reviews all open conversations against escalation criteria and presents a ranked list.
- **"De-escalate — this is resolved"** — Runs De-escalate on the most recently discussed conversation. Logs resolution and closes.
- **"Escalate this to Sarah"** — Assigns to the named agent specifically rather than auto-selecting.
- **"Scan and auto-escalate anything breaching SLA"** — Scans and escalates all SLA-breaching conversations after presenting the list for confirmation.

## Edge Cases

- **No agents available**: Do not assign. Flag the conversation as "Escalated — Unassigned" in the contact note and alert the user to handle it manually or check schedules.
- **Conversation already assigned**: Inform the user of the current assignee. Offer to reassign if the current agent is unavailable or overloaded.
- **Customer already responded**: If the customer sent a new message while escalating, re-read the thread before drafting any response to avoid stale context.
- **Multiple conversations from same customer**: Consolidate context from all open threads before escalating. Mention related conversations in the escalation note.
- **Conversation already closed**: Report that the conversation is resolved. Offer to reopen if the user believes it still needs attention.

## Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `sla_threshold_hours` | 4 | Hours of inactivity before a conversation is flagged as SLA-breaching |
| `auto_assign` | false | Whether to assign without confirmation (use with caution) |
| `show_ids` | false | Show conversation and contact IDs in output |

## Cross-Skill References

- **/inbox-triage** often identifies conversations that need escalation — use escalation-manager to act on those findings.
- After escalating, use **/sla-monitor** (if available) for ongoing monitoring of the escalated conversation.
- Use **/team-workload** to verify agent capacity before assigning escalations.

## Rules

- Always log every escalation as a contact note — escalations must leave an audit trail
- Never send a reply to the customer without explicit user approval
- When drafting responses, acknowledge the customer's frustration and set clear expectations for next steps
- Prefer reassignment over closing when in doubt about resolution
- Treat repeated-contact escalations with extra care — the customer is already frustrated
