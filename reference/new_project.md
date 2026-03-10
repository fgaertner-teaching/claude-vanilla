# New Project Setup Protocol

**Load when:** initialising a new project from scratch, or migrating a legacy project.
**Skip when:** working on an existing, already-conformant project.

Steps to follow when initialising a new research project repo.

---

## 1. Declare project identity

Every project `CLAUDE.md` must declare:
- `project-type`: `academic-research`, `software`, `exploration`, etc.
- `project-context`: `work` or `leisure`

Place `CLAUDE.md` at the **repo root** (required — Claude Code reads it from there).

---

## 2. Create the standard folder structure

**All folder names use `lower_snake_case`** — e.g. `analysis/`, `study_1/`, never `Analysis/` or `Study1/`.

For `academic-research` projects, the standard subfolders are:

```
analysis/       R or Python analysis pipeline (scripts, data, outputs)
literature/     Paper summaries in markdown; raw PDFs excluded from git
claude/         All Claude-related files (notes, tracking, staging)
programming/    Standalone scripts, tools, experiments (optional — see below)
```

**`programming/` is optional.** Ask the user at setup time whether the project
involves standalone code beyond the analysis pipeline (e.g., experiment scripts,
custom packages, data collection tools). Create it only if confirmed.

### Inside `analysis/` (for R projects)

Ask at setup time: **single-study or multi-study?** This determines the folder layout.

#### Single-study layout

For projects with one study (no cross-study comparisons needed). Flat structure — no `study_N/` nesting, no `cross_study/`, no `run_*.R` entry points. The main file sources `4_scripts/` directly.

```
analysis/
  0_shared/
    0_Setup.R                  (global config, libraries, sync helpers, shared functions)
  1_raw_data/
  2_interim_data_steps/
  3_clean_data/
  4_scripts/
    1_0_Load_Data_Setup.R
    1_1_Load_Data.R
    2_0_Clean_Data_Setup.R
    2_1_Clean_Data.R
    2_2_Clean_Data_Save_Objects.R
    2_3_EDA_Plots.R
    3_0_Results_Setup.R
    3_1_Results_Descriptives.R
    3_2_Results_Main_Analysis.R
    3_3_Results_Robustness.R
    3_4_Results_Additional_Analysis.R
    3_5_Results_Save_Objects.R
    4_0_Tables_Setup.R          (stars, gof_map)
    4_1_Tables_Descriptives.R
    4_2_Tables_Main_Analysis.R
    4_3_Tables_Robustness.R
    4_4_Tables_Additional_Analysis.R
    4_5_Tables_Save_Objects.R   (mget pattern + sync_to_dropbox)
    5_0_Plots_Setup.R           (theme, dimensions, save_plot helper)
    5_1_Plots_Descriptives.R
    5_2_Plots_Main_Analysis.R
    5_3_Plots_Robustness.R
    5_4_Plots_Additional_Analysis.R
    5_5_Plots_Export.R          (mget pattern + ggsave loop + sync)
    5_6_Plots_Save_Objects.R
  5_tables/
    appendix/
  6_plots/
    appendix/
  7_r_objects/
  Claude_suggestions.R         (active staging area for current step)
  Claude_backlog.R             (approved suggestions waiting on a dependency)
  Data_Analysis_Main_File_OPEN_ME_FIRST.R
  renv/
  renv.lock
  .Rprofile                    (renv activation — commit this)
  .here                        (anchors here::here() — commit this)
```

Key differences from multi-study:
- No `study_N/` subfolder layer — data, scripts, and outputs live directly under `analysis/`
- No `cross_study/` folder
- No `run_*.R` entry points — main file sources `4_scripts/` directly
- No experiment-level setup script — `0_shared/0_Setup.R` holds all shared functions
- `Claude_suggestions.R` and `Claude_backlog.R` live in `analysis/` root

#### Multi-study layout

For projects with multiple studies, or a single study with distinct phases (e.g. pilot + main).

