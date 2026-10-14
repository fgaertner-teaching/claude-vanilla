---
description: Set up a new research project (folder-location check, CLAUDE.md, claude/ tracking files, folder structure, .gitignore, raw-data lock, git, the index of projects) or bring an existing project up to these conventions.
---

Set up this project with the user by walking through `~/.claude/reference/new_project.md`.
Read that file first; it holds the templates and the reasons. This command says how to run it.

## 1. Which mode

Look at the current folder:

- **Empty, or nearly** (no scripts, no data): a **new project**, steps 1 to 9 of the reference.
- **An existing project with files:** **bring it up to the conventions**, the reference's last
  section. Audit first, report what conforms and what does not, then fix one group at a time.

Say which mode you see and let the user confirm before changing anything.

## 2. Ask, one question at a time

1. **Where:** run the folder-location check (reference step 1) and report the result. If the
   folder is inside a cloud-synced folder, stop until the user has chosen a new place.
2. **What the project is:** name, `project-type`, and two or three sentences on question, data
   and method. This becomes the project `CLAUDE.md`.
3. **Language:** R, Python, or both.
4. **Studies:** one study, or several (or a pilot plus a main wave).
5. **Generated data:** does the project create its own data (experiment, simulation, scraping)?
   If yes, it also gets `programming/`, and where its code first writes the data, a backed-up
   place, is the original (reference step 3).
6. **Raw data:** where it comes from, and where the untouched original stays: a folder
   elsewhere, a download, data the project generates, or none yet (reference step 3 says what
   `CLAUDE.md` records for each). The project works on a copy in `analysis/1_raw_data/`. Data
   too large to copy: reference step 3, `config_local`.
7. **GitHub:** a private remote now, or later?
8. **Co-authors** working in the same code? If yes, read `~/.claude/reference/collaboration.md`
   before the first commit.
9. **Where the paper is written:** LaTeX in this repository, Overleaf, Word, or not decided yet.
   Note it in `CLAUDE.md`. For Overleaf, `~/.claude/reference/overleaf_conventions.md` has the
   copy step.

Then say what "done" will look like for this project (the list at the top of the reference,
adapted to the answers) and wait for the user's OK.

## 3. Build

- Follow the reference's steps in order; report each in one line as it is done.
- **The pipeline skeleton is copied in complete** (reference step 3): for R
  `reference/templates/r/` plus `reference/template_main_file.R` as
  `analysis/Data_Analysis_Main_File_OPEN_ME_FIRST.R`, for Python `reference/templates/python/`
  (both, if the answer to question 3 was both). Copy, do not write the scripts anew; fill in
  only the main file's project name and description. Once the package environment exists
  (reference step 8), run the main file once and report what it said (with no data yet:
  "copy your data into 1_raw_data/"). For `academic-research`, the five scripts get their rows in
  `claude/pipeline_map.md` (reference step 4).
- **The user copies the raw data in** (Explorer or Finder), and keeps the original where it was.
  Claude does not move or copy data into `1_raw_data/` on its own: the lock refuses Claude's own
  tools, and Claude never routes around it with a script.
- **`config_local`** only if the pipeline needs a path that differs on every laptop: data too
  large to copy in, or the paper's synced folder if question 9 named one (`overleaf_sync_path`)
  (reference step 3). Most projects have none.
- **Existing projects:** commit first, then move (the reference's last section). Never move,
  rename or delete a file without asking. Moving breaks every path that points to it.
- **Have the user check the raw-data lock** with `/permissions` (reference step 6), and report
  what they saw.

## 4. Finish

1. **The checks, then the commit** (reference step 9, in its order): `git check-ignore -v` on a
   file in each raw-data folder; `git status` and `git status --ignored --short`, both lists read
   (no data, PDFs or secrets in the first; nothing that belongs in git in the second). State the
   commit message, then make one commit with the whole setup. Push if a remote exists.
2. **The index:** ask, then add the project to `~/.claude/projects.md` (reference step 9). If
   the write is refused, give the user the entry to paste.
3. Tell the user in a few lines what was created, what was checked (folder location, the lock,
   both lists), and the next step from `claude/next_steps.md`.
4. **The new-session test** (reference step 9): ask the user to start a new session in the
   project and ask it what the project is, where the raw data is (the copy and the original), and
   what comes next. Fix `CLAUDE.md` where an answer is wrong or vague, then commit the fix,
   stating the message first, and push it if a remote exists.
5. Offer `/rename <project-name>` so the session can be found again.
