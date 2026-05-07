#!/bin/sh
# Auto-approve Write/Edit on .handoff/** state files.
# Reads PreToolUse hook input from stdin; emits hookSpecificOutput JSON if path matches.
# Silent (exit 0) for any other path — falls through to normal permission flow.

path=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)

case "$path" in
  .handoff/*|*/.handoff/*)
    printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"agent-handoff state file"}}'
    ;;
esac

exit 0
