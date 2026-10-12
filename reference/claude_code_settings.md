# Claude Code settings: what this kit sets, and how to change it

**Load when:** changing settings, permissions, hooks or the status line; something in the
setup does not work as expected.
**Skip when:** normal project work.

Last verified: 2026-10-07, against code.claude.com/docs (settings, permissions, hooks, memory,
skills); hooks, push and raw-data rules re-checked 2026-10-12 in headless sessions. Claude Code changes quickly: check the docs when something here does not match.

## Where settings live

| File | Applies to |
|---|---|
| `~/.claude/settings.json` | every project (this kit's file) |
| `<project>/.claude/settings.json` | one project; committed with it |
| `<project>/.claude/settings.local.json` | one project, only you; not committed |

They are combined. `/permissions` shows the rules in force and where each comes from;
`/doctor` reports settings it could not read.

## Permissions

- **Three lists:** `allow` (runs without asking), `ask` (always asks, even in auto mode),
  `deny` (never runs). They are checked in the order deny, ask, allow; the first match wins.
- **Rule shapes:** `Bash(git commit *)`, `PowerShell(Remove-Item *)`, `Edit(./data/raw/**)`,
  `Read(.env)`. `*` matches anything. PowerShell rules also match a command's aliases, so
  `PowerShell(Remove-Item *)` covers `rm`, `del` and `rmdir` typed in PowerShell.
- **Which shell:** on Windows, Claude Code runs commands through Git Bash if Git for Windows is
  installed, and through PowerShell otherwise. The screen shows `Bash(...)` or
  `PowerShell(...)`; this kit writes each rule for both.
- **Rules match the text Claude writes, not what a program does.** A delete inside a Python
  script passes a `Bash(rm *)` rule. That is why the instruction files say "ask before
  deleting" as well: the rule enforces the usual case, the line covers the rest.
- **Locking a project folder:** in the project's `.claude/settings.json`,
  `{"permissions": {"deny": ["Edit(./analysis/1_raw_data/**)"]}}` stops Claude's own edits there
  (not scripts it runs). The path is relative to the folder Claude Code starts in and must match
  the real folder (`analysis/1_raw_data/` is the `/newproject` layout). Check it worked: start a
  new session and ask Claude to change a file there. Writing `.claude/settings.json` is itself a
  protected write: in auto mode a reviewer model decides, so do it in Manual mode.

**What this kit sets:** git (except pushing) and `uv` / `Rscript` commands allowed; deleting
and pushing ask; reading secret files (`.env`, SSH keys), force-pushing, `git reset --hard`,
`git clean` and Claude's own edits in any `1_raw_data/` folder (`Edit(**/1_raw_data/**)`)
denied. Pushing asks because a push cannot be taken back: each time, you check that nothing
goes up that should stay off GitHub.

## Permission modes

`Shift+Tab` cycles through them: **Manual** (asks for every edit and most commands), **Accept
edits** (file edits run, commands ask), **Auto** (a reviewer model decides; `ask` and `deny`
rules still apply), **Plan** (reads and plans, changes nothing).

## Hooks

A hook is a command Claude Code runs on an event, not something Claude decides to do. This kit
has two:

- **At session start** (`SessionStart`), `scripts/session-start.ps1` prints the project's
  `claude/next_steps.md` and any panic dump, plus the git state; Claude Code adds what it
  prints to the session. It leaves `claude/OPEN_ISSUES.md` out on purpose: Claude reads that
  when you ask what is open (the pointer in the project's `CLAUDE.md`).
- **With each message** (`UserPromptSubmit`), `scripts/context-in-prompt.ps1` adds one line,
  "Context: N% used.", so Claude knows how full the context is (next section).

Notes:
- On Windows a hook command runs in Git Bash, or in PowerShell when Git Bash is not installed.
  The kit's command, `powershell -NoProfile -ExecutionPolicy Bypass -File "$HOME/.claude/..."`,
  works from both.
- **On a Mac,** Windows PowerShell does not exist. Each script has a twin in `sh`
  (`session-start.sh`, `statusline.sh`, `context-in-prompt.sh`); the install points the
  three commands in `settings.json` at them, e.g. `sh "$HOME/.claude/scripts/statusline.sh"`.
  Not yet tried on a Mac: if one fails, `/hooks` and its error say which.
- `/hooks` lists the hooks in force. A hook that fails shows an error and the session goes on.

## Status line

`scripts/statusline.ps1` shows the folder, git branch and session name, then the model and how
full the context is. The status line is drawn in the terminal and never reaches Claude, so it
also writes the context figure to a small file in the temp folder
(`claude-context-<session id>.txt`), and the prompt hook puts it into each message. Until the
status line has shown a figure in this session, the hook adds nothing.

## Instruction files

- `~/.claude/CLAUDE.md` and every file in `~/.claude/rules/` load in every session. A project's
  `CLAUDE.md` (and its `.claude/rules/`) loads in sessions started in that project.
  `CLAUDE.local.md` beside a project's `CLAUDE.md` is for you only (keep it out of git).
- `@path` inside a `CLAUDE.md` pulls in another file; this kit uses it for `about-me.md`.
- `/context` shows what loaded and how much room it takes; `/memory` opens the files.
- Keep each file short (the docs suggest under about 200 lines): every line costs room in every
  turn, and long files are followed less reliably.

## Skills, commands, agents

- **Skills:** `~/.claude/skills/<name>/SKILL.md`. Claude loads one when its `description`
  matches the task; you can also call it as `/<name>`. Without `name` and `description` in
  its frontmatter a skill is poorly found. The `skill-builder` skill explains how to write one.
- **Commands:** `~/.claude/commands/<name>.md`, run as `/<name>`. A name Claude Code already
  uses for its own command (e.g. `/review`) does not run yours: pick another.
- **Agents:** `~/.claude/agents/<name>.md` (frontmatter `name`, `description`; optional
  `tools`, `model`). Claude hands them a task in their own fresh context.

## Memory

Auto memory is on by default: Claude Code keeps notes per project under
`~/.claude/projects/<project>/memory/`. It is a convenience, not a guarantee; what must hold in
every session belongs in a `CLAUDE.md`.

## Data and privacy

What you send goes to Anthropic. Whether it may be used for model training is a setting of
your account: claude.ai/settings/data-privacy-controls. Check it before working with personal
data, and check what your data's licence or consent allows.

Claude Code also keeps every session on your computer, as a transcript under
`~/.claude/projects/` (one folder per starting folder). That is what `claude --continue` and
`--resume` read. Whatever a session saw, a data file it read included, is in there in plain
text. Claude Code deletes transcripts older than `cleanupPeriodDays` (30 days unless set).
