---
name: weekly-report
description: Generate a comprehensive weekly support operations report with KPIs, team performance, channel breakdown, and trends. Use when the user asks for a weekly report, performance summary, support metrics overview, or wants to know how their team is doing.
---

# Weekly Support Report

Generate a comprehensive support operations report covering all key metrics, team performance, and channel analytics.

## When to Use

- User asks for "weekly report", "how are we doing", "support metrics", "team performance"
- User wants an overview of their support operations
- User asks "give me the numbers" or "generate a report"

## Process

1. **Fetch dashboard metrics** using `get_metrics` with `period: "this_week"`
2. **Fetch team performance** using `get_agent_performance` with `period: "this_week"`
3. **Fetch channel analytics** using `get_channel_analytics` with `period: "this_week"`
4. **Fetch conversation trends** using `get_trends` with `metric: "conversations"` and `period: "last_7_days"`
5. **Fetch AI response trends** using `get_trends` with `metric: "ai_responses"` and `period: "last_7_days"`

## Report Format

Present a structured report:

### Support Operations — Weekly Report

**Overview (This Week)**
- Open conversations: [count]
- Resolved this week: [count]
- New contacts: [count]
- Total messages: [count]
- AI-handled responses: [count] ([percentage]% automation rate)

**Team Performance**
| Agent | Assigned | Resolved | Resolution Rate |
|-------|----------|----------|-----------------|
| [Name] | [count] | [count] | [rate]% |

**Channel Breakdown**
| Channel | Conversations | Messages |
|---------|--------------|----------|
| [Name] | [count] | [count] |

**Trends**
- Conversation volume: [trend direction — increasing/stable/decreasing]
- AI automation: [trend — improving/stable]

**Key Insights**
- Highlight anything notable: spikes, agents with high/low resolution rates, channels with unusual activity

## Important

- Always use agent names (not IDs) from the performance data
- Calculate AI automation rate as: ai_responses / total_messages * 100
- Compare to previous periods if the user asks for trends
- Keep the tone professional but conversational
