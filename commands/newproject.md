---
description: Set up a new research project (folder-location check, CLAUDE.md, claude/ tracking files, folder structure, .gitignore, raw-data lock, git) or bring an existing project up to these conventions.
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
   If yes, it also gets `programming/`.
6. **Raw data:** where it comes from, and where the untouched original stays.
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
- **The user copies the raw data in** (Explorer or Finder), and keeps the original where it was.
  Claude does not move or copy data into `1_raw_data/` on its own.
- **Existing projects:** never move, rename or delete a file without asking. Moving breaks every
  path that points to it.
- **Test the raw-data lock** as the reference describes, and report the result.

## 4. Finish

1. Run `git status` and read the list: no data, PDFs or secrets. State the commit message, then
   make one commit with the whole setup. Push if a remote exists.
2. Tell the user in a few lines what was created, what was checked (folder location, lock test,
   staged files), and the next step from `claude/next_steps.md`.
3. **The new-session test** (the reference's step 9): ask the user to start a new session in the
   project and ask it what the project is, where the raw data is, and what comes next. Fix
   `CLAUDE.md` where an answer is wrong or vague.
4. Offer `/rename <project-name>` so the session can be found again.
