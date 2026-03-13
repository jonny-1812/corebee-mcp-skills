# Corebee MCP Skills

Claude Code skills and plugin for [Corebee](https://corebee.ai) — AI-powered customer support platform.

## What is Corebee?

Corebee is a customer support platform with AI-powered conversations, knowledge base, contact management, analytics, and multi-channel support. This repository contains Claude Code skills that extend Claude's ability to interact with Corebee through the MCP (Model Context Protocol) server.

## MCP Server

**Server URL:** `https://corebee.ai/api/v1/mcp`

The Corebee MCP server provides 28 tools across 5 categories:

| Category | Tools | Description |
|----------|-------|-------------|
| **Conversations** | 5 | List, view, reply, assign, and close support conversations |
| **Contacts** | 6 | Manage customer contacts, search, create, update, delete, and add notes |
| **Knowledge Base** | 6 | Manage AI training data — add URLs, search content, track indexing |
| **Metrics** | 5 | Dashboard KPIs, agent performance, channel analytics, trends, reports |
| **Settings** | 6 | Widget customization, team members, organization settings |

## Skills

Skills are packaged instructions that help Claude use the MCP tools effectively for common workflows.

### Available Skills

| Skill | Description |
|-------|-------------|
| **[inbox-triage](skills/inbox-triage/SKILL.md)** | Triage and prioritize open support conversations. Summarizes unassigned conversations, identifies urgent issues, and suggests assignments. |
| **[weekly-report](skills/weekly-report/SKILL.md)** | Generate a comprehensive weekly support operations report with KPIs, team performance, channel breakdown, and trends. |
| **[contact-onboard](skills/contact-onboard/SKILL.md)** | Onboard a new contact into the support system by creating their profile, adding notes, and checking for duplicates. |
| **[knowledge-manager](skills/knowledge-manager/SKILL.md)** | Manage the AI knowledge base — list sources, check indexing status, add new URLs, search content, and audit coverage gaps. |
| **[widget-customizer](skills/widget-customizer/SKILL.md)** | Customize the chat widget appearance and behavior through natural language — colors, messages, bot name, and more. |

## Installation

### Claude.ai (Web)

Add Corebee as a remote MCP connector in Claude.ai Settings → Integrations using the server URL above. OAuth authentication is handled automatically.

### Claude Code (CLI)

```bash
# Add the MCP server
claude mcp add corebee --transport sse https://corebee.ai/api/v1/mcp
```

## Authentication

The MCP server supports:
- **OAuth 2.0** with PKCE and Dynamic Client Registration (RFC 7591) — used by Claude.ai
- **API Key** via `X-API-Key` header — for programmatic access

## Example Prompts

```
"Triage my inbox — what needs attention?"
"Give me a weekly report of our support metrics"
"Add a new contact: John Smith, john@acme.com"
"What's in my knowledge base?"
"Change the widget color to blue and set the bot name to Bee"
"Show my open conversations"
"How is my team performing this month?"
"Search my knowledge base for refund policy"
```

## License

MIT

## Links

- [Corebee](https://corebee.ai) — AI Customer Support Platform
- [MCP Specification](https://modelcontextprotocol.io) — Model Context Protocol
