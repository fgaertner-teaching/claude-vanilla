#!/bin/bash
# PreToolUse hook: warns when Claude attempts git commit without explicit user instruction.
# Matcher: Bash
# Decision: "ask" — prompts the user rather than hard-blocking.
set -euo pipefail

input=$(cat)

# Extract the bash command from tool_input using Python (jq not available on all machines)
command=$(python -c "
import sys, json
d = json.loads(sys.stdin.read())
print(d.get('tool_input', {}).get('command', ''))
" <<< "$input")

# Check if command contains git commit (word boundary match)
if echo "$command" | grep -qiE '\bgit\b.*\bcommit\b'; then
  cat <<'HOOK_OUTPUT'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Claude is attempting git commit. Only approve if you explicitly asked for a commit."},"systemMessage":"HOOK: git commit detected. Per workflow rules, never commit without explicit user instruction. If the user asked for this commit, approve. Otherwise, deny and ask the user first."}
HOOK_OUTPUT
  exit 0
fi
