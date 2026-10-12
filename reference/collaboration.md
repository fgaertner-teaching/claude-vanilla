# Collaboration: Several Authors in One Project

**Load when:** adding a co-author, setting up a project several people work on, or being asked
to change code that a co-author owns.
**Skip when:** working alone on a project.

---

## Where files live

| Place | Holds | Why separate |
|---|---|---|
| Local folder with git, pushed to GitHub | code, `CLAUDE.md`, `claude/`, notes, lock files | git keeps the code's history; it must not sit in a cloud folder |
| A shared cloud folder (Google Drive, Nextcloud, Dropbox, university cloud) | raw data, materials, literature PDFs | shared files that are not code; git handles large binaries badly and must never hold personal data |
| Overleaf, if the paper is there | the paper | how tables and figures get there: `reference/overleaf_conventions.md` |

- **Raw data is copied once** from the shared folder into each author's own
  `analysis/1_raw_data/` (gitignored); scripts read the local copy. *Why:* no script depends on a
  cloud path that differs on every machine, and the shared folder stays the untouched original.
- **Generated outputs are not shared** through git or the cloud folder. Each author rebuilds them
  by running the main file; the paper receives them through its copy step.
- **Machine-specific paths** go in `analysis/config_local.R` (or `config_local.py`), which is
  gitignored; each author writes their own. Scripts read it if it exists and never hard-code a
  path:

```r
# config_local.R: this machine only, never committed
shared_data_path   <- "G:/My Drive/<project>"                            # to re-copy raw data
overleaf_sync_path <- "C:/Users/<name>/Dropbox/Apps/Overleaf/<project>"  # only with an Overleaf paper
```

(`overleaf_sync_path` is what the copy helper in `reference/overleaf_conventions.md` reads.
Without an Overleaf paper, leave that line out.)

---

## Git with co-authors

- **Work on a branch,** named `<initials>/<topic>`; changes reach `main` through a pull request
  that another author looks at. *Why:* `main` always runs, and every change gets a second pair of
  eyes and a record of why it was made.
- **Pull before you start, push when you stop.** The others may need your state tomorrow.
- **Claude Code can run the git steps** and explain each one; nobody needs to memorise commands.
  Force-pushing to a shared branch is never done: it erases the others' commits.

## Packages

- **R (renv):** after installing or updating a package, `renv::snapshot()`, then commit
  `renv.lock`. After pulling a changed `renv.lock`, `renv::restore()`. Never
  `install.packages()` without the snapshot. If two branches both changed `renv.lock`, keep the
  union of packages, not one author's file.
- **Python (uv):** `uv add <package>` updates `pyproject.toml` and `uv.lock`; commit both. After
  pulling, `uv sync`.
- **One author updates packages at a time,** at a milestone; the others restore. *Why:* two
  simultaneous updates produce lock-file conflicts that nobody can judge.

---

## Claude in a co-author's code: suggest, do not edit

**Each script has an owner, written in the project `CLAUDE.md`.** In code the current user owns,
Claude edits directly. In a script a co-author owns, Claude does not edit; it writes the proposed
change into the current user's staging file, `analysis/Claude_suggestions_<initials>.R` (or
`.py`), one block per suggestion, naming the target file, the place, the change and the reason.
The owner reads it and applies it, or declines.

*Why:* the owner is responsible for that script and knows it in detail. An edit they never saw
cannot be reviewed, may be undone silently by their next merge, and turns up as a surprise in a
result. A staging file makes the change visible, reviewable and attributed.

```r
# ---- Suggestion: cluster standard errors by school ----------------------
# Target: 4_scripts/3_2_Results_Main_Analysis.R, the feols() call for model 2
# Why: treatment is assigned by school, so errors are correlated within schools.
# Replace
#   feols(score ~ treat + controls, data = data_final_survey_main)
# with
feols(score ~ treat + controls, data = data_final_survey_main, cluster = ~school)
```

```
# WRONG: the co-author owns stage 3, and Claude edits it directly
edit 4_scripts/3_2_Results_Main_Analysis.R
# RIGHT
append the block to analysis/Claude_suggestions_<initials>.R and tell the user it awaits the owner
```

- **Each author has their own staging file;** nobody edits someone else's.
- **A suggestion the owner approved but cannot apply yet** (it waits on another change) stays in
  the file under a `## Waiting` heading, with what it waits for.
- **Who the current user is:** the author whose e-mail `git config user.email` shows.

---

## The project `CLAUDE.md` in a shared project

A co-author's Claude reads the project `CLAUDE.md`, but not your `~/.claude/` (your rules and
skills live on your machine only). So anything every author's sessions must follow goes into the
project `CLAUDE.md`. Decide this once, when the first co-author joins: go through your global
rules and copy in what must hold for everyone (for example the CSV format, the decision files,
the project's table and plot conventions).

Add a block like this:

```markdown
## Working together

- Code owners: <A> owns 4_scripts/1_* and 2_* (loading, cleaning); <B> owns 3_* to 5_*.
  Claude edits only the current user's code (the user is whoever `git config user.email` names).
  Changes to another author's script go into `analysis/Claude_suggestions_<user's initials>.R`
  with target, place and reason, for the owner to apply.
- Branches: work on `<initials>/<topic>`; merge into `main` only through a pull request.
- Packages: after installing one, `renv::snapshot()` and commit `renv.lock` (Python: commit
  `pyproject.toml` and `uv.lock`). After pulling a changed lock file: `renv::restore()` / `uv sync`.
- Handover: each author has `claude/next_steps_<initials>.md`; the start hook shows all of them,
  so act on the current user's and treat the others as context. Read the current user's at session
  start and overwrite it at session end, instead of `claude/next_steps.md`.
- Decisions: `claude/decision_<topic>.md` (question, options, choice, why) for any analytical
  choice another author would need the reason for.
- Say so at once when someone is about to install a package without updating the lock file,
  commit directly to `main`, or edit another author's script or staging file.
```

*Why a handover per author:* two people overwriting one `next_steps.md` on different branches
produces a merge conflict at every merge, and each loses the other's state.

---

## COAUTHOR_GUIDE.md

A plain-language guide at the project root for someone who has never seen the project. Create it
when the first co-author joins and update it whenever a convention changes.

**How to write it:** for a PhD student on their first day. Explain each tool before using it and
each term at first use; show the action first and the reason after; give an install link for
every tool; short paragraphs.

**Sections:**

1. **Tools to install:** Git, a GitHub account, R and/or Python with uv, Rtools on Windows (needed
   to install R packages that compile; https://cran.r-project.org/bin/windows/Rtools/), access to
   the shared cloud folder. Optional: GitHub Desktop, Claude Code. No specific editor is required.
2. **Where files live:** the three places above; clone into a local folder that no cloud service
   syncs, and why; copy the raw data once.
3. **Running the pipeline:** first time `renv::restore()` (or `uv sync`), then the main file.
4. **Git, step by step:** clone, pull, make a branch, commit, push, open a pull request; end with
   a short table "when / command / what it does" for later.
5. **Packages:** the renv / uv rules above, and why versions matter (a different package version
   can change a result).
6. **Machine-specific setup:** a copy-paste `config_local.R` template, with how to find each
   path on Windows and Mac.
7. **Working with Claude here:** who owns which code, the staging files, the decision files.
8. **Questions:** whom to ask; where the open issues are (`claude/OPEN_ISSUES.md`).
