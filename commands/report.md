---
name: report
description: Generate a weekly support performance report with KPIs, team rankings, channel breakdown, and AI automation stats. Run this for your weekly standup or executive summary.
allowed-tools: mcp__corebee__get_metrics,mcp__corebee__get_agent_performance,mcp__corebee__get_channel_analytics,mcp__corebee__get_trends,mcp__corebee__generate_report
---

# /corebee:report — Weekly Support Report

Generate a complete support operations snapshot.

## Steps

1. Call `get_metrics` with `period: "this_week"` for dashboard KPIs
2. Call `get_agent_performance` with `period: "this_week"` for team stats
3. Call `get_channel_analytics` with `period: "this_week"` for channel breakdown
4. Call `get_trends` with `metric: "conversations"` and `period: "last_7_days"`
5. Call `get_trends` with `metric: "ai_responses"` and `period: "last_7_days"`

## Output Format

### Support Operations — Weekly Report

**Overview**
- Open conversations: [count]
- Resolved this week: [count]
- New contacts: [count]
- Total messages: [count]
- AI automation rate: [ai_responses / total_messages]%

**Team Performance**

| Agent | Assigned | Resolved | Resolution Rate |
|-------|----------|----------|-----------------|
| [Name] | [n] | [n] | [n]% |

**Channel Breakdown**

| Channel | Conversations | Messages |
|---------|--------------|----------|
| [Name] | [n] | [n] |

**Trends**
- Volume: [increasing/stable/decreasing] vs last week
- AI automation: [improving/stable/declining]

**Key Insights**
- Top performer, busiest channel, any spikes or anomalies

## Rules

- Use agent names from profiles, not IDs
- AI rate = ai_responses / total_messages * 100
- Highlight wins and flag areas needing attention
