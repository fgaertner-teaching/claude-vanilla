# New Project Setup

**Load when:** setting up a new research project, or bringing an existing one up to these
conventions. `/newproject` walks through this file.
**Skip when:** the project already has its `CLAUDE.md`, `claude/` files, `.gitignore` and
raw-data lock.

**Done looks like:** the project folder sits outside any cloud-synced folder; it has a
`CLAUDE.md`, `claude/next_steps.md`, `claude/OPEN_ISSUES.md`, the folder structure, a
`.gitignore`, a `.claude/settings.json` that locks the raw data, a package environment, and a git
repository on `main` whose first commit contains no data.

**Order:** the steps below, in sequence. The `.gitignore` must exist before the first `git add`,
or data enters the history, which is hard to clean.

---

## 1. Where the folder lives: check this first

**A git repository must not sit inside OneDrive, Dropbox, Google Drive, Nextcloud or iCloud.**
*Why:* the sync client and git write the same files at the same time; the result is a corrupted
repository or conflict copies inside `.git/`.

Check the project folder's absolute path (`Get-Location` in PowerShell, `pwd` elsewhere):

- **Windows:** synced if the path contains `OneDrive`, `Dropbox`, `Google Drive`, `My Drive` /
  `Meine Ablage` (Google Drive often has its own drive letter, e.g. `G:`), `Nextcloud` or
  `iCloud`, or lies under `$env:OneDrive` / `$env:OneDriveCommercial`. `Documents` and `Desktop`
  are often moved into OneDrive.
- **Mac:** synced if under `~/Library/CloudStorage/` or `~/Library/Mobile Documents/`.
  `~/Documents` and `~/Desktop` sync to iCloud when "Desktop & Documents Folders" is on, though
  the path looks normal: ask the user.

If it is synced: stop and say so. Propose `C:\Users\<name>\repos\<project>` (Mac:
`~/repos/<project>`). Shared data may stay in the cloud; the code moves out. Moving an
existing folder is the user's decision.

## 2. The project `CLAUDE.md`

Claude reads it in every session of this project, so it holds what Claude must know and nothing
more; details go in files it points to.

```markdown
# <Project name>

**project-type:** academic-research

## What this project is
<2-3 sentences: research question, data, method, target journal.>

## Where things are
- Pipeline: `analysis/`; run everything with `analysis/Data_Analysis_Main_File_OPEN_ME_FIRST.R`
- Raw data: `analysis/1_raw_data/`, read-only (locked in `.claude/settings.json`).
  The untouched original lives at: <provider, shared drive, ...>
- Paper: <where it lives: a LaTeX folder here, an Overleaf project, a Word file; or "none yet">

## What to read, and when
- Where we stand: `claude/next_steps.md` (the start hook shows it).
- What is open: `claude/OPEN_ISSUES.md`. Read it when I ask what is open, or before work on an
  item in it.
- What happened, and when: `claude/session_log.md`. Read it only when I ask.
- What can wait: `claude/long_term_open_issues.md`. Read it only when I ask.
- Why we decided something: `claude/decision_<topic>.md`. Read one when its topic comes up.

## Conventions for this project
- <R or Python; packages via renv / uv>
- <what Claude must always respect, e.g. "SEs clustered by firm", "the paper is in German">
```

`project-type` is an open list (`academic-research`, `software`, `teaching`, `exploration`, or a
new value). `academic-research` means the analysis pipeline below and the `empirical-analysis`
skill.

## 3. Folder structure

```
<project>/
  CLAUDE.md, .gitignore, .claude/settings.json
  analysis/      the analysis pipeline (below)
  claude/        Claude's working files: handover, open issues, decisions, plans
  literature/    notes on papers as .md; PDFs stay out of git          (optional)
  programming/   code that GENERATES data: experiments, simulations   (only if needed)
```

Single study (the default):

```
analysis/
  0_shared/0_Setup.R           libraries, paths, shared helper functions
  1_raw_data/                  the data as received
  2_interim_data_steps/
  3_clean_data/
  4_scripts/                   1_1_Load_Data.R, 2_1_Clean_Data.R, 3_2_Results_Main_Analysis.R ...
  5_tables/appendix/
  6_plots/appendix/
  7_r_objects/                 Python: 7_objects/
  Data_Analysis_Main_File_OPEN_ME_FIRST.R   from reference/template_main_file.R (Python: .py)
  .here                        empty file; makes here::here() point at analysis/ (commit it)
```

- Folder names are `lower_snake_case`: nothing to quote or mistype in code.
- `programming/` holds the code that generates data, one subfolder per experiment or simulation;
  what it produces enters the pipeline as raw data in `analysis/1_raw_data/`. The two sides do not
  import each other's code, so collecting and analysing stay separate steps.
- An empty `.gitkeep` file goes in every data and output folder (`1_` to `3_`, `5_` to `7_`, and
  the `appendix/` subfolders). *Why:* git does not store empty folders, so a fresh clone would
  lack them and the first script that writes there would fail.
- Several studies, or a pilot plus a main wave: one pipeline per study and phase
  (`analysis/study_1/pilot/`, `analysis/study_1/main/`) with `run_*.R` entry points, plus
  `analysis/cross_study/`. Start single-study unless a second study is already planned.
- What each folder means and where a new script goes: the `project-organizer` skill.

## 4. Claude's tracking files in `claude/`

- **`claude/next_steps.md`** is the handover: a snapshot, overwritten at every session end by
  `/session-end`, never a diary. Three short parts: where we stand, what the last session did,
  what comes next. First version: "Project set up, no data yet. Next: copy the raw data into
  `analysis/1_raw_data/` (keep the original where it was); draft `claude/analysis_plan.md`."
