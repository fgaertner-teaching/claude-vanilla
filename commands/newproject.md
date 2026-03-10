Set up a new project or migrate a legacy project to current conventions.

Read `~/.claude/reference/new_project.md` and walk through it interactively. At each step, ask the user for decisions before proceeding.

## Mode detection

Check the current working directory:
- **Empty folder** → new project setup
- **Existing folder with files** → migration checklist

Ask the user to confirm the mode before proceeding.

## New project flow

Walk through each step in order. Key decision points where you must ask:

1. **Project identity** — ask for `project-type` and `project-context`
2. **Folder structure** — ask whether `programming/` is needed, then ask: **single-study or multi-study?**
   - **Single-study** (recommended for most projects): flat `analysis/` structure. `Claude_suggestions.R` in `analysis/` root.
   - **Multi-study:** ask how many studies and whether there's a pilot. Create `study_N/phase/` nesting.
3. **Git** — ask: "Do you want to use git for version control? (Recommended but not required.)" If yes, run `git init -b main` and set up `.gitignore`. If no, skip git setup — the project still works, just without version history.
4. **Analysis plan** — ask the user to describe the research question, hypotheses, and planned analyses. Draft `claude/analysis_plan.md` from their answers.
5. **Cloud storage and Overleaf** — ask whether there's an Overleaf document or shared data folder
6. **Co-authors** — ask whether the project will have co-authors (if yes, suggest setting up git)

When creating `analysis/Data_Analysis_Main_File_OPEN_ME_FIRST.R`, use `~/.claude/reference/template_main_file.R` as the starting point.

If using git: create all files first, then commit everything in a single initial commit.

## Migration flow

For existing projects, audit and fix:

1. **Structure** — are folders organized? Are tracking files in `claude/`?
2. **Tracking files** — does `CLAUDE.md` exist with project identity? Are `next_steps.md` and `OPEN_ISSUES.md` in place?
3. **Git** (if applicable) — is `.gitignore` correct? Are data files excluded?
