#!/bin/sh
# SessionStart hook, the Mac twin of session-start.ps1: shows Claude where the project stands.
# Reads:  the hook's JSON on stdin (for the working directory), then the project's
#         claude/panic_dump.md and claude/next_steps.md. Not claude/OPEN_ISSUES.md: Claude
#         reads that when the user asks what is open (the project CLAUDE.md's pointer).
# Writes: plain text to stdout, which Claude Code adds to the session's context.
# macOS has no jq, so the folder is read from the JSON with sed.

# Find the project folder: the hook input names it; fall back to the current folder.
hook_input=$(cat | tr -d '\n')
project_dir=$(printf '%s' "$hook_input" | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
if [ -z "$project_dir" ] || [ ! -d "$project_dir" ]; then project_dir=$(pwd); fi
cd "$project_dir" || exit 0

# Show at most this many lines per file, and keep the whole output short: Claude Code passes a
# start hook's output whole only up to 10,000 characters. The files found share the budget.
max_lines=80
total_char_budget=8500

# Prints a file's first lines under a heading, within its share of the budget.
show_project_file() {  # $1 relative path, $2 heading, $3 character budget
    printf '=== %s (%s) ===\n' "$2" "$1"
    awk -v max_lines="$max_lines" -v budget="$3" '
        { total++ }
        !stopped && total <= max_lines && budget - (length($0) + 1) >= 0 {
            print; budget -= length($0) + 1; shown++; next
        }
        { stopped = 1 }
        END { if (shown < total) printf "[... %d more lines: read the file for the rest]\n", total - shown }
    ' "$1"
    printf '\n'
}

printf 'Session start: %s, folder: %s\n\n' "$(date '+%Y-%m-%d %H:%M (%A)')" "$project_dir"

# The files to show, in order: a panic dump first (the last session ended abruptly), then
# next_steps.md, or one per co-author (next_steps_<initials>.md, reference/collaboration.md).
set --
if [ -f claude/panic_dump.md ]; then
    set -- "$@" "claude/panic_dump.md|PANIC DUMP from an interrupted session - surface this to the user first"
fi
for next_steps_file in claude/next_steps*.md; do
    if [ -f "$next_steps_file" ]; then set -- "$@" "$next_steps_file|Where the project stands"; fi
done
if [ $# -gt 0 ]; then
    chars_per_file=$((total_char_budget / $#))
    for entry in "$@"; do show_project_file "${entry%%|*}" "${entry#*|}" "$chars_per_file"; done
fi
if ! ls claude/next_steps*.md >/dev/null 2>&1 && [ ! -f claude/OPEN_ISSUES.md ]; then
    printf 'No claude/next_steps.md or claude/OPEN_ISSUES.md in this folder. If this is a project, /newproject sets them up.\n\n'
fi

# Git: branch and uncommitted changes, from local state only (no network call).
if git_dir=$(git -C "$project_dir" rev-parse --show-toplevel 2>/dev/null); then
    branch_line=$(git -C "$project_dir" status --short --branch 2>/dev/null | head -n 1)
    changed=$(git -C "$project_dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    printf 'Git: %s; %s file(s) with uncommitted changes.\n' "$branch_line" "$changed"

    # A git repository inside a cloud-synced folder is a known source of corruption.
    case $(printf '%s' "$git_dir" | tr '[:upper:]' '[:lower:]') in
        *onedrive*|*dropbox*|*"google drive"*|*googledrive*|*nextcloud*|*icloud*|*/library/cloudstorage/*|*"mobile documents"*)
            printf 'WARNING: this git repository sits inside a cloud-synced folder (%s). Tell the user; see rules/rules.md.\n' "$git_dir" ;;
    esac
else
    printf 'Git: this folder is not a git repository.\n'
fi
