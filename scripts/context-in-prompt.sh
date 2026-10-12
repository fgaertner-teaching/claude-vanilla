#!/bin/sh
# UserPromptSubmit hook, the Mac twin of context-in-prompt.ps1: tells Claude how full the
# context is, with every message.
# Reads:  the hook's JSON on stdin (for the session id), then the figure statusline.sh wrote
#         for this session: claude-context-<session id>.txt in the temp folder.
# Writes: one line, "Context: N% used.", which Claude Code adds to the message. Nothing until
#         the status line has shown a figure in this session.

# The session id names the file, so it is checked first (letters, digits and dashes only).
session_id=$(cat | tr -d '\n' | sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
case $session_id in
    ''|*[!A-Za-z0-9-]*) exit 0 ;;
esac

# Read the figure; print it only if it is a plain whole number.
context_file="${TMPDIR:-/tmp}/claude-context-$session_id.txt"
if [ ! -f "$context_file" ]; then exit 0; fi
percent=$(head -n 1 "$context_file" | tr -d ' \r')
case $percent in
    ''|*[!0-9]*) exit 0 ;;
esac
printf 'Context: %s%% used.\n' "$percent"
