---
name: triage
description: Triage the support inbox — shows urgent conversations, stale tickets, and suggests assignments. Run this to quickly see what needs attention.
allowed-tools: mcp__corebee__list_conversations,mcp__corebee__get_conversation,mcp__corebee__list_team_members,mcp__corebee__assign_conversation
---

# /corebee:triage — Inbox Triage

Quickly review and prioritize the support queue.

## Steps

1. Call `list_conversations` with `status: "open"` to get all open conversations
2. Call `list_team_members` to check who is available
3. For each unassigned or high-priority conversation, call `get_conversation` to read the latest messages

## Classify each conversation

- **Urgent**: Unassigned AND (high priority OR no response for 4+ hours)
- **Needs response**: Assigned but no activity for 4+ hours
- **In progress**: Assigned and recently active

## Output

Present as a prioritized list:

**Urgent — Needs Immediate Attention**
- [Contact Name] — [Subject] — unassigned, [time] since last message
  → Suggest: Assign to [available agent] or respond now

**Stale — Awaiting Response**
- [Contact Name] — [Subject] — assigned to [agent], [time] idle

**Active — Being Handled**
- [Contact Name] — [Subject] — [agent] working, last activity [time ago]

## Rules

- Show names and emails, never raw UUIDs
- Format times as "2 hours ago", "yesterday", etc.
- If the user says "assign it", use `assign_conversation`
- Never auto-assign without the user's explicit approval
