---
name: signup
description: Create a brand-new Corebee account from your terminal — one email approval, then a scoped API key + a live chat-widget snippet. Use when you don't have a Corebee account yet.
allowed-tools: Bash
argument-hint: "your email, company name, and website URL"
---

# /corebee:signup — Agent-native Corebee signup (zero-UI)

Set up a brand-new Corebee account without leaving the terminal — no dashboard, no browser login. The only human step is approving one email.

Follow the **agent-signup** skill's process:

1. Ask the user for their **email**, **company name**, and **website URL** (full `https://…`).
2. `POST https://corebee.ai/api/auth/agent-signup` with `{email, company_name, website_url, attribution:{utm_source:"claude-code-plugin", utm_medium:"agent", utm_campaign:"plugin-signup"}}`.
3. Show the returned **pairing_phrase** and tell the user to approve the "Approve your Corebee terminal signup" email **only if** it shows that exact phrase. Keep `poll_token` secret.
4. Poll `poll_url` every `poll_interval_s`s until `status` is `approved` (or `existing_account`).
5. On `approved`: show the user the `embed_snippet` to paste before `</body>`, store the `api_key` (`ek_live_`, 24h) and use it as `Authorization: Bearer <api_key>` for the Corebee MCP tools + REST API, then follow `next_steps` (poll `get_knowledge_source` until the crawl completes; brand with `configure_widget_appearance`).
6. On `existing_account`: give the user the `dashboard_url` — they sign in and create a key from Settings → MCP.

Already have an account? Skip this and connect the Corebee MCP server normally (OAuth).
