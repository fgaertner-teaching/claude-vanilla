#!/bin/sh
# UserPromptSubmit hook, the Mac twin of context-in-prompt.ps1: tells Claude how full the
# context is, with every message.
# Reads:  the hook's JSON on stdin (for the session id), then the figure statusline.sh wrote
#         for this session: claude-context-<session id>.txt in the temp folder.
# Writes: one line, "Context: N% used.", which Claude Code adds to the message, or "Context:
#         unknown ..." when the status line has written no figure (normal before the first reply
#         and right after /compact; if it stays, the kit's status line is not running).

# The session id names the file, so it is checked first (letters, digits and dashes only).
session_id=$(cat | tr -d '\n' | sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
case $session_id in
    ''|*[!A-Za-z0-9-]*) exit 0 ;;
esac

# Read the figure; print it only if it is a plain whole number, and say so when there is none,
# so a missing figure cannot be mistaken for a hook that is not installed.
context_file="${TMPDIR:-/tmp}/claude-context-$session_id.txt"
percent=''
if [ -f "$context_file" ]; then percent=$(head -n 1 "$context_file" | tr -d ' \r'); fi
case $percent in
    ''|*[!0-9]*) printf "Context: unknown (no figure from the kit's status line yet).\n" ;;
    *) printf 'Context: %s%% used.\n' "$percent" ;;
esac