- **`claude/OPEN_ISSUES.md`** holds only what is open, one `## <short title>` per item with what
  would close it. A resolved item is deleted, not ticked off, so the file stays short enough to
  read whenever the user asks what is open. At setup it holds a heading and nothing else, or the
  first known gaps.
- **`claude/session_log.md`**, the diary: one dated entry per session, added by `/session-end`,
  never rewritten. At setup: a heading and the first entry ("Project set up").
- **`claude/long_term_open_issues.md`** holds what can wait; created when the first such item
  comes up, not at setup.
- **Decisions** get their own `claude/decision_<topic>.md` (question, options, choice, why),
  written when a decision is made, not at setup.
- **For `academic-research`:** `claude/analysis_plan.md` (question, hypotheses, planned models;
  the `analysis-plan` skill helps), and header-only stubs of `claude/pipeline_map.md` and
  `claude/output_spec.md`, filled as scripts and outputs appear (`project-organizer` skill).

## 5. `.gitignore`

Copy the template from `reference/gitignore_policy.md` and adapt it. It leaves out everything,
then lets in the kinds of file the project writes by hand (code, text, LaTeX, the environment's
recipe files); data, generated outputs, secrets and local settings stay out.

## 6. Lock the raw data

Create `.claude/settings.json` in the project:

```json
{
  "permissions": {
    "deny": ["Edit(./analysis/1_raw_data/**)"]
  }
}
```

- **What it does:** Claude Code refuses to create or change any file in that folder with its file
  tools (an `Edit(...)` rule covers all of them), and with shell commands that name the file
  (`> file`, `tee`, `sed`). *Why:* "raw data is never changed" is then enforced by the tool, not
  left to Claude's memory.
- **Paths starting with `./`** are read from the folder Claude Code was started in: start it in
  the project root. Several studies: one line per raw folder
  (`"Edit(./analysis/study_1/pilot/1_raw_data/**)"`, ...).
- **What it does not do:** it cannot see an R or Python script that opens and writes a file
  itself, so scripts only ever read from `1_raw_data/`. A second layer the user can add: mark the
  raw files read-only (Windows: Properties, "Read-only"; Mac: Get Info, "Locked").
  (Last verified: 2026-10-07, Claude Code docs, "Configure permissions".)
- **Test it once:** ask Claude to create `analysis/1_raw_data/lock_test.txt`; it must be refused.
  If not: check the path, restart Claude Code in the project root, test again, and tell the user
  a test file was created (removing it is their call).
- The `.gitignore` template keeps `.claude/settings.json` in git, so the lock travels with the
  repository. If Claude may not write permission rules in the current mode, give the user the
  content to paste.

## 7. Git

```
git init -b main
git config core.longPaths true     # Windows only: allows file paths over 260 characters
```

A **private** GitHub repository is optional and recommended as an off-laptop copy; private,
because it holds unpublished work (it can go public at publication). With the GitHub CLI:
`gh repo create <name> --private --source=. --remote=origin`. Without: create an empty private
repository on github.com (no README), then `git remote add origin <url>`.

## 8. Package environment, main file, co-authors, paper

- **R:** in `analysis/`, run `update.packages(ask = FALSE)`, then `renv::init()`, so the lock
  file starts from current versions; commit `renv.lock`, `.Rprofile`, `renv/activate.R` and
  `renv/settings.json`. Details: `skills/empirical-analysis/r.md`.
- **Python:** at the project root, `uv init`, then `uv add <package>`; commit `pyproject.toml`
  and `uv.lock`. Details: `skills/empirical-analysis/python.md`.
- **Main file:** from `reference/template_main_file.R`; fill in the project name and the
  `source()` lines (single study) or the `run_*.R` lines (several studies). Python: a `.py` main
  file that runs the stage scripts in order (`project-organizer` skill).
- **Co-authors** in the same code: read `reference/collaboration.md` before the first commit.
- **A paper on Overleaf:** `reference/overleaf_conventions.md`.

## 9. First commit, and the check

```
git add -A
git status                                         # read the list before committing
git commit -m "Set up project structure"
git check-ignore -v analysis/1_raw_data/test.csv   # prints the .gitignore line that ignores it
git push -u origin main                            # only if a remote exists
```

`git status` must show no data, PDFs or `.env`. `git check-ignore -v` prints the matching
pattern; a pattern starting with `!` means the file is NOT ignored. Then tell the user what was
checked: the folder location, the lock test, the staged file list.

**The new-session test.** Ask the user to start a new session in the project folder and ask it
three things: what the project is, where the raw data is, and what comes next. The answers must
come from `CLAUDE.md` and `claude/next_steps.md`. An answer that is wrong or vague means a line
is missing from one of them: add it, and ask again in a new session.

---

## Bringing an existing project up to these conventions

Report what you find first; then fix one group at a time, with the user's agreement.

- **Location** (step 1) first: a repository inside a cloud folder is the most urgent fix.
- **`CLAUDE.md`, `next_steps.md`, `OPEN_ISSUES.md`:** create them from what the user says and the
  files show.
- **`.gitignore`:** apply the template, then `git ls-files` to find data and outputs already
  committed. `git rm --cached <file>` stops tracking a file and keeps it on disk; propose it, do
  not do it unasked. Personal data already pushed: say so plainly; removing it from the history
  needs a rewrite and a force-push, a separate decision for the user.
- **Raw-data lock** (step 6), and check that no script writes into the raw-data folder.
- **Folder names:** propose renames to this layout; never move or rename unasked, because every
  path in the scripts and the paper breaks. Record the old-to-new mapping in a decision file.
- **The main file** must run top to bottom in a fresh session; if it does not, that goes into
  `OPEN_ISSUES.md` before anything is restructured.
