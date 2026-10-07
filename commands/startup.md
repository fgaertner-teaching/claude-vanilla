---
description: Pick up where the project left off - read its handover and open issues, check git, and say in a few lines where we are.
---

Get oriented in this project before any work starts. The session-start hook usually shows the
project's files already; run these steps anyway when it did not (no hook output in this
session), or when the user asks where things stand.

1. **Interrupted session?** If `claude/panic_dump.md` exists, read it and show it to the user
   first: the last session ended abruptly and some of its work may not be saved anywhere else.
   Ask whether to fold it into `next_steps.md` and remove it.
2. **Read** `claude/next_steps.md` and `claude/OPEN_ISSUES.md` (in the project root if there is
   no `claude/` folder), and the project's `CLAUDE.md` if it has not been loaded.
3. **Git:** if this is a repository, run `git status --short --branch`. If the repository has a
   remote, run `git fetch` and say whether the remote has commits this copy lacks; offer to
   pull. Do not pull without asking.
4. **Check the folder:** if this is a git repository inside OneDrive, Dropbox, Google Drive or
   Nextcloud, say so plainly (see `rules/rules.md`).
5. **Report in five lines or fewer:** where the project stands, the next step from
   `next_steps.md`, the open issues that block it, and anything unusual from steps 1–4. Then
   ask what we work on today.
6. **Once the task is clear,** offer one line: `/rename <short-name>`.

If none of the files exist, say so and offer `/newproject`.
