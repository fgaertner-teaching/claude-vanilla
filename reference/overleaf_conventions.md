# Overleaf conventions

**Load when:** setting up a paper on Overleaf, connecting it to a local project, moving
Claude-written LaTeX or generated tables and figures into Overleaf, or untangling two copies of
a paper that have drifted apart.
**Skip when:** the paper is not on Overleaf, or the task is the content of a table, figure or
paragraph (`research-paper`, `author`).

Claude works on files on this computer; the user writes on Overleaf in the browser. Claude
cannot see Overleaf, cannot compile there and cannot upload there. Something has to carry files
across, and which route is available depends on the user's Overleaf plan.

---

## 1. What each plan allows

Last verified: 2026-10-07 (docs.overleaf.com).

| | Free plan | Premium (paid, or through an institution) |
|---|---|---|
| Collaborators per project | one | more, by plan |
| Compile timeout | 10 seconds | 240 seconds |
| Upload files or a `.zip` | yes | yes |
| Git integration (Overleaf as a git remote) | no | yes |
| GitHub synchronisation | no | yes |
| Dropbox synchronisation | no | yes |

**Ask the user first whether their university has an Overleaf institutional licence**
("Overleaf Commons"). Its participants get the premium features, including Git, GitHub and
Dropbox sync, usually by logging in with the university e-mail address. The answer decides
which route below is possible.

## 2. The four routes

### A. Manual upload (works on every plan)

- **Into Overleaf:** in the project, the **Upload** button above the file list, then drop the
  changed files into the matching folder (confirm the replacement if Overleaf asks). A whole new
  project: **New project → Upload project** with a `.zip`.
- **Out of Overleaf:** download the project's source as a `.zip` (Overleaf's menu, Download),
  and unpack it over the local copy before Claude edits anything.
- **Claude's part:** after each re-run of the analysis, list exactly which files in `5_tables/`
  and `6_plots/` changed since the last upload, so the user uploads those and nothing else. For
  prose Claude drafted, give the file (or the paragraph to paste) and say where it goes.
- **The risk:** the user forgets an upload, and the paper shows numbers the code no longer
  produces. A line in `claude/next_steps.md` ("tables re-generated, not yet uploaded") closes
  most of that gap.

### B. Git integration (premium)

Every Overleaf project is also a git repository at `https://git.overleaf.com/<project-id>`; the
id is the last part of the project's address (`overleaf.com/project/<project-id>`).

- **Authentication:** create a token in Overleaf's Account Settings. When git asks, the username
  is `git` and the password is the token. Tokens expire after a year.
- **Workflow:** clone it once into the local projects folder (not into a cloud-synced folder),
  then for every change: `git pull` (gets the user's Overleaf edits), Claude edits, commit,
  `git push`. Overleaf shows the change on the next refresh.
- **Never force-push.** Overleaf keeps one linear history; a force-push replaces the project the
  user is editing. If a push is rejected, pull, merge, push again.
- **With GitHub as well:** add GitHub as a second remote on the same clone. This is the
  documented way to connect an existing Overleaf project to an existing GitHub repository.

### C. GitHub synchronisation (premium)

Set up from Overleaf's menu, **Integrations → GitHub**, by the project owner (a collaborator
cannot set it up).

- **It only creates, it does not link:** it makes a new GitHub repository from an Overleaf
  project, or a new Overleaf project from a GitHub repository. It cannot connect an existing
  project to an existing repository; for that, use route B with GitHub as a second remote.
- **It is not automatic.** The user presses "pull changes from GitHub" or "push Overleaf
  changes" in that menu. So when Claude commits to the GitHub repository, push at once after
  every commit, and tell the user to pull in Overleaf; an unpushed commit is invisible to them.
- **On a conflict** Overleaf pushes a separate branch (named after the date) to GitHub instead of
  merging. Merge that branch into `main` (look at it first: if the user edited in Overleaf, those
  edits exist only there), push, then continue the sync in Overleaf. Do not rewrite or
  force-push the synced branch.

### D. Dropbox synchronisation (premium)

All of the user's Overleaf projects appear in `Dropbox/Apps/Overleaf/<project name>/` and sync in
both directions automatically.

- **The local copy lags.** Changes made in Overleaf can take a couple of minutes to arrive. If a
  PDF compiled on Overleaf disagrees with the local `.tex`, suspect the local copy is not yet
  current before calling the file wrong.
- **Simultaneous edits create conflict copies** ("… conflicted copy …") that can break the
  compile. Compiled files (`.pdf`, `.aux`, `.log`, `.bbl`) cause spurious conflicts; Overleaf
  recommends excluding them from Dropbox sync.
