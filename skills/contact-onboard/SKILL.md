---
name: contact-onboard
description: Onboard a new contact into the support system by checking for duplicates, creating their profile, and adding contextual notes. Use when the user wants to add a new customer, create a contact, register a lead, onboard someone into the CRM, or mentions a new person they want to track.
allowed-tools: mcp__corebee__list_contacts,mcp__corebee__get_contact,mcp__corebee__create_contact,mcp__corebee__update_contact,mcp__corebee__delete_contact,mcp__corebee__add_contact_note
argument-hint: "Name and email (e.g., 'John Smith john@acme.com')"
user-invocable: true
---

# Contact Onboarding

Streamline adding new contacts with duplicate detection, bulk operations, updates, and contextual notes.

## Workflow Modes

### 1. Single Onboard

Use when the user provides one contact to add.

1. Check for duplicates using `list_contacts` with `search` set to the email or name
2. If no duplicate found, create the contact using `create_contact` with all provided details
3. If the user provides context about the contact (e.g., "interested in Pro plan"), add a note using `add_contact_note`
4. Confirm creation by showing the contact details

### 2. Bulk Onboard

Use when the user provides multiple contacts at once (a list, CSV paste, or describes several people).

1. Parse all contacts from the input — extract name and email for each
2. For each contact, check for duplicates using `list_contacts` with `search`
3. Create each non-duplicate contact using `create_contact`
4. Add notes to any contacts that had contextual info attached
5. Present a summary table: created, skipped (duplicate), and any errors

### 3. Update Existing

Use when the user wants to modify an existing contact's details.

1. Look up the contact using `list_contacts` with `search` or `get_contact` if ID is known
2. If not found, inform the user and offer to create a new contact instead
3. Apply changes using `update_contact` with only the fields that need changing
4. Confirm by showing the updated contact details

### 4. Delete Contact

Use when the user wants to remove a contact (e.g., test data, duplicate cleanup).

1. Look up the contact using `list_contacts` with `search` or `get_contact`
2. Confirm with the user before deleting — show the contact name and email
3. Delete using `delete_contact`
4. Confirm deletion

## Information Gathering

If the user provides partial info, ask for:
- **Name** (required) — full name
- **Email** (recommended) — for communication and duplicate detection
- **Phone** (optional) — only if relevant

Do not ask for fields the user has not mentioned. Keep it lightweight.

## Examples

| User Says | Workflow |
|-----------|----------|
| "Add John Smith john@acme.com" | Single Onboard |
| "Onboard these 5 contacts: ..." | Bulk Onboard |
| "Update the email for Sarah to sarah@new.co" | Update Existing |
| "Delete the test contact" | Delete Contact |
| "Register a lead: Maria Lopez, maria@startup.io, interested in Enterprise" | Single Onboard + note |

## Output Formats

### Single Contact Created

**Contact Created**
- Name: [full name]
- Email: [email]
- Phone: [phone if provided]
- ID: [contact_id] _(shown when `show_ids` is enabled in settings)_
- Note: [if added]

### Bulk Onboard Summary

**Bulk Onboard Complete**
- Created: [count]
- Skipped (duplicate): [count]
- Errors: [count]

| Name | Email | Status |
|------|-------|--------|
| [name] | [email] | Created / Duplicate / Error |

### Duplicate Found

"A contact with that email already exists: [name] (ID: [id]). Would you like to update their information instead?"

## Edge Cases

- **Duplicate found**: Offer to update the existing contact or skip. Never silently create a duplicate.
- **Partial info**: If only a name is provided, create with just the name. Do not block on missing optional fields.
- **Invalid email format**: If the email looks malformed (no @ sign, spaces, etc.), warn the user before proceeding.
- **Contact not found for update/delete**: Inform the user. Suggest searching with a different term or listing recent contacts.
- **Bulk with mixed results**: Complete all possible operations and report successes and failures together in the summary.

## Settings Reference

- **`show_ids`**: When enabled, display contact IDs in output. When disabled, omit IDs for cleaner output.

## Cross-Skill References

- After creating or updating a contact, suggest: "Run /customer-360 to see the full profile and interaction history for this contact."
- If the user mentions tickets or conversations during onboarding, note that those can be viewed through the customer-360 skill.

## Guidelines

- Always check for duplicates before creating
- Preserve exactly what the user provided — do not fabricate details
- If the user provides context like "interested in Pro plan", add it as a note automatically
- Offer to update existing contacts if duplicates are found using `update_contact`
- For bulk operations, process all contacts and report results at the end rather than stopping on the first error
- When deleting, always confirm with the user first
