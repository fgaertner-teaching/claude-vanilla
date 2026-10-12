#!/bin/sh
# Status line, the Mac twin of statusline.ps1: folder, git branch and session name on the first
# row; model and how full the context is on the second.
# Reads:  the status-line JSON Claude Code passes on stdin.
# Writes: two lines of text, shown under the input box, and the context figure to a small
#         file in the temp folder, claude-context-<session id>.txt, which
#         context-in-prompt.sh puts into each message (Claude cannot see the status line).
# macOS has no jq, so the fields are read from the JSON with sed. A key that occurs once is read
# by name; a key that also occurs elsewhere (used_percentage, level) is read inside its object.

status_json=$(cat | tr -d '\n')
json_text() { printf '%s' "$status_json" | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p"; }
# $1 object, $2 key: the value of a key inside the object's own fields. The JSON also carries
# used_percentage under rate_limits, after context_window, and a match over the whole JSON took
# that one. So: cut everything up to the object, drop objects nested inside it (two levels), and
# search only up to the object's closing brace. A layout this cannot read gives an empty value
# (shown as "--"), never another key's.
json_in_object() { printf '%s' "$status_json" | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*{//; s/{[^{}]*}//g; s/{[^{}]*}//g; s/^[^}]*\"$2\"[[:space:]]*:[[:space:]]*\"*\([^\",} ]*\).*/\1/p"; }

# First row: the folder's name, the git branch, the session name if the session has one.
folder=$(json_text current_dir)
if [ -z "$folder" ]; then folder=$(json_text cwd); fi
if [ -z "$folder" ]; then folder=$(pwd); fi
row1=$(basename "$folder")
# On a Mac without the command line tools, /usr/bin/git is a stub that may open an install
# dialog, so that one is not called (a git from elsewhere on PATH is used as usual).
git_path=$(command -v git 2>/dev/null)
if [ -n "$git_path" ] && { [ "$git_path" != /usr/bin/git ] || [ "$(uname)" != Darwin ] || xcode-select -p >/dev/null 2>&1; }; then
    branch=$(git -C "$folder" branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then row1="$row1 [$branch]"; fi
fi
session_name=$(json_text session_name)
if [ -n "$session_name" ]; then row1="$row1 - $session_name"; fi

# Second row: model, effort level if set, and the share of the context window in use.
row2=$(json_text display_name)
effort_level=$(json_in_object effort level)
if [ -n "$effort_level" ]; then row2="$row2 ($effort_level)"; fi
used=$(json_in_object context_window used_percentage)
case $used in
    ''|*[!0-9.]*) used='' ;;
esac
if [ -n "$used" ]; then
    # LC_ALL=C: under a German locale printf expects a decimal comma and rejects 12.6.
    used_rounded=$(LC_ALL=C printf '%.0f' "$used")
    row2="$row2 | context $used_rounded% used"
else
    used_rounded=''
    row2="$row2 | context --"
fi

# Hand the figure to the prompt hook. The session id names the file, so it is checked first:
# letters, digits and dashes only, so it can never point outside the temp folder. With no figure
# (early in a session, right after /compact) the file is emptied, so the prompt hook says the
# figure is unknown instead of repeating an old one.
session_id=$(json_text session_id)
case $session_id in
    ''|*[!A-Za-z0-9-]*) ;;
    *) printf '%s\n' "$used_rounded" > "${TMPDIR:-/tmp}/claude-context-$session_id.txt" ;;
esac

printf '%s\n%s\n' "$row1" "$row2"
