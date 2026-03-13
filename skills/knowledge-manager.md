---
name: knowledge-manager
description: Manage the AI knowledge base — list sources, check indexing status, add new URLs, search content, and audit coverage gaps. Use when the user asks about their knowledge base, wants to add training data, search KB content, or check what the AI knows.
---

# Knowledge Base Manager

Help users manage their AI knowledge base to ensure the support bot has accurate, up-to-date information.

## When to Use

- User asks "what's in my knowledge base", "show my KB sources", "what does my AI know"
- User wants to add a URL or document to the knowledge base
- User asks to search the knowledge base for specific information
- User wants to audit their KB for gaps or outdated content

## Workflows

### View Knowledge Base Status

1. Use `list_knowledge_sources` to get all sources
2. Present a summary: total sources, how many are active vs pending vs errored
3. Flag any sources with errors that need attention

### Add a Knowledge Source

1. When user provides a URL, use `add_knowledge_url` with the URL and an optional name
2. Explain that processing happens asynchronously
3. Offer to check status later using `get_knowledge_source`

### Search Knowledge Content

1. Use `search_knowledge` with the user's query
2. Present matching results with source attribution
3. If no results found, suggest adding relevant content

### Audit Knowledge Base

1. Use `list_knowledge_sources` to get all sources
2. Identify: sources with 0 chunks (not indexed), errored sources, very old sources
3. Present findings with recommended actions

## Response Format

**Knowledge Base Overview**
- Total sources: [count]
- Active (indexed): [count]
- Pending: [count]
- Errored: [count]

| Source | Type | Status | Chunks | Last Updated |
|--------|------|--------|--------|-------------|
| [name] | [url/file] | [status] | [count] | [date] |

## Important

- Always show source names, not just IDs
- For errored sources, show the error message
- When adding URLs, validate they look like real URLs before calling the tool
- Processing is async — set expectations that new sources take a few minutes to index
