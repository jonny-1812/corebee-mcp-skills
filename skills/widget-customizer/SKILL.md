---
name: widget-customizer
description: Customize the customer-facing chat widget appearance and behavior through natural language — colors, welcome messages, bot name, reply time expectations, logo, position, and pre-chat form settings. Use when the user wants to change how their widget looks, update branding, configure the chat experience, or mentions widget settings.
---

# Widget Customizer

Configure the customer-facing chat widget through natural language commands.

## Process

1. Show current settings using `get_widget_settings` so the user sees what they have
2. Apply changes using the appropriate tool:
   - Visual changes (color, logo, position, welcome text): `configure_widget_appearance`
   - Behavioral changes (bot name, reply time, pre-chat form): `configure_widget_behavior`
   - Mixed changes: `update_widget_settings`
3. Confirm changes by showing before and after

## Color Translation

When users say color names, convert to hex:
- Blue: #2563EB, Red: #DC2626, Green: #16A34A, Purple: #9333EA
- Teal: #0D9488, Orange: #EA580C, Pink: #EC4899, Black: #1F2937

## Common Requests

| User Says | Parameter |
|-----------|-----------|
| "Make it blue" | `widget_color: "#2563EB"` |
| "Change bot name to Bee" | `bot_name: "Bee"` |
| "Put it on the left" | `position: "left"` |
| "Enable pre-chat form" | `pre_chat_form_enabled: true` |
| "Set reply time to a few hours" | `reply_time: "in_a_few_hours"` |

## Constraints

- Colors must be valid 6-digit hex with # prefix
- Position only accepts "left" or "right"
- Reply time only accepts: "in_a_few_minutes", "in_a_few_hours", "in_a_day"

## Guidelines

- Always show current settings before making changes
- Confirm changes after applying, showing what changed
- If the user asks to "match my brand", ask for their preferred color
