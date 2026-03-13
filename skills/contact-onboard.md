---
name: contact-onboard
description: Onboard a new contact into the support system by creating their profile, adding notes, and optionally starting a conversation. Use when the user wants to add a new customer, create a contact, register a lead, or onboard someone into the CRM.
---

# Contact Onboarding

Streamline the process of adding new contacts to the support system with proper data and context.

## When to Use

- User says "add a new contact", "onboard this customer", "create a contact for..."
- User provides a name/email/phone and wants them added to the system
- User wants to register a lead or new customer

## Process

1. **Check for duplicates** first using `list_contacts` with `search` set to the email or name
2. If no duplicate found, **create the contact** using `create_contact` with all provided details
3. If the user provides context about the contact (e.g., "they're interested in the Pro plan"), **add a note** using `add_contact_note`
4. **Confirm creation** by showing the contact details back to the user

## Gathering Information

If the user doesn't provide all details, ask for:
- **Name** (required) — full name of the contact
- **Email** (recommended) — for communication
- **Phone** (optional) — if relevant
- Any context or notes about the contact

Do not ask for fields the user hasn't mentioned — keep it lightweight.

## Response Format

After creating:

**Contact Created**
- Name: [full name]
- Email: [email]
- Phone: [phone if provided]
- ID: [contact_id]
- Note: [if added]

If a duplicate was found:
"A contact with that email already exists: [name] (ID: [id]). Would you like to update their information instead?"

## Important

- Always check for duplicates before creating
- Preserve exactly what the user provided — don't fabricate details
- If creation fails, explain the error clearly
- Offer to add notes if the user provided context about the contact
