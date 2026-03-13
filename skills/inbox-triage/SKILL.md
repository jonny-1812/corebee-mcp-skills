---
name: inbox-triage
description: Triage and prioritize open support conversations by reviewing unassigned tickets, identifying urgent issues, and suggesting agent assignments based on workload. Use when the user asks to review their inbox, triage conversations, check what needs attention, handle unassigned tickets, balance workload, or see what is urgent.
---

# Inbox Triage

Automatically review and prioritize the support queue by analyzing open conversations, team availability, and workload distribution.

## Process

1. Fetch open conversations using `list_conversations` with `status: "open"`
2. Fetch team members using `list_team_members` to check availability and roles
3. For each unassigned or high-priority conversation, use `get_conversation` to read messages and understand the issue
4. Present a prioritized summary grouped by urgency

## Prioritization Rules

- **Critical**: High priority AND unassigned — needs immediate attention
- **Needs Response**: No activity for 4+ hours — going stale
- **In Progress**: Assigned and recently active — being handled

## Output Format

Present results as a prioritized list:

**Needs Immediate Attention:**
- [Contact Name] — [Subject] — unassigned, [time] since last message
  Suggested action: Assign to [available agent name] or respond directly

**Awaiting Response:**
- [Contact Name] — [Subject] — assigned to [agent name], [time] since last activity

**In Progress:**
- [Contact Name] — [Subject] — [agent name] is handling, last activity [time ago]

## Guidelines

- Always show contact names and emails, not raw IDs
- Calculate time since last activity in human-readable format (e.g., "2 hours ago")
- If the user asks to assign or respond, use `assign_conversation` or `reply_to_conversation`
- Never auto-assign or auto-respond without explicit user confirmation
- Consider agent availability status when suggesting assignments
