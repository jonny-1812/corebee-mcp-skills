#!/bin/bash
# log-agent-start.sh — SubagentStart hook
# Logs when a sub-agent is delegated to

INPUT=$(cat)
AGENT_NAME=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('agent_name', 'unknown'))
except (json.JSONDecodeError, KeyError, TypeError):
    print('unknown')
" 2>/dev/null)

printf 'Delegating to agent: %s\n' "$AGENT_NAME"
exit 0
