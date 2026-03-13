---
name: weekly-report
description: Generate a comprehensive weekly support operations report combining dashboard KPIs, team performance rankings, channel breakdown, and conversation trends. Use when the user asks for a weekly report, performance summary, support metrics, how the team is doing, executive summary, or wants to see the numbers.
allowed-tools: mcp__corebee__get_metrics,mcp__corebee__get_agent_performance,mcp__corebee__get_channel_analytics,mcp__corebee__get_trends,mcp__corebee__generate_report
argument-hint: "Time period (e.g., this_week, this_month) or 'compare last week'"
user-invocable: true
---

# Weekly Support Report

Generate a complete support operations snapshot by combining data from multiple analytics tools.

## Workflow Modes

### Current Period (default)

Generates a full report for a single time period.

1. Determine the period from the user's request. Default: `this_week`. Supported values: `this_week`, `last_week`, `this_month`, `last_month`, `last_7_days`, `last_30_days`.
2. Fetch dashboard KPIs using `get_metrics` with the resolved period
3. Fetch team performance using `get_agent_performance` with the same period
4. Fetch channel breakdown using `get_channel_analytics` with the same period
5. Fetch conversation trends using `get_trends` with `metric: "conversations"` and the period
6. Fetch AI automation trends using `get_trends` with `metric: "ai_responses"` and the period
7. Compile and present the full report

### Comparison Mode

Compares two periods side by side with delta calculations showing improvement or regression.

1. Determine the two periods (e.g., `this_week` vs `last_week`, or `this_month` vs `last_month`)
2. Fetch all data for both periods (KPIs, team performance, channels, trends)
3. Calculate deltas for each metric: absolute change and percentage change
4. Flag metrics that improved with an up arrow and metrics that regressed with a down arrow
5. Present the comparison table with both periods and the delta column

### Executive Summary

A condensed version for leadership — key numbers, top-line trends, and action items only. No detailed tables.

1. Fetch dashboard KPIs using `get_metrics` with the resolved period
2. Fetch team performance using `get_agent_performance` (top 3 performers only)
3. Fetch conversation trends using `get_trends` with `metric: "conversations"`
4. Present a 5-8 line summary with: total volume, resolution rate, average response time, AI automation rate, top performer, and one key insight or action item

## Report Structure

### Support Operations — Weekly Report

**Overview ([Period])**
- Open conversations: [count]
- Resolved this period: [count]
- New contacts: [count]
- Total messages: [count]
- AI-handled responses: [count] ([percentage]% automation rate)
- Avg first response time: [duration]
- Avg resolution time: [duration]

**Team Performance**
| Agent | Assigned | Resolved | Resolution Rate | Avg Response Time |
|-------|----------|----------|-----------------|-------------------|
| [Name] | [count] | [count] | [rate]% | [duration] |

**Channel Breakdown**
| Channel | Conversations | Messages | Avg Response Time |
|---------|--------------|----------|-------------------|
| [Name] | [count] | [count] | [duration] |

**Trends**
- Conversation volume trend: [increasing/stable/decreasing]
- AI automation trend: [improving/stable/declining]
- Response time trend: [improving/stable/declining]

**Key Insights**
- Notable observations: spikes, top performers, channels needing attention
- Recommended actions based on the data

### Comparison Report Additions

When in Comparison Mode, add a delta column to each table:

| Metric | [Period A] | [Period B] | Delta |
|--------|-----------|-----------|-------|
| Resolved | [count] | [count] | +[n] ([x]%) |

## Examples

- **"Weekly report"** — Runs Current Period mode for `this_week`. Produces the full report.
- **"Compare this week to last week"** — Runs Comparison Mode. Shows both periods side by side with deltas.
- **"Executive summary for this month"** — Runs Executive Summary mode for `this_month`. Produces a concise 5-8 line summary.
- **"How did we do last week?"** — Runs Current Period mode for `last_week`.
- **"Monthly report with comparison to last month"** — Runs Comparison Mode for `this_month` vs `last_month`.

## Edge Cases

- **No data for the requested period**: Report "No data available for [period]" and suggest trying a different time range or checking that the Corebee integration is active.
- **Partial data (some API calls succeed, others fail)**: Present the data that is available and clearly note which sections are missing. Do not fabricate numbers.
- **Missing or inactive agents**: If `get_agent_performance` returns agents with zero activity, include them in the table but note them as inactive. Do not exclude them silently.
- **New team (first week)**: If there is no prior period for comparison, skip Comparison Mode and note that baseline data is being established.
- **Very high volume (1000+ conversations)**: Summarize by category rather than listing individual conversations. Focus on aggregates and percentages.
- **API errors**: Report the specific error and suggest retrying. If `get_metrics` fails, the report cannot be generated — inform the user.

## Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `default_period` | this_week | The default time period when none is specified |
| `report_format` | markdown | Output format: `markdown` for tables and structure, `plain_text` for prose |
| `show_ids` | false | Include raw metric IDs in the output for debugging |
| `timezone` | UTC | Timezone for period boundaries and timestamps |

## Cross-Skill References

- Use **/metrics-compare** for deeper drill-down analysis on specific metrics across custom date ranges.
- Use **/inbox-triage** after reviewing the report to act on open conversations that need attention.

## Guidelines

- Always use agent names from profile data, not IDs (unless `show_ids` is enabled)
- Calculate AI automation rate as: ai_responses / total_messages * 100
- Keep the tone professional but conversational
- Highlight both wins (high resolution rates, fast response times) and areas for improvement
- In Comparison Mode, use clear directional indicators for deltas (up/down arrows or +/- signs)
- Respect the configured `timezone` when determining period boundaries
- When generating an Executive Summary, prioritize actionable insights over raw numbers
- Fetch all data sources in parallel where possible to minimize latency
