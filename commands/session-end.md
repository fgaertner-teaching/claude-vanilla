Run the session end protocol. Follow every step below — do not skip any.

## 1. Flush context to disk

Update the following files before any commit:

- **`claude/next_steps.md`** *(project-level)* — what was accomplished on the project, where we left off, priority order for next session

  **Verify carried-forward items.** Do not blindly copy priorities from the previous `next_steps.md`. Check each item against the work done in the current session. Remove items that are already resolved.

- **`claude/OPEN_ISSUES.md`** — any new issues, bugs, or to-dos discovered this session. Delete resolved items.
- **`claude/SUPERSEDED_IDEAS.md`** — any approaches considered and rejected
- **Relevant `SKILL.md` files** — any skill-relevant insights (methodology, packages, gotchas)

## 2. Commit and push (if using git)

If the project is a git repo:

1. Read `reference/checklist.md` and verify all applicable items before staging
2. Stage and commit changes in logical groups (not one giant commit)
3. Push if: ~5 commits have accumulated, or the session is ending

If the project is NOT a git repo, skip this step. The tracking files saved in step 1 are sufficient for session continuity.
