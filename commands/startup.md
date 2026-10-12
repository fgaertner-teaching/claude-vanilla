---
description: Pick up where the project left off - read its handover, check git, and say in a few lines where we are.
---

Get oriented in this project before any work starts. The session-start hook usually shows the
project's files already; run these steps anyway when it did not (no hook output in this
session), or when the user asks where things stand.

1. **Interrupted session?** If `claude/panic_dump.md` exists, read it and show it to the user
   first: the last session ended abruptly and some of its work may not be saved anywhere else.
   Ask whether to fold it into `next_steps.md` and remove it.
2. **Read** `claude/next_steps.md` (in the project root if there is no `claude/` folder), and the
   project's `CLAUDE.md` if it has not been loaded. Not `OPEN_ISSUES.md`: read that when the user
   asks what is open, as the project's `CLAUDE.md` says.
3. **Git:** if this is a repository, run `git status --short --branch`. If the repository has a
   remote, run `git fetch` and say whether the remote has commits this copy lacks; offer to
   pull. Do not pull without asking.
4. **Check the folder:** if this is a git repository inside OneDrive, Dropbox, Google Drive or
   Nextcloud, say so plainly (see `rules/rules.md`).
5. **Report in five lines or fewer:** where the project stands, the next step from
   `next_steps.md`, and anything unusual from steps 1–4. Then ask what we work on today.
6. **End the reply with one line to paste:** `/rename <short-name>`.

If none of the files exist, say so and offer `/newproject`.
