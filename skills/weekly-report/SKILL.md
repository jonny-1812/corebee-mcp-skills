---
name: weekly-report
description: Generate a comprehensive weekly support operations report combining dashboard KPIs, team performance rankings, channel breakdown, and conversation trends. Use when the user asks for a weekly report, performance summary, support metrics, how the team is doing, executive summary, or wants to see the numbers.
---

# Weekly Support Report

Generate a complete support operations snapshot by combining data from multiple analytics tools.

## Process

1. Fetch dashboard KPIs using `get_metrics` with `period: "this_week"`
2. Fetch team performance using `get_agent_performance` with `period: "this_week"`
3. Fetch channel breakdown using `get_channel_analytics` with `period: "this_week"`
4. Fetch conversation trends using `get_trends` with `metric: "conversations"` and `period: "last_7_days"`
5. Fetch AI automation trends using `get_trends` with `metric: "ai_responses"` and `period: "last_7_days"`

## Report Structure

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
- Conversation volume trend: [increasing/stable/decreasing]
- AI automation trend: [improving/stable]

**Key Insights**
- Notable observations: spikes, top performers, channels needing attention

## Guidelines

- Always use agent names from profile data, not IDs
- Calculate AI automation rate as: ai_responses / total_messages * 100
- Keep the tone professional but conversational
- Highlight both wins (high resolution rates) and areas for improvement
