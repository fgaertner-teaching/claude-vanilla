# .gitignore Policy for Research Projects

**Load when:** setting up a project's `.gitignore`, auditing one, or deciding whether a new kind
of file belongs in git.
**Skip when:** the `.gitignore` is in place and the file in question is plainly code or notes.

Covers R and Python projects with a LaTeX paper. Start from the template below and adapt it to
the project's folders.

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
   code only reads it, it is raw data.)
3. **Secrets never go in git:** `.env`, API keys, `config_local.*`, `.Renviron`.
4. **Commit the environment's recipe, ignore its installation.** `renv.lock`, `.Rprofile`,
   `renv/activate.R`, `renv/settings.json`, `pyproject.toml`, `uv.lock` are committed; the
   installed libraries (`renv/library/`, `.venv/`) are not. *Why:* the recipe lets anyone rebuild
   the same environment; the installation is large and machine-specific.
5. **Patterns without a leading `/`** match at any depth: `**/1_raw_data/**` catches
   `analysis/1_raw_data/` and `analysis/study_1/main/1_raw_data/` alike.
6. **Local settings stay local,** except the shared project rules: `.claude/settings.json` (it
   holds the raw-data lock) is committed; the rest of `.claude/` and `CLAUDE.local.md` are not.
7. **A new kind of file gets a line here before it is first staged.** `.gitignore` does not
   affect files git already tracks.

---

## Template

```gitignore
# === DATA AND OUTPUTS (never commit) ===
**/1_raw_data/**
**/2_interim_data_steps/**
**/3_clean_data/**
**/5_tables/**
**/6_plots/**
**/7_r_objects/**
**/7_objects/**
# Keep the empty folder structure: re-include sub-folders (e.g. appendix/),
# then the .gitkeep files. Use **/folder/** above, not folder/ : folder/ would
# exclude the directory itself and the .gitkeep negation could not work.
!**/5_tables/**/
!**/6_plots/**/
!**/.gitkeep

# === LITERATURE (track only .md and .txt notes; PDFs stay out) ===
literature/**
!literature/**/
!literature/**/*.md
!literature/**/*.txt

# === SECRETS AND MACHINE-SPECIFIC CONFIG ===
.env
.env.*
config_local.R
config_local.py
.Renviron
.httr-oauth

# === R ===
# Commit: renv.lock, .Rprofile, renv/activate.R, renv/settings.json
renv/library/
renv/sandbox/
renv/staging/
.Rhistory
.Rapp.history
.RData
.RDataTmp
.Ruserdata
.Rproj.user/
*_cache/
*.utf8.md
*.knit.md
rsconnect/

# === PYTHON ===
# Commit: pyproject.toml, uv.lock
.venv/
__pycache__/
*.py[cod]
*.egg-info/
.pytest_cache/
.ipynb_checkpoints/

# === LATEX BUILD FILES (if the paper is compiled in this repository) ===
*.aux
*.bbl
*.bcf
*.blg
*.fdb_latexmk
*.fls
*.out
*.run.xml
*.synctex.gz
*.toc
# the compiled paper, by name (not *.pdf: a questionnaire PDF is an input)
# paper/main.pdf

# === EDITORS AND SYSTEM ===
.vscode/
.idea/
desktop.ini
.DS_Store
Thumbs.db

# === CLAUDE CODE ===
# Use .claude/* (not .claude/) so the negation below can work
.claude/*
!.claude/settings.json
CLAUDE.local.md

# === TEMP AND BACKUP ===
*.log
*~
*.bak
*.orig
```

---

## After applying it

- [ ] The data folder names match the project's folders; rename or remove entries as needed.
- [ ] Remove the R or the Python section if the project uses only one language.
- [ ] `renv.lock`, `.Rprofile`, `renv/activate.R`, `renv/settings.json` are NOT ignored.
- [ ] `.claude/settings.json` is NOT ignored (`git check-ignore -v .claude/settings.json` prints
      the `!.claude/settings.json` line, or nothing).
- [ ] Before the first commit, `git status` lists no data, PDFs or secrets.

## Notes

- **Test a path:** `git check-ignore -v <path>` prints the line that decides it. A printed
  pattern starting with `!` means the file is NOT ignored, although the command succeeds.
- **A file that was committed before it was ignored** stays tracked. `git rm --cached <file>`
  stops tracking it and keeps it on disk; its old versions stay in the history. If it held
  personal data and was pushed, tell the user: removing it from the history is a separate job.
- **A deliberate exception** inside an ignored folder (a small, non-personal example dataset for
  a replication package): `git add -f <file>`, and say why in the commit message.
- **renv writes its own `renv/.gitignore`.** The R entries above repeat it on purpose, so the
  intent is visible without knowing renv's internals.
- **Project rules belong in the project's `.gitignore`,** not in a global git ignore file: there
  they are versioned and the same for every collaborator.