```
analysis/
  0_shared/
    0_Setup.R                  (global config, libraries, sync helpers)
  cross_study/                 (cross-study comparisons)
    cross_study_setup.R
    Claude_suggestions.R
    4_scripts/
    5_tables/
    6_plots/
  study_1/
    0_Setup_Study1.R           (study-level constants and helpers)
    Claude_suggestions.R       (active staging area for current step)
    Claude_backlog.R           (approved suggestions waiting on a dependency)
    pilot/                     (omit if no pilot)
      1_raw_data/
      2_interim_data_steps/
      3_clean_data/
      4_scripts/
        1_0_Load_Data_Setup.R
        1_1_Load_Data.R
        2_0_Clean_Data_Setup.R
        2_1_Clean_Data.R
        2_2_Clean_Data_Save_Objects.R
        2_3_EDA_Plots.R
        3_0_Results_Setup.R
        3_1_Results_Descriptives.R
        3_2_Results_Main_Analysis.R
        3_3_Results_Robustness.R
        3_4_Results_Additional_Analysis.R
        3_5_Results_Save_Objects.R
        4_0_Tables_Setup.R          (stars, gof_map)
        4_1_Tables_Descriptives.R
        4_2_Tables_Main_Analysis.R
        4_3_Tables_Robustness.R
        4_4_Tables_Additional_Analysis.R
        4_5_Tables_Save_Objects.R   (mget pattern + sync_to_dropbox)
        5_0_Plots_Setup.R           (theme, dimensions, save_plot helper)
        5_1_Plots_Descriptives.R
        5_2_Plots_Main_Analysis.R
        5_3_Plots_Robustness.R
        5_4_Plots_Additional_Analysis.R
        5_5_Plots_Export.R          (mget pattern + ggsave loop + sync)
        5_6_Plots_Save_Objects.R
      5_tables/
      6_plots/
      7_r_objects/
      run_pilot.R
    main/
      (same structure + run_main.R)
  study_2/                     (add when needed)
    ...
  Data_Analysis_Main_File_OPEN_ME_FIRST.R
  renv/
  renv.lock
  .Rprofile                    (renv activation — commit this)
  .here                        (anchors here::here() — commit this)
```

See `reference/academic_conventions.md` Step 2 for full conventions on both layouts.

### Inside `claude/`

```
claude/
  analysis_plan.md     research questions, hypotheses, planned analyses, expected outputs
  output_spec.md       every table/figure: content, format, file name (stub at setup; fill as pipeline develops)
  pipeline_map.md      one-table orientation to every script (stub at setup; fill as scripts are created)
  next_steps.md        current session handoff and immediate priorities
  OPEN_ISSUES.md       open issues and to-dos
  SUPERSEDED_IDEAS.md  rejected ideas and decisions
  lessons.md           recurring corrections — mistakes + rules (empty stub at setup)
  <discussion/methodology files go here directly, with descriptive names>
```

For `academic-research` projects, also create:
- **`claude/analysis_plan_deviations.md`** — tracks departures from the original plan with reasoning. Empty at setup; append entries whenever the analysis diverges from `analysis_plan.md`.

For analysis projects, two staging files exist (not in `claude/`):
- **`Claude_suggestions.R`** — active staging area for the current step only. One suggestion at a time; keep this file short and focused.
- **`Claude_backlog.R`** — parked suggestions: staged and reviewed, but waiting on a dependency or a later pipeline stage. Move blocks here when they are approved-in-principle but not the current focus. Move back to `Claude_suggestions.R` when they become active again.

Placement: single-study → `analysis/` root. Multi-study → one per experiment folder (e.g. `study_1/`) plus one in `cross_study/`.

No `claude_notes/` subfolder — all files live flat in `claude/`. The three tracking files are distinctive by name; additional notes go there too with descriptive filenames (e.g. `methodology_notes.md`, `compact_log.md`).

---

## 3. Set up .gitignore

See `.gitignore` policy in `reference/gitignore_policy.md`.
Start from the template there; adjust for project specifics.

Verify that the template includes `config_local.R`, `.worktrees/`, and `CLAUDE.local.md` — all three are in the current template but easy to miss if copying from an older project.

---

## 4. Initialise git and GitHub

**Skip this step if the user chose not to use git.** The project will still work — tracking files in `claude/` provide session continuity without version control.

**Repo placement:** create the repo in a local (non-cloud-synced) folder — e.g. `~/Documents/Research/`. Never in Google Drive, Nextcloud, or OneDrive — cloud services contaminate `.git/` and break git operations. See `rules/rules.md` § Repo Placement.

```bash
git init -b main
git config core.longPaths true
```

The `core.longPaths` setting prevents Windows path-length errors when worktrees add an extra path segment.

