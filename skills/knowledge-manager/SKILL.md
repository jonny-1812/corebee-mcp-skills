---
name: knowledge-manager
description: Manage the AI knowledge base by listing sources, checking indexing status, adding new URLs, searching indexed content, and auditing for coverage gaps. Use when the user asks about their knowledge base, wants to add training data, search KB content, check what the AI knows, or audit documentation coverage.
---

# Knowledge Base Manager

Help users manage their AI knowledge base to ensure accurate, up-to-date information for the support bot.

## Workflows

### View Knowledge Base Status

1. Use `list_knowledge_sources` to get all sources
2. Present summary: total sources, active vs pending vs errored
3. Flag any sources with errors that need attention

### Add a Knowledge Source

1. Use `add_knowledge_url` with the URL and optional name
2. Explain that processing happens asynchronously (a few minutes)
3. Offer to check status later using `get_knowledge_source`

### Search Knowledge Content

1. Use `search_knowledge` with the user's query
2. Present matching results with source attribution
3. If no results found, suggest adding relevant content

### Audit Knowledge Base

1. Use `list_knowledge_sources` to get all sources
2. Identify: sources with 0 chunks, errored sources, outdated sources
3. Present findings with recommended actions

## Output Format

**Knowledge Base Overview**
- Total sources: [count]
- Active (indexed): [count]
- Pending: [count]
- Errored: [count]

| Source | Type | Status | Chunks | Last Updated |
|--------|------|--------|--------|-------------|
| [name] | [url/file] | [status] | [count] | [date] |

## Guidelines

- Always show source names, not just IDs
- For errored sources, display the error message
- Processing is async — set expectations that new sources take a few minutes
- When searching, show content previews with source attribution
