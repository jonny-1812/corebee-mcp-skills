---
name: inbox-triage
description: Triage and prioritize open support conversations. Summarizes unassigned conversations, identifies urgent issues, and suggests assignments. Use when the user asks to review their inbox, triage conversations, check what needs attention, or handle unassigned tickets.
---

# Inbox Triage

Automatically triage open support conversations by reviewing status, priority, and content to help the user manage their support queue efficiently.

## When to Use

- User asks to "triage my inbox", "what needs attention", "show me unassigned conversations"
- User wants a summary of open conversations with recommended actions
- User asks "what's urgent" or "prioritize my queue"

## Process

1. **Fetch open conversations** using `list_conversations` with `status: "open"`
2. **Fetch team members** using `list_team_members` to know who is available for assignment
3. **Analyze each conversation**:
   - Check if it has an assignee — flag unassigned ones
   - Check priority level — surface high-priority items first
   - Check last activity time — flag conversations going stale (no activity >4 hours)
4. **For conversations needing attention**, use `get_conversation` to read the messages and understand the issue
5. **Present a prioritized summary** to the user:
   - Group by urgency: Critical (high priority + unassigned), Needs Response (stale), Assigned (in progress)
   - For each conversation: show contact name, subject, time since last activity, current assignee
   - Suggest specific actions: assign to available agent, escalate, or respond

## Response Format

Present results as a clear prioritized list:

**Needs Immediate Attention:**
- [Contact Name] — [Subject] — unassigned, [time] since last message
  → Suggested action: Assign to [available agent] or respond directly

**Awaiting Response:**
- [Contact Name] — [Subject] — assigned to [agent], [time] since last activity

**In Progress:**
- [Contact Name] — [Subject] — [agent] is handling, last activity [time ago]

## Important

- Always show contact names and emails, not just IDs
- Calculate time since last activity in human-readable format
- If the user asks to assign or respond, use `assign_conversation` or `reply_to_conversation`
- Never auto-assign or auto-respond without user confirmation
