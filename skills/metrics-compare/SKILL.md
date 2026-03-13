---
name: metrics-compare
description: Compare support metrics between two time periods side-by-side — see what improved, what declined, and calculate percentage deltas for conversations, resolution rates, response times, and AI automation. Use when the user wants to compare periods, see trends, or track progress over time.
allowed-tools: mcp__corebee__get_metrics,mcp__corebee__get_agent_performance,mcp__corebee__get_channel_analytics,mcp__corebee__get_trends
argument-hint: "Two periods (e.g., 'this week vs last week')"
user-invocable: true
---

# Metrics Compare

Compare support performance between two time periods to identify improvements, regressions, and trends. Surface actionable insights from the data.

## Process

### Step 1: Parse Periods

Interpret the user's request into two concrete date ranges. Common patterns:

- **"this week vs last week"** — Current Mon-Sun vs previous Mon-Sun
- **"March vs February"** — Full calendar months
- **"last 7 days vs previous 7 days"** — Rolling windows
- **"this quarter vs last quarter"** — Q1/Q2/Q3/Q4 boundaries

Use the configured `timezone` (default: UTC) for all date calculations. If the user provides ambiguous ranges, ask for clarification before proceeding.

### Step 2: Fetch Data

1. Fetch metrics for Period A using `get_metrics` with the first date range
2. Fetch metrics for Period B using `get_metrics` with the second date range
3. Fetch channel analytics for both periods using `get_channel_analytics` to break down by channel
4. Fetch agent performance for both periods using `get_agent_performance` to see individual trends
5. Optionally fetch trend data using `get_trends` for a continuous view across both periods

### Step 3: Calculate Deltas

For each metric, compute:

- **Absolute change**: Period B value minus Period A value
- **Percentage change**: ((Period B - Period A) / Period A) * 100
- **Direction indicator**: Up arrow for increase, down arrow for decrease, right arrow for no change

### Step 4: Assess Significance

Apply the significance threshold to highlight meaningful changes:

- Changes greater than **+10%** or less than **-10%** are flagged as significant
- Changes between -10% and +10% are considered stable
- For metrics where lower is better (response time, resolution time), a decrease is positive

### Step 5: Present Comparison

Format the results as a side-by-side comparison table with insights.

## Delta Calculation Rules

- **Percentage change**: Always calculate relative to Period A (the earlier period)
- **Division by zero**: If Period A value is 0, show "New" instead of a percentage
- **Rounding**: Round percentages to one decimal place
- **Direction context**: For some metrics, "up" is good (resolution rate, CSAT) and for others "up" is bad (response time, open conversations). Apply appropriate color coding in the assessment.

## Output Format

**Metrics Comparison: [Period A Label] vs [Period B Label]**

| Metric | [Period A] | [Period B] | Change | Delta |
|--------|-----------|-----------|--------|-------|
| Total conversations | 142 | 168 | +26 | +18.3% |
| Resolved | 128 | 155 | +27 | +21.1% |
| Avg first response | 14 min | 9 min | -5 min | -35.7% |
| Avg resolution time | 4.2 hr | 3.8 hr | -0.4 hr | -9.5% |
| AI auto-resolved | 38% | 45% | +7pp | +18.4% |
| CSAT score | 4.1 | 4.3 | +0.2 | +4.9% |

**Key Insights:**
- First response time improved significantly (-35.7%) — likely due to AI automation increase
- Conversation volume is up 18.3% — monitor team capacity
- CSAT improved slightly but within normal variance

**Significant Changes (>10%):**
- Total conversations: +18.3%
- Resolved conversations: +21.1%
- First response time: -35.7% (improvement)
- AI auto-resolved: +18.4%

When reporting channel breakdowns, add a secondary table showing per-channel comparisons.

## Examples

- **"Compare this week to last week"** — Fetches metrics for both 7-day windows and presents the full comparison table with insights.
- **"How did March compare to February?"** — Uses calendar month boundaries for both periods.
- **"Show me the trend over the last 30 days"** — Compares the last 15 days vs the 15 days before that, and supplements with trend data for a continuous chart description.
- **"Is our response time getting better?"** — Focuses the comparison on response time metrics specifically, with agent-level breakdown.
- **"Week over week comparison for the past month"** — Runs four weekly comparisons and presents them as a trend summary.
- **"Compare email vs chat performance this month"** — Uses channel analytics to compare metrics across channels within the same period.

## Edge Cases

- **No data for one period**: If one period returns empty metrics, report "No data available for [period]" and show only the available period's data. Do not calculate deltas.
- **Periods overlap**: If the two date ranges overlap, warn the user that overlapping periods will produce misleading comparisons. Suggest adjusted ranges.
- **Partial data**: If one period has fewer days of data (e.g., current week is only 3 days in), note this and suggest per-day averages for a fairer comparison.
- **Very small numbers**: When Period A values are very small (under 5), percentage changes can be misleadingly large. Note this context — e.g., "2 to 4 is +100% but the absolute change is small."
- **Metric not available**: If a specific metric is not returned by the API for either period, omit it from the table and note its absence.

## Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `default_period` | this_week | Default comparison window when the user does not specify |
| `report_format` | markdown | Output format: `markdown` for structured tables, `plain_text` for prose |
| `timezone` | UTC | Timezone for date range calculations |

## Cross-Skill References

- Use **/weekly-report** for the current period's standalone snapshot before comparing.
- Use **/team-workload** to correlate metric changes with staffing or workload shifts.
- The **support-analyst** agent (if available) can provide deeper statistical analysis on comparison data.

## Guidelines

- Always label periods clearly so the user knows which column is which
- Present percentage changes with direction context — "response time decreased 35%" is an improvement, make that clear
- When volume increases significantly, proactively mention capacity implications
- For CSAT and satisfaction scores, note that small absolute changes (e.g., 4.1 to 4.3) can be meaningful at scale
- If the user asks for a trend rather than a two-period comparison, use `get_trends` and describe the trajectory narratively
- Round all numbers appropriately: times to one decimal, percentages to one decimal, counts to whole numbers
