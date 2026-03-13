---
name: knowledge-manager
description: Manage the AI knowledge base by listing sources, checking indexing status, adding new URLs, searching indexed content, and auditing for coverage gaps. Use when the user asks about their knowledge base, wants to add training data, search KB content, check what the AI knows, or audit documentation coverage.
allowed-tools: mcp__corebee__list_knowledge_sources,mcp__corebee__get_knowledge_source,mcp__corebee__add_knowledge_url,mcp__corebee__delete_knowledge_source,mcp__corebee__search_knowledge,mcp__corebee__get_knowledge_stats
argument-hint: "Action: list, add [url], search [query], audit, or stats"
user-invocable: true
---

# Knowledge Base Manager

Help users manage their AI knowledge base to ensure accurate, up-to-date information for the support bot.

## Workflow Modes

### 1. View Status

1. Use `list_knowledge_sources` to get all sources
2. Present summary: total sources, active vs pending vs errored
3. Flag any sources with errors and show the overview table

### 2. Add Source

1. Use `list_knowledge_sources` first to check if the URL already exists
2. If duplicate, inform the user and show existing source status
3. If new, use `add_knowledge_url` with the URL and optional name
4. Explain that processing is async (a few minutes). Offer to check status later with `get_knowledge_source`

### 3. Search Content

1. Use `search_knowledge` with the user's query
2. Present matching results with content previews and source attribution
3. If no results, suggest different search terms or adding relevant content

### 4. Audit Coverage

1. Use `list_knowledge_sources` and `get_knowledge_stats` together
2. Identify: sources with 0 chunks, errored sources, sources stale >30 days
3. Cross-reference with common topics (refund policy, pricing, getting started, troubleshooting, billing, integrations)
4. Present findings with recommended actions

### 5. View Stats

1. Use `get_knowledge_stats` to retrieve aggregate data
2. Present total sources, total chunks, index health, and notable patterns

### 6. Delete Source

1. Look up the source using `list_knowledge_sources` or `get_knowledge_source`
2. Confirm with the user — show source name, URL, and chunk count
3. Delete using `delete_knowledge_source` and confirm

## Examples

| User Says | Workflow |
|-----------|----------|
| "Show my KB status" | View Status |
| "Add https://docs.acme.com to my KB" | Add Source |
| "Search for refund policy" | Search Content |
| "Audit my knowledge base for gaps" | Audit Coverage |
| "Show KB stats" | View Stats |
| "Remove the old blog source" | Delete Source |
| "What does my AI know about pricing?" | Search Content |

## Output Formats

**Knowledge Base Overview** — Total: [count], Active: [count], Pending: [count], Errored: [count]

| Source | Type | Status | Chunks | Last Updated |
|--------|------|--------|--------|-------------|
| [name] | [url/file] | [status] | [count] | [date] |

**Audit Report** — Sources reviewed: [count], Issues: [count], Gaps: [topics]

| Issue | Source | Recommendation |
|-------|--------|----------------|
| 0 chunks | [name] | Re-add or check URL accessibility |
| Error state | [name] | Delete and re-add |
| Stale >30d | [name] | Re-index or verify content is current |

## Edge Cases

- **Source already exists**: Show existing status. Offer to delete and re-add to refresh.
- **URL unreachable**: Explain the URL may be behind auth, blocking bots, or temporarily down.
- **Indexing takes too long**: Indexing is async. Offer to check back with `get_knowledge_source`.
- **Search returns no results**: Suggest broader terms, then suggest adding content if topic is missing.
- **Delete confirmation**: Always confirm. Show source name and chunk count before deleting.

## Gap Analysis Guidance

When auditing, check coverage against these common support categories:
1. Getting started / onboarding
2. Pricing and billing
3. Refund and cancellation policy
4. Account management
5. Troubleshooting / FAQ
6. Integrations and API
7. Contact and escalation paths

If any category has zero or weak search results, flag it as a gap.

## Settings Reference

- **`show_ids`**: When enabled, display source IDs in output tables. When disabled, omit for cleaner output.

## Cross-Skill References

- For deeper analysis of KB quality and optimization recommendations, suggest: "Consider running the kb-optimizer agent for a comprehensive analysis."
- If the user mentions their bot is giving wrong answers, start with Search Content to verify what the KB actually contains.

## Guidelines

- Always show source names, not just IDs
- For errored sources, display the error message
- Processing is async — set expectations that new sources take a few minutes
- When searching, show content previews with source attribution
- When adding multiple URLs, process them sequentially and report results together
- When deleting, always confirm with the user first
