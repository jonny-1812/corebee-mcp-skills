---
name: kb-status
description: Check the health of your AI knowledge base — shows indexed sources, pending items, errors, and coverage gaps. Run this to audit what your AI knows.
allowed-tools: mcp__corebee__list_knowledge_sources,mcp__corebee__get_knowledge_source,mcp__corebee__search_knowledge,mcp__corebee__get_knowledge_stats
---

# /corebee:kb-status — Knowledge Base Health Check

Audit the AI knowledge base for completeness and errors.

## Steps

1. Call `list_knowledge_sources` to get all sources
2. Count sources by status: active, pending, errored
3. Flag any sources with 0 indexed chunks (empty)
4. Flag any sources in error state

## Output Format

**Knowledge Base Health**
- Total sources: [count]
- Active (indexed): [count]
- Pending: [count]
- Errored: [count]

| Source | Type | Status | Chunks | Last Updated |
|--------|------|--------|--------|-------------|
| [name] | [url/file] | [status] | [count] | [date] |

**Issues Found**
- [source name]: Error — [error message]
- [source name]: Empty — 0 chunks indexed, may need re-crawl

**Recommendations**
- Suggest adding sources for common unanswered questions
- Suggest re-indexing errored sources

## Rules

- Show source names, not IDs
- Display error messages for failed sources
- If everything is healthy, say so clearly