- **Collaborators** only get the Dropbox copy if they have premium themselves.
- **Never put a git repository inside the Dropbox folder.** Git and a sync client both rewrite
  files and corrupt each other's state. The analysis repository stays in the local projects
  folder and copies outputs into Dropbox (§ 4).
- Best use: the pipeline pushing generated tables and figures into the paper with no clicks.

## 3. Which route, and the one rule for all of them

| Situation | Route |
|---|---|
| Free plan, no institutional licence | A |
| Premium, the user writes in Overleaf, Claude contributes prose | B (or C if the paper should also live on GitHub) |
| Premium, mainly generated tables and figures flowing into the paper | D, or B with the copy step in § 4 |
| Co-authors without premium | A or B for the person who holds the connection |

**Declare which copy is the document of record, and keep the flow one-way.** Write it into the
project's `CLAUDE.md` in one line, for example: *"The paper's text lives in Overleaf; tables and
figures are generated in `analysis/` and copied into Overleaf's `tables/` and `figures/`; never
edit them there."* *Why:* a mirror looks exactly like a workspace (same files, fully writable),
so editing the wrong copy forks the paper silently, and both versions look correct until someone
compares them.

Two consequences:

- **Before Claude edits any local copy of text the user also edits in Overleaf, bring it up to
  date** (pull, download, or wait for Dropbox). Ask the user whether they edited since.
- **Generated files flow one way, analysis → paper.** A fix to a table is made in the script,
  never in Overleaf's copy of the table.

## 4. Copying generated outputs into the paper

A small helper in the pipeline's setup script copies tables and figures to wherever the paper
lives locally: the Dropbox folder (route D) or the local clone of the Overleaf or GitHub
repository (routes B and C, followed by a commit and push). The target is machine-specific, so it
goes in the gitignored `analysis/config_local.R` (see `reference/collaboration.md`), never in
committed code. If no target is set, the helper does nothing, so the pipeline still runs for a
co-author or a replicator.

```r
# 0_shared/0_Setup.R — overleaf_sync_path is set in config_local.R (gitignored), e.g.
#   overleaf_sync_path <- "C:/Users/<name>/Dropbox/Apps/Overleaf/<project>"
if (file.exists("config_local.R")) source("config_local.R")
if (!exists("overleaf_sync_path")) overleaf_sync_path <- NULL

sync_to_paper <- function(source_dir, dest_subdir) {
  if (is.null(overleaf_sync_path)) {
    message("No overleaf_sync_path set; skipping copy of ", source_dir)
    return(invisible(NULL))
  }
  dest <- file.path(overleaf_sync_path, dest_subdir)
  if (!dir.exists(dest)) dir.create(dest, recursive = TRUE)
  files <- list.files(source_dir, full.names = TRUE)   # includes appendix/ subfolders
  file.copy(files, dest, overwrite = TRUE, recursive = TRUE)
  message("Copied ", length(files), " items to ", dest)
}

# at the end of the table and figure export scripts:
sync_to_paper(here::here("5_tables"), "tables")
sync_to_paper(here::here("6_plots"),  "figures")
```

The Dropbox folder's location can also be read from Dropbox's own settings file
(`%LOCALAPPDATA%\Dropbox\info.json` on Windows, field `personal` → `path`), which saves each
co-author from typing it.

On route B or C the paper's clone is its **own** repository: never nest it inside the analysis
repository. Committing generated tables there is fine, because in that repository they are the
paper's inputs.

## 5. Inside the Overleaf project

The layout (`main.tex`, `preamble.tex`, `sections/`, `tables/`, `figures/`, the `.bib`,
`submission/`) is described in the `project-organizer` skill. Three Overleaf-specific points:

- **Paths are relative to the main file's folder**, whichever file contains the command. A
  section in `sections/results.tex` still writes `\input{tables/tab_main_effects}` and
  `\includegraphics{figures/fig_effects}`, never `../tables/…`.
- **A table preview file** (`table_sandbox.tex`): a minimal document that only `\input`s every
  table and figure. Compiling it shows whether a new table renders without compiling the whole
  paper; add each new table's line to it as soon as the table exists.
- **Set the main document and the compiler** in Overleaf's menu: pdfLaTeX is the default;
  XeLaTeX or LuaLaTeX only if the template requires them or the text needs system fonts.

**On the free plan's 10-second compile limit:** large papers time out. Include figures as
PDF files rather than TikZ code compiled on every run, comment out the `\input` lines of the
sections not being worked on while drafting, and move the appendix into its own document.

**Compile errors:** Claude cannot see them. Ask the user to paste the first error from the logs
(the first one matters; later errors are usually consequences), or compile locally
(`research-paper` § 7).

**Backup:** Overleaf's version history is limited on the free plan. The local copy under git
(route A's download, or routes B and C) is the backup that does not depend on the plan.
