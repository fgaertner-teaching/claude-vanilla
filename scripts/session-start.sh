#!/usr/bin/env bash
# SessionStart hook — runs git checks and outputs structured data for Claude to parse.
# Simplified version for the starter kit (no repo sync, no career check-in, no worktree detection).

set -u

# ============================================================
# Git check — skip everything if git is not installed
# ============================================================
if ! command -v git &>/dev/null; then
  echo "## Note"
  echo "Git is not installed. Skipping sync checks."
  echo "Use /startup to read your project's tracking files manually."
  exit 0
fi

# ============================================================
# Helpers
# ============================================================

safe_fetch() {
  if command -v timeout &>/dev/null; then
    timeout 5 git "$@" fetch --quiet 2>/dev/null
  else
    git "$@" fetch --quiet 2>/dev/null
  fi
}

# ============================================================
# Section 1: ~/.claude sync
# ============================================================
echo "## ~/.claude sync"
claude_dir="$HOME/.claude"

if [[ -d "$claude_dir/.git" ]]; then
  if safe_fetch -C "$claude_dir"; then
    local_head=$(git -C "$claude_dir" rev-parse HEAD 2>/dev/null)
    remote_head=$(git -C "$claude_dir" rev-parse origin/main 2>/dev/null)
    if [[ "$local_head" == "$remote_head" ]]; then
      echo "STATUS: UP_TO_DATE"
    else
      behind=$(git -C "$claude_dir" rev-list --count HEAD..origin/main 2>/dev/null || echo "?")
      echo "STATUS: BEHIND"
      echo "BEHIND_COUNT: $behind"
    fi
  else
    echo "STATUS: FETCH_FAILED"
  fi
else
  echo "STATUS: NOT_A_REPO"
fi
echo ""

# ============================================================
# Section 2: Project sync
# ============================================================
echo "## Project sync"

in_project_repo=false
if git rev-parse --is-inside-work-tree &>/dev/null; then
  in_project_repo=true
fi

if $in_project_repo; then
  if safe_fetch; then
    # Detect main branch
    main_branch="main"
    if ! git rev-parse --verify "origin/main" &>/dev/null; then
      if git rev-parse --verify "origin/master" &>/dev/null; then
        main_branch="master"
      fi
    fi
    echo "MAIN_BRANCH: $main_branch"

    current_branch=$(git branch --show-current 2>/dev/null || true)
    echo "CURRENT_BRANCH: ${current_branch:-DETACHED}"

    behind_main=$(git rev-list --count "HEAD..origin/$main_branch" 2>/dev/null || echo "0")
    if [[ "$behind_main" =~ ^[0-9]+$ ]] && [[ "$behind_main" -gt 0 ]]; then
      echo "MAIN_STATUS: BEHIND"
      echo "MAIN_BEHIND_COUNT: $behind_main"
    else
      echo "MAIN_STATUS: UP_TO_DATE"
    fi
  else
    echo "STATUS: FETCH_FAILED"
  fi
else
  echo "STATUS: NOT_A_REPO"
fi
echo ""

# ============================================================
# Section 3: Backup branches
# ============================================================
echo "## Backup branches"

if $in_project_repo; then
  backup_branches=$(git branch -r 2>/dev/null | grep "origin/backup/" | sed 's/^ *//' || true)
  if [[ -z "$backup_branches" ]]; then
    echo "STATUS: NONE"
  else
    while IFS= read -r branch; do
      branch_name="${branch#origin/}"
      if git merge-base --is-ancestor "$branch" HEAD 2>/dev/null; then
        echo "BRANCH: $branch_name STATUS: MERGED"
      else
        echo "BRANCH: $branch_name STATUS: UNMERGED"
      fi
    done <<< "$backup_branches"
  fi
else
  echo "STATUS: NOT_A_REPO"
fi
echo ""

# ============================================================
# Section 4: Files to read
# ============================================================
echo "## Files to read"

if $in_project_repo; then
  project_root=$(git rev-parse --show-toplevel 2>/dev/null || true)

  # Project OPEN_ISSUES
  if [[ -f "$project_root/claude/OPEN_ISSUES.md" ]]; then
    echo "READ: claude/OPEN_ISSUES.md"
  elif [[ -f "$project_root/OPEN_ISSUES.md" ]]; then
    echo "READ: OPEN_ISSUES.md"
  fi

  # Project next_steps
  if [[ -f "$project_root/claude/next_steps.md" ]]; then
    echo "READ: claude/next_steps.md"
  fi
fi
echo ""

# ============================================================
# Startup instructions
# ============================================================
echo "## Startup instructions"
cat << 'INSTRUCTIONS'
Parse the sections above and act as follows:

1. SYNC: If any STATUS is BEHIND, tell the user and ask whether to pull.
   If FETCH_FAILED, note network issue and proceed with local state.

2. BACKUP BRANCHES: Offer to delete MERGED branches. Flag UNMERGED
   branches as potentially containing unmerged work.

3. READ FILES: Use the Read tool for each file listed in "Files to read".
   Surface open issues and next steps to the user.

4. PROJECT IDENTITY: Verify CLAUDE.md has project-type and project-context.
   If missing, ask the user before proceeding.
INSTRUCTIONS
