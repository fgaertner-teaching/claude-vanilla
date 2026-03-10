#!/bin/bash
# PreToolUse hook: warns when Claude edits a pipeline .R file directly instead of
# staging in Claude_suggestions.R.
# Matcher: Edit|Write
# Decision: "ask" — prompts the user rather than hard-blocking.
# Only fires for .R files inside an analysis/ directory tree.
set -euo pipefail

input=$(cat)

# Extract file_path from tool_input using Python (jq not available on all machines)
file_path=$(python -c "
import sys, json
d = json.loads(sys.stdin.read())
ti = d.get('tool_input', {})
print(ti.get('file_path', '') or ti.get('file', ''))
" <<< "$input")

# Normalize path separators (Windows backslashes → forward slashes)
file_path="${file_path//\\//}"

# Only check .R files
if [[ ! "$file_path" =~ \.R$ ]]; then
  exit 0
fi

# Only check files inside an analysis/ directory
if [[ ! "$file_path" =~ /analysis/ ]]; then
  exit 0
fi

# Allow staging and config files
basename=$(basename "$file_path")
case "$basename" in
  Claude_suggestions.R|Claude_backlog.R|config_local.R)
    exit 0
    ;;
esac

# Any other .R file in analysis/ → warn
cat <<'HOOK_OUTPUT'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Claude is editing a pipeline script directly. Only approve if you explicitly asked to push staged code to this file."},"systemMessage":"HOOK: Editing a pipeline script directly. Per project convention, code changes must go into Claude_suggestions.R first, then get pushed to the target script after user approval. If the user explicitly approved this edit, proceed. Otherwise, deny and stage in Claude_suggestions.R instead."}
HOOK_OUTPUT
exit 0
