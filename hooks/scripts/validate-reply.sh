#!/bin/bash
# validate-reply.sh — PreToolUse hook for reply_to_conversation
# Validates reply content before sending to customer
# Exit 0 = allow, Exit 1 = block

# Read tool input from stdin
INPUT=$(cat)

# Extract message length using python3 (available on macOS/Linux)
MSG_LENGTH=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    msg = data.get('input', {}).get('message', '')
    print(len(msg))
except (json.JSONDecodeError, KeyError, TypeError):
    print(0)
" 2>/dev/null)

if [ -z "$MSG_LENGTH" ] || [ "$MSG_LENGTH" -eq 0 ]; then
    echo "BLOCKED: Reply message is empty. Please provide message content."
    exit 1
fi

if [ "$MSG_LENGTH" -lt 10 ]; then
    echo "BLOCKED: Reply is too short ($MSG_LENGTH chars). Minimum 10 characters for a meaningful response."
    exit 1
fi

if [ "$MSG_LENGTH" -gt 5000 ]; then
    echo "BLOCKED: Reply exceeds 5000 characters ($MSG_LENGTH chars). Please shorten the message."
    exit 1
fi

echo "Reply validated ($MSG_LENGTH characters)."
exit 0
