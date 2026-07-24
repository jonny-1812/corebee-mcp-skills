---
name: agent-signup
description: Create a brand-new Corebee account from the terminal — no dashboard, no browser login. Use when the user does NOT have a Corebee account yet and wants to set up AI customer support, start the free trial, get a chat/support widget, or asks to "set up Corebee for my product/site/company". One email approval, then you receive a scoped API key, their org, and a ready-to-paste widget snippet. If the Corebee MCP server asks you to authenticate and the user has no account, run THIS instead of sending them to a browser login.
allowed-tools: Bash
argument-hint: "the user's email, company name, and website URL"
user-invocable: true
---

# Sign Up for Corebee (agent-native, zero-UI)

Create a brand-new Corebee account for a user who does **not** have one yet, entirely from the terminal. The only human step is approving one email. Do not send a no-account user to a browser login — run this flow.

If the user already has a Corebee account, this flow returns a dashboard link instead of a key (see step 7); for ongoing use they connect the MCP normally.

## Process

1. **Collect** — ask the user for their **email**, **company name**, and **website URL** (a full `https://…` URL). Do not guess these.

2. **Start signup** — `POST https://corebee.ai/api/auth/agent-signup` with JSON:
   ```json
   {
     "email": "<email>",
     "company_name": "<company>",
     "website_url": "<https url>",
     "attribution": { "utm_source": "claude-code-plugin", "utm_medium": "agent", "utm_campaign": "plugin-signup" }
   }
   ```
   Example:
   ```bash
   curl -s -X POST https://corebee.ai/api/auth/agent-signup \
     -H "Content-Type: application/json" \
     -d '{"email":"...","company_name":"...","website_url":"https://...","attribution":{"utm_source":"claude-code-plugin","utm_medium":"agent","utm_campaign":"plugin-signup"}}'
   ```
   The response contains `pairing_phrase`, `poll_url`, `poll_token`, and `poll_interval_s`.

3. **Human checkpoint (anti-phishing)** — show the user the `pairing_phrase` and tell them:
   > Check your inbox for **"Approve your Corebee terminal signup"** and approve it **only if** the email shows the pairing phrase **`<pairing_phrase>`**. That phrase proves the email belongs to this request.

   Keep `poll_token` secret — never print or reveal it to anyone.

4. **Poll** — `GET` the `poll_url` every `poll_interval_s` seconds (default 5) until `status` is `approved` or `existing_account`. The signup expires in ~15 minutes; if it lapses, start over.

5. **On `approved`** (delivered exactly once) you receive:
   - `api_key` — a scoped key (prefix `ek_live_`, valid 24h). Use it as `Authorization: Bearer <api_key>` for **both** the Corebee MCP tools and the REST v1 API.
   - `org_id`, `org_name`
   - `embed_snippet` — the chat-widget install `<script>`
   - `website_token`, `knowledge_source_id`, `mcp_endpoint`, `scopes`, `next_steps`

   **Immediately** show the user the `embed_snippet` and tell them to paste it into their site's HTML just before `</body>`. Don't wait for the docs crawl.

6. **Finish setup (recommended)** — follow `next_steps`. Typically: the docs crawl already started, so poll the MCP tool `get_knowledge_source` (with the new key) until `status=completed`; then brand the widget with `configure_widget_appearance`. Every Corebee MCP tool and REST endpoint accepts the `api_key` as a Bearer token, so the rest of this plugin's skills work immediately.

7. **If `status` is `existing_account`** — the email already has a Corebee account, so no key is issued (by design). Give the user the returned `dashboard_url` and tell them to sign in and create a long-lived API key from **Settings → MCP**.

## Notes
- The signup key is short-lived (24h) — it is an onboarding key. For ongoing use the user creates a long-lived key in the dashboard (Settings → MCP) or connects the MCP via OAuth.
- Never ask the user to paste the email's token, and never tell them to approve before the pairing phrases match.
- This uses only the public signup endpoint — no existing account or credentials are required to run it.