Create a **private** GitHub repo (no README/license/gitignore — keep empty):
```bash
# If gh CLI available:
gh repo create <repo-name> --private
# Otherwise: create on GitHub.com, then:
git remote add origin git@github.com:<user>/<repo-name>.git  # requires SSH keys
```

Create the project pre-commit hook (non-blocking — warnings only):

```bash
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook: warn about common mistakes in research projects.
# Non-blocking (exit 0) — warnings only. Primary check is always Claude's judgment;
# this hook is a dumb backstop that fires inside the tool call Claude is already making.

STAGED=$(git diff --cached --name-only 2>/dev/null)
STAGED_AD=$(git diff --cached --name-only --diff-filter=AD 2>/dev/null)

# 1. Warn if data or output files are staged
DATA_FILES=$(echo "$STAGED" | grep -iE '\.(csv|dta|rds|RData|xlsx|xls|sav|feather|parquet|zip|gz)$' || true)
OUTPUT_FILES=$(echo "$STAGED" | grep -iE '\.(png|pdf|eps|svg|jpg|jpeg)$' || true)

if [ -n "$DATA_FILES" ] || [ -n "$OUTPUT_FILES" ]; then
    echo ""
    echo "⚠️  Possible data or output files staged:"
    [ -n "$DATA_FILES" ] && echo "$DATA_FILES" | sed 's/^/   /'
    [ -n "$OUTPUT_FILES" ] && echo "$OUTPUT_FILES" | sed 's/^/   /'
    echo "   Data and outputs should not be committed. Check .gitignore."
    echo ""
fi

# 2. Warn if R scripts added or deleted without updating pipeline_map.md
R_STRUCTURAL=$(echo "$STAGED_AD" | grep '\.R$' || true)

if [ -n "$R_STRUCTURAL" ] && ! echo "$STAGED" | grep -q 'pipeline_map\.md'; then
    echo ""
    echo "⚠️  R scripts added or deleted but claude/pipeline_map.md not updated:"
    echo "$R_STRUCTURAL" | sed 's/^/   /'
    echo "   Update claude/pipeline_map.md to reflect the change."
    echo ""
fi

exit 0
EOF
chmod +x .git/hooks/pre-commit
```

Do not commit yet — the entire setup lands in one commit at Step 9.

---

## 5. Create initial tracking files

**Project planning files (fill these first — they guide everything else):**
- `claude/analysis_plan.md` — research questions, hypotheses, planned analyses, expected outputs. Even a rough draft forces clarity about what the project is trying to do. Refine before data collection; update as the project evolves.
- `claude/output_spec.md` — stub at setup. Once the pipeline takes shape, specify every table and figure: content, formatting conventions, file naming. Fill as the pipeline develops.
- `claude/analysis_plan_deviations.md` — *(academic-research only)* empty at setup. Append entries whenever the analysis diverges from the plan, with reasoning.

**Pipeline and tracking files:**
- `CLAUDE.md` — project identity, description, key conventions
- `claude/OPEN_ISSUES.md` — start empty or with known issues
- `claude/SUPERSEDED_IDEAS.md` — start empty
- `claude/next_steps_[initials].md` — named after the project creator's initials (e.g. `next_steps_jd.md`); first entry: "Project initialised."
- `claude/lessons.md` — empty stub (header only: `# Lessons`)
- `claude/pipeline_map.md` — stub with column headers only (fill in as scripts are created)
- `claude/memory.md` — stub for shared analytical memory (key data facts, methodology decisions, findings); header only at setup, filled in as the project develops
- `.claude/settings.json` — project-level permissions; create with `Read(./**)` and `Glob(./**)` so Claude can read project files without per-session prompts, while files outside the project still require explicit approval (privacy boundary)
- `claude/about-team.md` — copy from `~/.claude/about-me.md` as the initial content; co-authors add their own sections during onboarding (Step 8)
- `analysis/Data_Analysis_Main_File_OPEN_ME_FIRST.R` — use `~/.claude/reference/template_main_file.R` as starting point; fill in project name and pipeline section (single-study: direct source() calls; multi-study: run_*.R entry points)

