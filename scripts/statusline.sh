#!/bin/sh
# Status line, the Mac twin of statusline.ps1: folder, git branch and session name on the first
# row; model and how full the context is on the second.
# Reads:  the status-line JSON Claude Code passes on stdin.
# Writes: two lines of text, shown under the input box, and the context figure to a small
#         file in the temp folder, claude-context-<session id>.txt, which
#         context-in-prompt.sh puts into each message (Claude cannot see the status line).
# macOS has no jq, so the fields are read from the JSON with sed (each key once, by name).

status_json=$(cat | tr -d '\n')
json_text() { printf '%s' "$status_json" | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p"; }
json_number() { printf '%s' "$status_json" | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\([0-9.]*\).*/\1/p"; }

# First row: the folder's name, the git branch, the session name if the session has one.
folder=$(json_text current_dir)
if [ -z "$folder" ]; then folder=$(json_text cwd); fi
if [ -z "$folder" ]; then folder=$(pwd); fi
row1=$(basename "$folder")
branch=$(git -C "$folder" branch --show-current 2>/dev/null)
if [ -n "$branch" ]; then row1="$row1 [$branch]"; fi
session_name=$(json_text session_name)
if [ -n "$session_name" ]; then row1="$row1 - $session_name"; fi

# Second row: model, effort level if set, and the share of the context window in use.
row2=$(json_text display_name)
effort_level=$(json_text level)
if [ -n "$effort_level" ]; then row2="$row2 ($effort_level)"; fi
used=$(json_number used_percentage)
if [ -n "$used" ]; then
    used_rounded=$(printf '%.0f' "$used")
    row2="$row2 | context $used_rounded% used"
else
    row2="$row2 | context --"
fi

# Hand the figure to the prompt hook. The session id names the file, so it is checked first:
# letters, digits and dashes only, so it can never point outside the temp folder.
session_id=$(json_text session_id)
case $session_id in
    ''|*[!A-Za-z0-9-]*) ;;
    *) if [ -n "$used" ]; then printf '%s\n' "$used_rounded" > "${TMPDIR:-/tmp}/claude-context-$session_id.txt"; fi ;;
esac

printf '%s\n%s\n' "$row1" "$row2"
