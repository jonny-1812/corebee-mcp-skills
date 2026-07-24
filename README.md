# Corebee -- AI Customer Support Plugin for Claude Code

Corebee is an AI-powered customer support platform with conversations, knowledge base, contact management, analytics, and multi-channel support. This plugin gives Claude full operational control over a Corebee workspace through 10 skills, 4 specialized agents, 4 slash commands, and a hook system for guardrails -- making it the most comprehensive support operations plugin available for Claude Code and Claude.ai.

## Quick Start

### Claude Code: install the plugin (recommended)

```bash
/plugin marketplace add jonny-1812/corebee-mcp-skills
/plugin install corebee@corebee
```

Then run `/mcp` and approve the Corebee OAuth login. No keys to paste. OAuth is
discovered automatically. You get the hosted MCP server plus 10 skills, 4 agents, and 4 commands.

### Claude Code: just the MCP server (no plugin)

```bash
claude mcp add --transport http corebee https://corebee.ai/api/v1/mcp/stream
```

### Claude.ai (Web)

Add Corebee as a remote MCP connector:

1. Open **Settings** > **Integrations**
2. Click **Add Integration**
3. Enter the server URL: `https://corebee.ai/api/v1/mcp/stream`
4. Complete the OAuth authorization flow

### No Corebee account yet?

Run **`/corebee:signup`**, or just tell your agent: **"Set up Corebee AI customer support for my product, start the free trial."**
The bundled **agent-signup** skill signs you up via `https://corebee.ai/api/auth/agent-signup`: you approve one
email (with a pairing phrase), and your agent gets back a scoped API key, your org, and a ready-to-paste widget
snippet. No dashboard, no browser login. 14-day trial, no card. That same key then drives every tool in this plugin.
Full agent flow: <https://corebee.ai/for-ai-agents> · <https://corebee.ai/llms.txt>

## What's Included

| Component | Count | Description |
|-----------|-------|-------------|
| Skills | 10 | Guided workflows for common support operations (incl. agent-native signup) |
| Agents | 4 | Specialized sub-agents for delegated analysis and action |
| Commands | 4 | Slash commands for quick, frequent tasks (incl. `/corebee:signup`) |
| Hooks | 5 | Guardrail scripts that validate, warn, and log tool usage |
| Settings | 6 | Configurable defaults shared across all skills |

## Skills

Skills are structured workflows that guide Claude through multi-step support operations using the MCP tools.

| Skill | Description | Example Triggers |
|-------|-------------|------------------|
| **agent-signup** | Create a brand new Corebee account from the terminal. One email approval, then returns a scoped key, workspace, and widget snippet | "Set up Corebee", "Start the free trial" |
| **inbox-triage** | Prioritize open conversations by urgency, suggest assignments, auto-assign with confirmation | "Triage my inbox", "What needs attention?" |
| **weekly-report** | Generate a full support report with KPIs, team rankings, channel breakdown, and trends | "Weekly report", "How did we do last week?" |
| **contact-onboard** | Add contacts with duplicate detection, bulk import, updates, and contextual notes | "Add John Smith john@acme.com", "Onboard these 5 contacts" |
| **knowledge-manager** | List sources, add URLs, search content, audit coverage gaps, view indexing stats | "What's in my KB?", "Add https://docs.acme.com" |
| **widget-customizer** | Configure chat widget colors, bot name, position, welcome message, and pre-chat form | "Make the widget blue", "Set bot name to Bee" |
| **escalation-manager** | Detect urgent conversations, assign to the best agent, log escalation notes, draft responses | "Escalate conversation 123", "Scan for anything urgent" |
| **team-workload** | Analyze agent capacity, detect overload, rebalance conversation assignments | "Show team workload", "Rebalance the queue" |
| **metrics-compare** | Compare support metrics between two periods with percentage deltas and trend analysis | "Compare this week to last week", "Is response time improving?" |
| **customer-360** | Build a unified customer profile from contacts, conversations, notes, and KB articles | "Tell me about john@acme.com", "Prepare me for a call with Acme" |

## Agents

Agents are specialized sub-agents that Claude delegates to for focused tasks. Each agent has a defined toolset and methodology.

| Agent | Role | Tools | Delegated When |
|-------|------|-------|----------------|
| **support-analyst** | Read-only analytics with a 5-step analysis methodology (collect, compare, correlate, conclude, recommend) | 5 | User asks for deep metric analysis, trend explanations, or data-driven recommendations |
| **conversation-helper** | Conversation lifecycle management with tone detection, KB-backed replies, and batch processing | 9 | User wants to draft replies, review threads, close tickets, or manage assignments |
| **kb-optimizer** | Knowledge base gap analysis by cross-referencing conversations with KB content | 7 | User wants to find what the AI cannot answer, identify outdated content, or improve KB coverage |
| **sla-monitor** | SLA compliance monitoring with per-agent compliance rates and corrective action suggestions | 7 | User wants to check for SLA breaches, identify at-risk conversations, or monitor response times |