**Also create on your machine (not committed — do not include in the Step 9 init commit):**
- `CLAUDE.local.md` at the project root — tells Claude what works and what doesn't on this machine (Dropbox installed?, `config_local.R` created?, any local quirks). Auto-loaded by Claude Code and auto-added to `.gitignore`. Each person creates their own on each machine they work on. Template in `COAUTHOR_GUIDE.md`.

---

## 6. Notes

- For R projects: suggest loading `skills/empirical-analysis/r.md` for renv setup. **Before `renv::init()`**, run `update.packages(ask = FALSE)` so the lock file captures current package versions rather than whatever was last updated on this machine.
- For Python projects: suggest loading `skills/empirical-analysis/python.md`
- `programming/` may have its own package management — document in its own section of `CLAUDE.md`

---

## 7. Set up cloud storage and Overleaf sync

For projects with co-authors or shared data, set up the **three-location model** (see `reference/collaboration.md` § Three-Location Model): local folder for git-tracked code, Google Drive for shared data/materials, Dropbox for Overleaf sync only. Even solo projects benefit from keeping data on Google Drive and code local.

Ask at setup: *does this project have an Overleaf document?* If yes:

1. **Activate Dropbox sync** in Overleaf (project settings → Dropbox). Note the exact folder name Overleaf assigns under `Apps/Overleaf/` — it may differ from the project title.
2. **In `0_Setup.R`**, add:
   - `overleaf_project_name <- "<name from step 1>"`
   - The auto-detection block from `rules/rules.md` (§ Machine-Specific Paths) — reads Dropbox root from `info.json`, constructs `dropbox_tables` and `dropbox_plots` paths
   - The `sync_to_dropbox()` helper function
3. **In the pipeline's tables and plots save scripts** (e.g., `4_6_Tables_Save_Objects.R`, `5_6_Plots_Export.R`), add `sync_to_dropbox()` calls at the end.
4. **Add `config_local.R` to `.gitignore`** as a standard entry, in case machine-specific overrides are ever needed later.
5. **Create the standard Overleaf folder structure** — see `reference/overleaf_conventions.md` for the full layout. Key root files to create: `main.tex`, `online_appendix.tex`, `elevator_pitch.tex`, `ideas_and_sketches.tex`, `table_sandbox.tex`, `todo.tex`, `readme.tex`, `library.bib`. Key folders depend on layout:
   - **Single-study:** `tables/appendix/`, `plots/appendix/`, `archive/`, `grants/`, `materials/`, `presentations/`, `sections/`, `style/`, `submission/`.
   - **Multi-study:** `study_1/pilot/tables/appendix/`, `study_1/pilot/plots/appendix/`, `study_1/main/tables/...`, etc., plus `archive/`, `grants/`, `materials/`, `presentations/`, `sections/`, `style/`, `submission/`.
6. **Path convention:** all `\input{}` and `\includegraphics{}` paths in `.tex` files must use the full path from the Overleaf root (see `reference/overleaf_conventions.md` § Path Convention).

The sync degrades silently to a no-op when Dropbox is not installed, so replication packages require no changes.

---

## 8. Set up co-author collaboration (if applicable)

Ask at setup: *will this project have co-authors working in the same codebase?* If yes:

1. **Add collaborator on GitHub** — repo Settings → Collaborators → invite by username.
2. **Agree on branch strategy** and document in project `CLAUDE.md`:
   - All contributors work on named branches; `main` is merged into via PRs only — no direct pushes.
   - Branch naming convention (e.g., `{topic}` or `{initials}/{topic}`).
3. **Overleaf sync** — one author owns the Overleaf ↔ Dropbox connection. They share the Dropbox subfolder (`Apps/Overleaf/<project>/`) with co-authors so all can push tables/plots via `sync_to_dropbox()`. Each author configures their local Dropbox path via `config_local.R`. Document who owns the connection in `CLAUDE.md`.
4. **`config_local.R` discipline** — confirm it is in `.gitignore` (Step 3 should have done this); each author creates their own locally.
4a. **`CLAUDE.local.md`** — each co-author creates their own at the project root on each machine they work on. Auto-gitignored. Records local capability state for Claude (Dropbox installed?, config_local.R created?, any quirks). Template in `COAUTHOR_GUIDE.md`.
5. **Brief the co-author on renv discipline:**
   - Run `renv::restore()` before every session.
   - Run `renv::snapshot()` + commit `renv.lock` after installing any package.
