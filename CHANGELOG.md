# Changelog

## [2.0.0] - 2026-03-13

### Added
- 4 new skills: escalation-manager, team-workload, metrics-compare, customer-360
- 2 new agents: kb-optimizer (knowledge base gap analysis), sla-monitor (SLA compliance)
- Hook system with 5 scripts: validate-reply, warn-destructive, remind-resolution-note, confirm-assignment, log-agent-start
- settings.json with 6 configurable options: default_period, sla_threshold_hours, auto_assign, report_format, show_ids, timezone
- Cross-skill references linking related skills and agents

### Changed
- All 9 skills now include allowed-tools, argument-hint, and user-invocable frontmatter
- All skills expanded to ~120 lines with workflow modes, examples, edge cases, and settings references
- support-analyst agent expanded with 5-step analysis methodology and 3 output modes
- conversation-helper agent expanded with 5 workflow modes, 4 tone options, and KB-backed replies (added search_knowledge, list_contacts, get_contact tools)
- plugin.json fixed: removed invalid displayName and skills fields, added repository and email
- Full tool coverage: all 28 MCP tools now referenced by at least one skill or agent

### Fixed
- plugin.json schema compliance (removed non-standard fields)
- Settings value consistency across skills and settings.json

## [1.0.0] - 2026-03-13

### Added
- Initial release
- 5 skills: inbox-triage, weekly-report, contact-onboard, knowledge-manager, widget-customizer
- 3 commands: triage, report, kb-status
- 2 agents: support-analyst, conversation-helper
- MCP server integration with OAuth 2.0 + PKCE + Dynamic Client Registration
- 28 tools across conversations, contacts, knowledge base, metrics, and settings
