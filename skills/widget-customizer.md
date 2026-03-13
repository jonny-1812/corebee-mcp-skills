---
name: widget-customizer
description: Customize the chat widget appearance and behavior — colors, welcome messages, bot name, reply time, pre-chat forms, and position. Use when the user wants to change how their support widget looks or behaves, update branding, or configure the chat experience.
---

# Widget Customizer

Help users configure their customer-facing chat widget's appearance and behavior through natural language.

## When to Use

- User asks to "change widget color", "update welcome message", "customize my chat widget"
- User wants to adjust bot name, reply time, or pre-chat form settings
- User asks to "brand my widget" or "match my website colors"

## Process

1. **Show current settings** first using `get_widget_settings` so the user sees what they have
2. **Apply requested changes** using the appropriate tool:
   - Visual changes (color, logo, position, welcome text): `configure_widget_appearance`
   - Behavioral changes (bot name, reply time, pre-chat form): `configure_widget_behavior`
   - Mixed changes: `update_widget_settings`
3. **Confirm changes** by showing what was updated

## Common Requests

| User Says | Tool | Parameters |
|-----------|------|-----------|
| "Make it blue" | `configure_widget_appearance` | `widget_color: "#2563EB"` |
| "Change bot name to Bee" | `configure_widget_behavior` | `bot_name: "Bee"` |
| "Put it on the left" | `configure_widget_appearance` | `position: "left"` |
| "Enable pre-chat form" | `configure_widget_behavior` | `pre_chat_form_enabled: true` |
| "Set reply time to a few hours" | `configure_widget_behavior` | `reply_time: "in_a_few_hours"` |

## Color Handling

When users say color names, convert to hex:
- Blue → #2563EB, Red → #DC2626, Green → #16A34A, Purple → #9333EA
- Teal → #0D9488, Orange → #EA580C, Pink → #EC4899, Black → #1F2937

If the user provides a brand URL or says "match my brand", ask for their preferred color rather than guessing.

## Important

- Always show current settings before making changes
- Colors must be valid 6-digit hex codes with # prefix
- Widget position only accepts "left" or "right"
- Reply time only accepts: "in_a_few_minutes", "in_a_few_hours", "in_a_day"
- Confirm changes after applying, showing before → after