6. **Note `Claude_suggestions.R`** in project `CLAUDE.md` — co-authors should not edit it.
7. **Create `COAUTHOR_GUIDE.md`** at the project root — a brief plain-language summary covering Git workflow, renv discipline, Overleaf sync setup, a `config_local.R` template, and a note about `Claude_suggestions.R`. See `reference/collaboration.md` § COAUTHOR_GUIDE.md for required sections.
8. **Add convention enforcement rules** to the project `CLAUDE.md` co-author section — so Claude enforces renv, Git, and staging discipline for co-authors too. See `reference/collaboration.md` § Convention Enforcement for the required block.
9. **Copy relevant global conventions into project `CLAUDE.md`** — go through `~/.claude/reference/` and `~/.claude/skills/` and identify which conventions should govern all contributors' Claude sessions. Copy the Claude-instruction parts inline into the project `CLAUDE.md`. This is a one-time judgment call made explicit at onboarding. Key candidates for academic-research projects with Overleaf: results narrative convention (tone, audience, proactive creation rule), plotting conventions, table conventions, any project-specific methodology notes.

10. **Cross-check `COAUTHOR_GUIDE.md`** — walk through Steps 1–7 of this protocol and verify that every decision a co-author needs to reproduce your setup is documented in the guide. Key things that often fall through: local folder path, SSH/HTTPS setup, `pipeline_map.md`, any project-specific naming or folder conventions. Add missing sections before the co-author starts.

See `reference/collaboration.md` for full day-to-day conventions.

---

## 9. Initial commit and push

**If not using git:** your setup is complete after the previous steps. No commit needed — just start working.

**If using git:** the entire setup — all steps above — lands in a **single** initial commit. Do not commit during intermediate steps.

```bash
git add -A
git commit -m "Initial project structure"
git push -u origin main
```

The push also confirms that SSH or HTTPS authentication works before the co-author tries to clone.

**After pushing, verify the remote works by running `git ls-remote origin`.**

---

## 10. Migrate a legacy project

For projects that predate this protocol. Walk through this checklist to bring them up to standard — do not restart from scratch unless the codebase is unsalvageable.

### Structure

- [ ] Git repo is at the **project root**, not inside a subfolder (e.g. not inside `Analysis/`)
- [ ] All folder names use `lower_snake_case` (`analysis/` not `Analysis/`)
- [ ] Standard top-level folders exist: `analysis/`, `claude/`, `literature/`, optionally `programming/`
- [ ] No `claude_notes/` subfolder — move contents to `claude/` (flat)
- [ ] Loose discussion/methodology files at the analysis root → move to `claude/`
- [ ] No `outdated/` or `solved_claude_suggestions.R` — migrate content to `claude/SUPERSEDED_IDEAS.md`
- [ ] Study subfolders use `study_1/`, `study_2/` naming (not `experiment1/`)

### .gitignore

- [ ] Replace with current template from `reference/gitignore_policy.md`
- [ ] Includes `.worktrees/`, `CLAUDE.local.md`, `.claude/`, `config_local.R`
- [ ] Does NOT ignore `renv/activate.R`, `renv/settings.json`, `.Rprofile` (these must be committed)
- [ ] `desktop.ini` is ignored (prevents cloud contamination)
- [ ] Run `find . -name "desktop.ini"` and delete any existing ones, especially inside `.git/`

### Tracking files

- [ ] `CLAUDE.md` at repo root with `project-type` and `project-context`
- [ ] `claude/analysis_plan.md` — extract from existing plan documents or create fresh
- [ ] `claude/output_spec.md` — extract from existing output specs or create stub
- [ ] `claude/analysis_plan_deviations.md` — *(academic-research)* create if plan exists
- [ ] `claude/pipeline_map.md` — create from existing script structure
- [ ] `claude/OPEN_ISSUES.md`, `claude/SUPERSEDED_IDEAS.md`, `claude/lessons.md`
- [ ] `claude/next_steps_[initials].md`
- [ ] `claude/about-team.md`
- [ ] `claude/memory.md`
- [ ] `.claude/settings.json` with `Read(./**)` and `Glob(./**)`

### Git health

- [ ] No `desktop.ini` files inside `.git/` (run `find .git -name "desktop.ini" -delete`)
- [ ] `git fsck` passes without errors
- [ ] `git config core.longPaths true` is set
- [ ] Pre-commit hook installed (see Step 4)
