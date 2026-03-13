---
name: team-workload
description: Analyze team capacity and workload distribution — see who is overloaded, who has bandwidth, and rebalance conversation assignments across the team. Use when the user asks about team capacity, workload, agent availability, or wants to redistribute work.
allowed-tools: mcp__corebee__list_team_members,mcp__corebee__list_conversations,mcp__corebee__get_metrics,mcp__corebee__get_agent_performance,mcp__corebee__assign_conversation
argument-hint: "View workload, rebalance, or check specific agent"
user-invocable: true
---

# Team Workload

Analyze agent capacity, detect overload conditions, and rebalance conversation assignments to keep the team running smoothly.

## Workflow Modes

### View Workload (default)

Display the current workload distribution across the entire team.

1. Fetch team members using `list_team_members` to get all agents, their roles, and online status
2. Fetch open conversations using `list_conversations` with `status: "open"` to see all active work
3. Count conversations per agent by grouping on the assignee field
4. Count unassigned conversations separately
5. Fetch agent performance data using `get_agent_performance` for each agent to add response time and resolution rate context
6. Calculate the distribution ratio: each agent's share of total open conversations as a percentage
7. Flag agents who exceed the overload threshold (12+ conversations)
8. Present the workload table

### Rebalance Queue

Redistribute conversations from overloaded agents to those with available capacity.

1. Run the View Workload workflow to get current state
2. Identify overloaded agents (12+ conversations) and underloaded agents (fewer than 6 conversations)
3. For each overloaded agent, select conversations to reassign — prefer newer, lower-priority, and unresponded conversations
4. Build a rebalance plan: which conversations move from which agent to which agent
5. Present the rebalance plan to the user for confirmation
6. On confirmation, execute reassignments using `assign_conversation` for each conversation
7. Also assign any unassigned conversations to agents with the most available capacity
8. Present a before-and-after summary showing the new distribution

### Check Specific Agent

Show detailed workload and performance data for a single agent.

1. Fetch team members using `list_team_members` to find the named agent
2. Fetch open conversations using `list_conversations` with `status: "open"` and filter to those assigned to the agent
3. Fetch the agent's performance data using `get_agent_performance`
4. Optionally fetch overall metrics using `get_metrics` for comparison
5. Present the agent detail card with their conversations, performance stats, and capacity status

## Workload Calculation

- **Conversations per agent**: Count of open conversations where the agent is the assignee
- **Unassigned count**: Open conversations with no assignee
- **Distribution ratio**: Agent's conversations divided by total open conversations, as a percentage
- **Capacity status**: Based on conversation count thresholds

### Capacity Thresholds

| Conversations | Status | Indicator |
|---------------|--------|-----------|
| 0-5 | Available | Low load — can take more work |
| 6-11 | Moderate | Normal operating range |
| 12-17 | Overloaded | At capacity — avoid new assignments |
| 18+ | Critical | Severely overloaded — needs immediate rebalancing |

## Output Format

Present workload as a structured table:

**Team Workload Overview:**

| Agent | Status | Open | Unresponded | Avg Response | Capacity |
|-------|--------|------|-------------|--------------|----------|
| Sarah M. | Online | 8 | 2 | 12 min | Moderate |
| James K. | Online | 14 | 5 | 28 min | Overloaded |
| Priya R. | Away | 3 | 0 | 8 min | Available |

**Unassigned:** 4 conversations
**Team total:** 25 open conversations across 3 agents
**Distribution health:** Imbalanced — James K. is handling 56% of the queue

When `show_ids` is enabled, include agent and conversation IDs.

## Examples

- **"Show team workload"** — Runs View Workload. Presents the full team table with capacity indicators.
- **"Who is overloaded?"** — Runs View Workload but filters output to only show agents at or above the overload threshold.
- **"Rebalance the queue"** — Runs Rebalance Queue. Proposes moving conversations from overloaded to underloaded agents.
- **"How many tickets does Sarah have?"** — Runs Check Specific Agent for Sarah with her open conversations and performance stats.
- **"Redistribute James's conversations"** — Runs Rebalance Queue focused specifically on moving work away from James.
- **"Who has bandwidth to take a VIP escalation?"** — Runs View Workload and highlights agents with Available capacity status.

## Edge Cases

- **Solo agent**: If only one agent exists, report their workload but skip rebalancing. Suggest hiring or adjusting expectations.
- **All agents at capacity**: Report the overload condition across the team. Suggest prioritizing critical conversations and deferring lower-priority items. Do not propose reassignments that would push anyone further over threshold.
- **No unassigned conversations**: In Rebalance mode, focus only on moving work between agents. Report that the unassigned queue is clear.
- **Agent offline or away**: Include offline agents in the workload view but do not assign new conversations to them during rebalancing. Note their status.
- **Agent not found**: If the user asks about a specific agent who does not exist, report that no matching agent was found and list available team members.
- **Identical workloads**: If all agents have the same count, report the distribution as balanced and skip rebalancing.

## Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `auto_assign` | false | Whether rebalancing executes without confirmation |
| `show_ids` | false | Show agent and conversation IDs in output |

## Cross-Skill References

- Use **/inbox-triage** alongside workload data to make informed assignment decisions during triage.
- Use **/escalation-manager** when an overloaded agent has critical conversations that need immediate reassignment.
- Use **/metrics-compare** to track whether workload distribution is improving or worsening over time.

## Guidelines

- Always show agent names and roles, not raw IDs (unless `show_ids` is enabled)
- Calculate response times in human-readable format (minutes, hours)
- During rebalancing, prefer moving conversations that have not yet received a response — this avoids breaking context for the customer
- Never reassign a conversation mid-thread without flagging it to the user
- Consider agent expertise and past interactions when suggesting reassignments, not just raw counts
- Respect agent availability status — do not assign work to offline agents
