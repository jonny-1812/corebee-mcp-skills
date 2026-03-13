#!/bin/bash
# warn-destructive.sh — PreToolUse hook for destructive operations
# Displays a warning before delete/close operations
# Always exits 0 (informational only — user can deny via Claude Code's permission prompt)

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('tool_name', 'unknown'))
except (json.JSONDecodeError, KeyError, TypeError):
    print('unknown')
" 2>/dev/null)

case "$TOOL_NAME" in
    *delete_contact*)
        echo "WARNING: This will permanently delete a contact and all their notes." ;;
    *delete_knowledge_source*)
        echo "WARNING: This will remove a knowledge source and all indexed content." ;;
    *close_conversation*)
        echo "WARNING: This will close the conversation. Ensure the issue is resolved." ;;
    *)
        echo "WARNING: This operation will modify data." ;;
esac

exit 0
