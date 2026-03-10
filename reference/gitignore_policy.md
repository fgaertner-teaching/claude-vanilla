# .gitignore Policy: Best Practices for Academic Research Projects

**Load when:** setting up a new project's `.gitignore` or auditing an existing one.
**Skip when:** `.gitignore` is already in place and working.

Covers R and Python projects. Use the template below as a starting point; adapt to your project structure.

---

## Core principles

1. **Depth-independent patterns** — omit leading `/` so patterns match at any directory depth. Use `data/` not `/data/`, so `analysis/data/` is caught automatically.
2. **Commit renv/uv infrastructure, ignore the library** — activation scripts, lock files, and `.Rprofile` must be committed for reproducibility. Only the installed package library goes in `.gitignore`.
3. **Whitelist literature** — commit only `.md` and `.txt` summaries; raw PDFs and other files are ignored.
4. **Never commit data or outputs** — raw data, clean data, tables, plots, serialized objects, interim files.
5. **Secrets never go in git** — `.env` and any credential files, always ignored.
6. **Machine-specific files stay local** — `.vscode/`, `.claude/`, editor backup files.

---

## Template — copy and adapt for new projects

```gitignore
# === DATA AND OUTPUTS (never commit) ===
# Depth-independent: matches analysis/1_raw_data/, data/, etc. at any level
**/1_raw_data/**
**/2_interim_data_steps/**
**/3_clean_data/**
**/5_tables/**
**/6_plots/**
**/7_r_objects/**
**/8_raw_data_backup/**
# Re-include .gitkeep files so empty folder structure is visible on GitHub
# Note: use **/folder/** (not folder/) — folder/ excludes the directory itself,
# preventing the !**/.gitkeep negation from working.
!**/.gitkeep

# === LITERATURE (whitelist: track only .md and .txt summaries) ===
literature/**
!literature/**/
!literature/**/*.md
!literature/**/*.txt

# === SECRETS / LOCAL CONFIG ===
.env
.env.*
.htpasswd
config_local.R

# === EDITOR ===
.vscode/
.idea/

# === R: RENV ===
# Commit: renv/activate.R, renv/settings.json, renv.lock, .Rprofile
# Ignore: installed package library only
renv/library/
renv/sandbox/
renv/staging/

# === R: GENERATED FILES ===
.Rhistory
.Rapp.history
.RData
.RDataTmp
.Ruserdata
*-Ex.R
*.tar.gz
*.Rcheck/
.Rproj.user/
vignettes/*.html
vignettes/*.pdf
.httr-oauth
*_cache/
*.utf8.md
*.knit.md
.Renviron
docs/
po/*~
rsconnect/

# === PYTHON (include if project uses Python) ===
# Commit: pyproject.toml, uv.lock (or requirements.txt)
# Ignore: virtual environments and compiled artifacts
.venv/
.uv/
__pycache__/
*.py[cod]
*.egg-info/
dist/
build/
.pytest_cache/
.ipynb_checkpoints/

# === SYSTEM ===
desktop.ini
.DS_Store
Thumbs.db

# === CLAUDE CODE ===
# Machine-specific local settings — not shared across PCs
.claude/
CLAUDE.local.md

# === WORKTREES ===
# Local worktree working copies — never committed
.worktrees/

# === TEMP / BACKUP ===
*.log
*~
*.bak
*.orig
temp.R
temp output.txt
```

---

## Checklist after applying the template

- [ ] Data folder names match project structure (rename/remove entries as needed)
- [ ] Remove the `# === PYTHON ===` section if the project is R-only (and vice versa)
- [ ] `renv/activate.R`, `renv/settings.json`, `renv.lock`, `.Rprofile` are **not** in `.gitignore` → will be committed
- [ ] `literature/` section present only if the folder exists
- [ ] `.worktrees/` is present (worktree protocol)
- [ ] `CLAUDE.local.md` is present (machine-specific Claude context)
- [ ] Run `git status` after applying — verify no data, PDFs, or secrets are staged

---

## Notes

**renv's own `.gitignore`:** renv auto-creates `renv/.gitignore` ignoring `library/` etc. Our explicit entries are redundant but make intent visible without relying on renv's internal behavior.

**Forcing a tracked file inside an ignored folder:** use `git add -f path/to/file`. Avoid doing this for data or secrets.

**Why not a global `~/.gitignore_global`?** It's used only for machine-specific noise (`desktop.ini`, `.DS_Store`). Project rules belong in the project's `.gitignore` so they're version-controlled and visible to collaborators.