## Commands

Commands are lightweight slash-command shortcuts for frequent operations.

| Command | Usage | What It Does |
|---------|-------|--------------|
| `/corebee:signup` | Run directly | Creates a brand new Corebee account from your terminal, then hands back your chat widget snippet and provisioned workspace |
| `/corebee:triage` | Run directly | Quick inbox triage -- classifies conversations as urgent, stale, or active and suggests assignments |
| `/corebee:report` | Run directly | Generates a weekly support report with overview KPIs, team performance table, channel breakdown, and trends |
| `/corebee:kb-status` | Run directly | Audits knowledge base health -- counts sources by status, flags errors and empty sources, recommends fixes |

## Hooks

Hooks are shell scripts that run automatically before or after specific tool calls, adding guardrails to support operations.

| Hook | Trigger | Behavior |
|------|---------|----------|
| **validate-reply.sh** | Before `reply_to_conversation` | Blocks empty replies, replies under 10 characters, and replies over 5,000 characters |
| **warn-destructive.sh** | Before `delete_*` or `close_*` | Displays a warning describing the destructive action about to be taken |
| **remind-resolution-note.sh** | After `close_conversation` | Reminds the user to add a resolution note to the contact record |
| **confirm-assignment.sh** | After `assign_conversation` | Confirms the assignment and suggests checking team workload for balanced distribution |
| **log-agent-start.sh** | On sub-agent delegation | Logs which agent is being delegated to for visibility |

## Settings

All skills share a common settings file (`settings.json`) with configurable defaults.

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `default_period` | string | `this_week` | Default time period for metrics and reports. Options: `today`, `this_week`, `this_month`, `last_7_days`, `last_30_days` |
| `sla_threshold_hours` | number | `4` | Hours before an unanswered conversation is flagged as SLA-breaching (range: 1-72) |
| `auto_assign` | boolean | `false` | Whether skills execute assignments without confirmation |
| `report_format` | string | `markdown` | Output format for reports. Options: `markdown`, `plain_text` |
| `show_ids` | boolean | `false` | Display internal UUIDs alongside human-readable names |
| `timezone` | string | `UTC` | IANA timezone for all timestamps and date calculations |

## MCP Server

**Server URL:** `https://corebee.ai/api/v1/mcp/stream` (Streamable HTTP, OAuth 2.1 auto-discovered)

The Corebee MCP server exposes 28 tools across 5 categories:

| Category | Tools | Description |
|----------|-------|-------------|
| **Conversations** | 5 | List, view, reply, assign, and close support conversations |
| **Contacts** | 6 | Manage customer contacts -- search, create, update, delete, and add notes |
| **Knowledge Base** | 6 | Manage AI training data -- add URLs, search content, track indexing |
| **Metrics** | 5 | Dashboard KPIs, agent performance, channel analytics, trends, reports |
| **Settings** | 6 | Widget customization, team members, organization settings |

All 28 tools are referenced by at least one skill or agent in this plugin.

## Example Prompts

**Inbox and triage:**
- "Triage my inbox -- what needs attention?"
- "Auto-assign unassigned conversations"
- "Deep review the open tickets"

**Reporting and analytics:**
- "Give me a weekly report"
- "Compare this week to last week"
- "How is our response time trending?"
- "Executive summary for this month"

**Conversations:**
- "Draft a reply to conversation 456"
- "Close the resolved tickets with a summary"
- "Escalate this to Sarah -- it's urgent"
- "Scan for anything breaching SLA"

**Contacts and customers:**
- "Add a new contact: Maria Lopez, maria@startup.io, interested in Enterprise"
- "Customer 360 for john@acme.com"
- "Prepare me for a call with Acme Corp"

**Knowledge base:**
- "What's in my knowledge base?"
- "Add https://docs.acme.com/help to my KB"
- "Search my KB for refund policy"
- "Audit my knowledge base for gaps"

**Team and workload:**
- "Show team workload"
- "Who has bandwidth for a VIP escalation?"
- "Rebalance the queue -- James is overloaded"

**Widget:**
- "Make the widget teal and set the bot name to Bee"
- "Show current widget settings"

## Authentication

The MCP server supports two authentication methods:

- **OAuth 2.0** with PKCE and Dynamic Client Registration (RFC 7591) -- used automatically by Claude.ai and Claude Code
- **API Key** via `X-API-Key` header -- for programmatic access and custom integrations

## License

MIT

## Links

- [Corebee](https://corebee.ai) -- AI Customer Support Platform
- [MCP Specification](https://modelcontextprotocol.io) -- Model Context Protocol
