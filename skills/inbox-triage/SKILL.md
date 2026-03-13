---
name: inbox-triage
description: Triage and prioritize open support conversations by reviewing unassigned tickets, identifying urgent issues, and suggesting agent assignments based on workload. Use when the user asks to review their inbox, triage conversations, check what needs attention, handle unassigned tickets, balance workload, or see what is urgent.
allowed-tools: mcp__corebee__list_conversations,mcp__corebee__get_conversation,mcp__corebee__list_team_members,mcp__corebee__assign_conversation
argument-hint: "Quick scan, deep review, or auto-assign mode"
user-invocable: true
---

# Inbox Triage

Automatically review and prioritize the support queue by analyzing open conversations, team availability, and workload distribution.

## Workflow Modes

### Quick Scan (default)

A fast overview of the inbox state. Fetches open conversations and groups them by urgency without reading individual message threads.

1. Fetch open conversations using `list_conversations` with `status: "open"`
2. Fetch team members using `list_team_members` to check availability
3. Group conversations by priority bucket (Critical, Needs Response, In Progress)
4. Present the summary with counts and top items per bucket

### Deep Review

Reads into each unassigned or stale conversation to understand context and recommend specific actions.

1. Fetch open conversations using `list_conversations` with `status: "open"`
2. Fetch team members using `list_team_members` to check availability and current load
3. For each unassigned or high-priority conversation, use `get_conversation` to read the full message thread
4. Analyze sentiment, topic, and complexity of each conversation
5. Present a detailed prioritized summary with per-conversation action recommendations

### Auto-Assign

Automatically assigns unassigned conversations to available agents based on workload and availability. Requires explicit user confirmation before executing assignments.

1. Fetch open conversations using `list_conversations` with `status: "open"`
2. Fetch team members using `list_team_members` to check availability, roles, and current assignment counts
3. For each unassigned conversation, determine the best agent match based on lowest current load and online status
4. Present the proposed assignment plan and ask the user to confirm
5. On confirmation, execute assignments using `assign_conversation` for each conversation
6. Report results: how many assigned, to whom, and any that could not be assigned

## Prioritization Rules

- **Critical**: High priority AND unassigned, OR any conversation breaching the SLA threshold — needs immediate attention
- **Needs Response**: No activity for `sla_threshold_hours` (default: 4 hours) — going stale
- **In Progress**: Assigned and recently active — being handled
- **Waiting on Customer**: Agent responded, awaiting customer reply — monitor only

## Output Format

Present results as a prioritized list:

**Needs Immediate Attention:**
- [Contact Name] — [Subject] — unassigned, [time] since last message
  Suggested action: Assign to [available agent name] or respond directly

**Awaiting Response:**
- [Contact Name] — [Subject] — assigned to [agent name], [time] since last activity

**In Progress:**
- [Contact Name] — [Subject] — [agent name] is handling, last activity [time ago]

When `show_ids` is enabled, append the conversation ID in parentheses after each item.

## Examples

- **"Triage my inbox"** — Runs Quick Scan mode. Fetches all open conversations, groups by urgency, and presents the summary.
- **"Deep review the open tickets"** — Runs Deep Review mode. Reads each unassigned conversation thread and provides detailed recommendations.
- **"Auto-assign unassigned conversations"** — Runs Auto-Assign mode. Proposes assignments based on agent workload and waits for confirmation.
- **"What needs attention right now?"** — Runs Quick Scan mode focused on the Critical bucket only.
- **"Triage and assign anything older than 2 hours"** — Runs Auto-Assign mode with a custom SLA threshold of 2 hours instead of the default 4.

## Edge Cases

- **Empty inbox**: If no open conversations are found, report "Inbox is clear — no open conversations" and suggest checking resolved conversations or scheduling a review later.
- **All conversations already assigned**: Skip the assignment step. Report that all conversations have owners and highlight any that are approaching the SLA threshold.
- **All agents offline or unavailable**: Do not propose auto-assignments. Flag the unassigned conversations as critical and suggest the user manually assign or check team schedules.
- **API errors**: If `list_conversations` or `list_team_members` fails, report the error clearly and suggest the user retry or check the Corebee connection status.
- **Large inbox (50+ conversations)**: In Quick Scan mode, show the top 10 per bucket with a count of remaining. In Deep Review mode, warn that reviewing all threads will take time and offer to limit to the top 20 by priority.

## Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `sla_threshold_hours` | 4 | Hours of inactivity before a conversation is flagged as stale |
| `auto_assign` | false | Whether auto-assign mode executes without confirmation (use with caution) |
| `show_ids` | false | Show conversation IDs in the output for debugging or API use |
| `timezone` | UTC | Timezone for calculating activity times and SLA thresholds |

## Cross-Skill References

- Use **/escalation-manager** for conversations flagged as Critical that need immediate escalation workflows or manager notification.
- Use **/team-workload** to get a detailed view of agent capacity before running Auto-Assign mode.

## Guidelines

- Always show contact names and emails, not raw IDs (unless `show_ids` is enabled)
- Calculate time since last activity in human-readable format (e.g., "2 hours ago")
- Respect the configured `timezone` when computing SLA thresholds and activity times
- If the user asks to assign, use `assign_conversation`. For replies, suggest switching to the **conversation-helper** agent which has reply permissions
- Never auto-assign or auto-respond without explicit user confirmation unless `auto_assign` is set to true
- Consider agent availability status and current load when suggesting assignments
- When in doubt about urgency, escalate to Critical rather than downgrade
