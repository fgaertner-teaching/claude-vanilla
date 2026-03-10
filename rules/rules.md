# Rules

Consolidated conventions for session protocol, workflow, and technical standards.

## Session Start

If the SessionStart hook runs (requires git), parse its structured output for sync status. Otherwise, when the user types `/startup`, read the project's tracking files directly.

**If the hook runs:**

- `STATUS: UP_TO_DATE` → proceed.
- `STATUS: BEHIND` → tell the user and ask whether to pull.
- `STATUS: FETCH_FAILED` or `STATUS: NOT_A_REPO` → proceed with local state.
- Do NOT read context files until any pulls are complete.

**Always (with or without hook):**

1. Check if `claude/panic_dump.md` exists — if so, read it and surface it (previous session ended abruptly)
2. Read `claude/OPEN_ISSUES.md` and `claude/next_steps.md` — surface open issues and next steps
3. Verify the project's `CLAUDE.md` has `project-type` and `project-context`. If missing, ask.

## Session End

When the user signals session end, prompt them to run `/session-end`. The command handles:
1. Update `claude/next_steps.md` — what was accomplished, where we left off, priorities for next session
2. Update `claude/OPEN_ISSUES.md` — any new issues, delete resolved ones
3. If using git: commit and push

`next_steps.md` is a **current-state snapshot**, not a log. Overwrite it at every session end.

## Issue Tracking

- Maintain `claude/OPEN_ISSUES.md` per project — all open issues, bugs, design questions, and to-dos.
- `OPEN_ISSUES.md` is a current-state snapshot. Only genuinely open items live here. Resolved items are deleted.
- When presenting multiple issues, reorder by dependency (prerequisites first).
- When a change incidentally resolves an open issue, flag this to the user explicitly.

## Documentation

- When a decision requires weighing multiple factors, create a discussion file in `claude/` before resolving it.
- When a problem surfaces and gets resolved with a new convention, document it in a discussion file — what went wrong, what was decided, and why.

## Quality & Self-Correction

- Treat errors with rigor. When something goes wrong, investigate why before moving on.
- When the user fixes something, read their actual fix before updating instructions.
- After any correction from the user, identify the pattern and update the relevant file immediately — don't defer to session end.
- When the user starts a side-topic during a focused task, suggest deferring unless it's small or a prerequisite.

## Git & Commits

**Git is optional.** If the project is not a git repo, skip all git-related steps. If the user wants to start using git, offer to set it up.

When git is in use:

- **Main branch is always `main`, never `master`.** Initialize new repos with `git init -b main`.
- **Never commit without explicit user instruction.** After completing changes, summarise what would go into the commit and ask whether to proceed.
- Before committing, read `reference/checklist.md` and verify applicable obligations.
- Stage specific files — never `git add -A` blindly.
- Never commit data, outputs, tables, plots, or generated artifacts.
- Push when: ~5 commits accumulated, session ending, or user asks.

## New File Creation

- **Never create a new file without the user's greenlight.** Show the full draft content first, wait for approval, then write.
- Edits to existing files are fine — the user sees the diff.

## Technical Conventions

### Naming & Style

- Prefer `lower_snake_case` for all variable, function, and file names.

### Project Placement

**If using git:** project folders must live in a local (non-cloud-synced) folder. Cloud storage (Google Drive, OneDrive, Nextcloud) creates hidden files inside `.git/` and causes errors.

**If not using git:** projects can live anywhere, including cloud-synced folders.

### Machine-Specific Paths

Never hardcode machine-specific paths in code you intend to share. Two strategies:

1. **Auto-detect from the tool's own config** — e.g., Dropbox writes its path to a known JSON file; read it at runtime.
2. **`config_local.R`** — define machine-specific variables there; code sources it with `if (file.exists("config_local.R")) source("config_local.R")` and provides safe defaults. If using git, add `config_local.R` to `.gitignore`.

### Reproducibility

- For R projects, suggest loading `empirical-analysis/r.md`; for Python, suggest `empirical-analysis/python.md`.
- If using git: only commit code files. Ensure `.gitignore` covers everything that isn't code.
- If not using git: keep data and code in separate folders so the project can be version-controlled later.

### MCP Servers

Register at user level (`claude mcp add -s user`), not in a project `.mcp.json`.

### Project Notes

Keep cross-session working files in `claude/` inside the project. The auto-loaded `memory/MEMORY.md` should stay minimal.

### Context Management

- Single file at a known path → `Read` directly, never use a subagent.
- Long file, only part needed → Grep for structure first, then `Read` with offset + limit.
- 3+ files or cross-file synthesis → use a subagent (Explore agent).
- PDFs → always use the `pages` parameter (max 20 pages per call).
- Suggest `/compact` when the session has accumulated a lot of context.

### Data File Inspection

Never use subagents to inspect structured data files (CSV, JSON). Use Bash + Python's `csv` module or Rscript for accurate results.

## Written Summaries

When the user asks for a written summary, save it as a file in `claude/` — not just in the chat. Use `.tex` when it contains LaTeX, `.md` otherwise.
