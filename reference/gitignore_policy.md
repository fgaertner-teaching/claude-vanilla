# .gitignore Policy for Research Projects

**Load when:** setting up a project's `.gitignore`, auditing one, or deciding whether a new kind
of file belongs in git.
**Skip when:** the `.gitignore` is in place and the file in question is plainly code or notes.

Covers R and Python projects with a LaTeX or Word paper. Start from the template below and
adapt it to the project's folders.

**The template leaves everything out, then lets in the kinds of file people write by hand.** A
file of a kind nobody listed stays out. *Why:* the other way round, listing what to keep out,
fails by committing a data file someone saved outside the data folders, and a push cannot be
taken back. This way fails by leaving a new kind of code file out, which is noticed and fixed
with one line.

---

## Principles

1. **Never commit data or generated outputs.** Raw, interim and clean data, tables, figures,
   saved objects, compiled PDFs. *Why:* data may be personal or licensed, and git history cannot
   be taken back once pushed; generated files change on every run, so each commit stores a full
   new copy forever, and they can be rebuilt from the scripts anyway.
2. **Inputs are not outputs.** A codebook, a questionnaire, a stimulus, a crosswalk typed by
   hand: written once by a person, read by the scripts, produced by no script. Commit them, even
   when binary, unless they contain personal data. The test is not the file type or the name:
   **ask what reads the file and what writes it.** If a script reads it and no script writes it,
   it is an input. (`export_2024.csv` sounds like an output; if the provider wrote it and your
   code only reads it, it is raw data.) An input of a kind the template does not let in (a
   questionnaire PDF, a codebook in Excel) gets its own line: `!materials/questionnaire.pdf`.
3. **Secrets never go in git:** `.env`, API keys, `config_local.*`, `.Renviron`.
4. **Commit the environment's recipe, ignore its installation.** `renv.lock`, `.Rprofile`,
   `renv/activate.R`, `renv/settings.json`, `pyproject.toml`, `uv.lock` are committed; the
   installed libraries (`renv/library/`, `.venv/`) are not. *Why:* the recipe lets anyone rebuild
   the same environment; the installation is large and machine-specific.
5. **Patterns without a leading `/`** match at any depth: `**/1_raw_data/**` catches
   `analysis/1_raw_data/` and `analysis/study_1/main/1_raw_data/` alike.
6. **Local settings stay local,** except the shared project rules: `.claude/settings.json` (it
   holds the raw-data lock) is committed; the rest of `.claude/` and `CLAUDE.local.md` are not.
7. **A new kind of file that belongs in git gets a `!` line before it is first staged.**
   Without one it stays out, and nothing warns you, so before a push list what git leaves out
   (`git status --ignored --short`). `.gitignore` does not affect files git already tracks.
8. **Order matters: the last line that matches a path decides.** So the lines that must hold
   whatever the type (data folders, secrets) come after the list of kinds let in.

---

## Template

```gitignore
# === 1. LEAVE EVERYTHING OUT, BUT LOOK INTO EVERY FOLDER ===
*
!*/

# === 2. LET IN THE KINDS OF FILE PEOPLE WRITE ===
# Code
!*.R
!*.Rmd
!*.qmd
!*.py
# Text, notes and the paper
!*.md
!*.tex
!*.bib
!*.bst
!*.cls
!*.sty
!*.docx
# Word's lock file while a document is open (~$paper.docx) is not a paper
~$*
# The environment's recipe (its installation stays out, section 3)
!renv.lock
!.Rprofile
# **/ because renv lives in analysis/: a pattern with a slash inside counts from the root only
!**/renv/settings.json
!pyproject.toml
!uv.lock
!.python-version
# The repository's own files, and the project's Claude Code rules (the raw-data lock)
!.gitignore
!.here
!.claude/settings.json
# An input of another kind, one line each, e.g.:
# !materials/questionnaire.pdf

# === 3. ALWAYS OUT, WHATEVER THE KIND (these come last, so they win) ===
# Data and outputs (generated tables are .tex, which section 2 lets in)
**/1_raw_data/**
**/2_interim_data_steps/**
**/3_clean_data/**
**/5_tables/**
**/6_plots/**
**/7_r_objects/**
**/7_objects/**
# Secrets and machine-specific config (config_local.R is an .R file)
.env
.env.*
config_local.*
.Renviron
# Installed environments and caches (they hold .R, .py and .md files of their own)
**/renv/library/
**/renv/sandbox/
**/renv/staging/
.venv/
*_cache/
*.utf8.md
*.knit.md
.ipynb_checkpoints/
# Claude Code: your own notes for this project, and the worktrees of `claude --worktree`
CLAUDE.local.md
.claude/worktrees/

# === 4. KEEP THE EMPTY FOLDER STRUCTURE ===
# The output folders' sub-folders (e.g. appendix/), then the .gitkeep files.
!**/5_tables/**/
!**/6_plots/**/
!**/.gitkeep
```

---

## After applying it

- [ ] The data folder names match the project's folders; rename or remove entries as needed.
- [ ] Every kind of file the project writes by hand is let in (a `.do` file, a `.jl` script, a
      Stata log you keep on purpose: one `!` line each).
- [ ] `renv.lock`, `.Rprofile`, `renv/activate.R`, `renv/settings.json` are NOT ignored.
- [ ] `.claude/settings.json` is NOT ignored (`git check-ignore -v .claude/settings.json` prints
      the `!.claude/settings.json` line).
- [ ] Before the first commit, `git status` lists no data, PDFs or secrets, and
      `git status --ignored --short` lists nothing that should be in.

## Notes

- **Test a path:** `git check-ignore -v <path>` prints the line that decides it. A printed
  pattern starting with `!` means the file is NOT ignored, although the command succeeds.
- **A file that was committed before it was ignored** stays tracked. `git rm --cached <file>`
  stops tracking it and keeps it on disk; its old versions stay in the history. If it held
  personal data and was pushed, tell the user: removing it from the history is a separate job.
- **A deliberate exception** inside an ignored folder (a small, non-personal example dataset for
  a replication package): `git add -f <file>`, and say why in the commit message.
- **renv writes its own `renv/.gitignore`.** The renv entries above repeat it on purpose, so the
  intent is visible without knowing renv's internals.
- **Generated files can be of section 2's kinds:** knitr writes `.md`, a table script writes
  `.tex`. That is why section 3 names the output folders and caches; a
  script that writes elsewhere needs a line there too.
- **Project rules belong in the project's `.gitignore`,** not in a global git ignore file: there
  they are versioned and the same for every collaborator.
