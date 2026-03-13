---
name: widget-customizer
description: Customize the customer-facing chat widget appearance and behavior through natural language — colors, welcome messages, bot name, reply time expectations, logo, position, and pre-chat form settings. Use when the user wants to change how their widget looks, update branding, configure the chat experience, or mentions widget settings.
allowed-tools: mcp__corebee__get_widget_settings,mcp__corebee__configure_widget_appearance,mcp__corebee__configure_widget_behavior,mcp__corebee__update_widget_settings,mcp__corebee__get_organization_settings
argument-hint: "What to change (e.g., 'make it blue', 'bot name to Bee')"
user-invocable: true
---

# Widget Customizer

Configure the customer-facing chat widget through natural language commands.

## Workflow Modes

### 1. Quick Change

1. Fetch current settings using `get_widget_settings`
2. Apply using the appropriate tool:
   - Visual (color, logo, position, welcome text): `configure_widget_appearance`
   - Behavioral (bot name, reply time, pre-chat form): `configure_widget_behavior`
   - Mixed: `update_widget_settings`
3. Confirm by showing before vs after for modified fields only

### 2. Full Brand Setup

1. Fetch current settings with `get_widget_settings` and org context with `get_organization_settings`
2. Walk through: color, bot name, welcome message, reply time, position, pre-chat form
3. Apply all changes at once using `update_widget_settings`
4. Show a complete summary of the final configuration

### 3. Review Current Settings

1. Fetch settings using `get_widget_settings` (optionally `get_organization_settings` for context)
2. Present all settings in a clean summary format

## Color Translation

When users say color names, convert to hex:

| Color | Hex | Color | Hex |
|-------|-----|-------|-----|
| Blue | #2563EB | Navy | #1E3A5F |
| Red | #DC2626 | Crimson | #B91C1C |
| Green | #16A34A | Forest | #15803D |
| Purple | #9333EA | Violet | #7C3AED |
| Teal | #0D9488 | Cyan | #06B6D4 |
| Orange | #EA580C | Amber | #D97706 |
| Pink | #EC4899 | Rose | #F43F5E |
| Black | #1F2937 | Slate | #475569 |
| Gray | #6B7280 | Indigo | #4F46E5 |
| Yellow | #EAB308 | Lime | #84CC16 |
| White | #FFFFFF | Coral | #F97316 |

If the user provides a hex code directly, use it as-is after validating the format.

## Brand Preset Templates

Suggest these when the user says "match my brand" or asks for inspiration:

| Preset | Primary Color | Style |
|--------|--------------|-------|
| Professional | #1E3A5F (Navy) | Clean, corporate |
| Friendly | #2563EB (Blue) | Approachable, modern |
| Bold | #DC2626 (Red) | High energy, urgent |
| Nature | #16A34A (Green) | Calm, organic |
| Creative | #9333EA (Purple) | Innovative, playful |
| Warm | #EA580C (Orange) | Welcoming, energetic |
| Minimal | #1F2937 (Black) | Sleek, understated |

## Examples

| User Says | Workflow | Key Parameters |
|-----------|----------|----------------|
| "Make the widget blue" | Quick Change | `widget_color: "#2563EB"` |
| "Change bot name to Bee" | Quick Change | `bot_name: "Bee"` |
| "Put it on the left" | Quick Change | `position: "left"` |
| "Enable pre-chat form and set reply time to a few minutes" | Quick Change | `pre_chat_form_enabled: true`, `reply_time: "in_a_few_minutes"` |
| "Set up my brand: green theme, bot name Helper" | Full Brand Setup | multiple fields |
| "Show current widget settings" | Review Current Settings | n/a |
| "I want a professional look" | Full Brand Setup | Professional preset |

## Constraints

- **Colors**: Valid 6-digit hex with # prefix. Reject 3-digit shorthand.
- **Position**: Only `"left"` or `"right"`. Explain valid options if user says anything else.
- **Reply time**: Only `"in_a_few_minutes"`, `"in_a_few_hours"`, or `"in_a_day"`. Map casual language.
- **Bot name**: Any string. Keep short and user-friendly.
- **Logo URL**: Must be a valid URL. Suggest CDN upload if user provides a local path.

## Edge Cases

- **Invalid color**: If the user provides a color name not in the table, ask for a hex code or suggest the closest match.
- **Unsupported position**: Explain that only "left" and "right" are supported. Default is "right".
- **Conflicting settings**: If a change would conflict with another setting, warn the user (e.g., very light widget color with white welcome text may be hard to read).
- **No changes needed**: If the requested value is already set, inform the user that the setting is already configured that way.

## Settings Reference

- **`show_ids`**: When enabled, display setting IDs and widget IDs in output. When disabled, omit for cleaner output.

## Output Format

### Settings Summary

**Widget Settings**
- Color: [hex] ([color name])
- Bot Name: [name]
- Welcome Message: [message]
- Reply Time: [value]
- Position: [left/right]
- Pre-chat Form: [enabled/disabled]
- Logo: [url or "not set"]

### Change Confirmation

**Widget Updated**
- [field]: [old value] -> [new value]

## Cross-Skill References

- Use **/knowledge-manager** to audit the AI knowledge base that powers your widget's automated responses.
- Use **/weekly-report** to see how chat widget engagement changes after updating your branding.
- Use **/customer-360** to see how individual customers interact through your widget.

## Guidelines

- Always show current settings before making changes
- Confirm changes after applying, showing what changed
- If the user asks to "match my brand", suggest a preset or ask for their color
- Use `get_organization_settings` during Full Brand Setup for org context
- Use `update_widget_settings` when multiple settings change at once
- Keep responses concise — show results, not explanations
