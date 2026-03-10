Run the session start protocol:

1. Check if the current working directory is a git repo. If yes, run `git fetch` and check for updates. If the remote has commits not in local HEAD, tell the user and offer to pull.

2. If `~/.claude/` is a git repo, check it too. If behind, tell the user and offer to pull.

3. Read the project-level `OPEN_ISSUES.md` (check `claude/OPEN_ISSUES.md` first, then project root). Briefly highlight any open items.

4. Read `claude/next_steps.md` — surface the immediate next task so the user knows where we left off.

5. Verify the project's `CLAUDE.md` has `project-type` and `project-context`. If either is missing, ask the user before proceeding.

If the project is not a git repo, skip steps 1–2 and go directly to reading the tracking files.
