---
name: contact-onboard
description: Onboard a new contact into the support system by checking for duplicates, creating their profile, and adding contextual notes. Use when the user wants to add a new customer, create a contact, register a lead, onboard someone into the CRM, or mentions a new person they want to track.
---

# Contact Onboarding

Streamline adding new contacts with duplicate detection and contextual notes.

## Process

1. Check for duplicates using `list_contacts` with `search` set to the email or name
2. If no duplicate found, create the contact using `create_contact` with all provided details
3. If the user provides context about the contact, add a note using `add_contact_note`
4. Confirm creation by showing the contact details

## Information Gathering

If the user provides partial info, ask for:
- **Name** (required) — full name
- **Email** (recommended) — for communication
- **Phone** (optional) — if relevant

Do not ask for fields the user has not mentioned. Keep it lightweight.

## Output Format

After creating:

**Contact Created**
- Name: [full name]
- Email: [email]
- Phone: [phone if provided]
- ID: [contact_id]
- Note: [if added]

If a duplicate was found:
"A contact with that email already exists: [name] (ID: [id]). Would you like to update their information instead?"

## Guidelines

- Always check for duplicates before creating
- Preserve exactly what the user provided — do not fabricate details
- If the user provides context like "interested in Pro plan", add it as a note automatically
- Offer to update existing contacts if duplicates are found using `update_contact`
