# Claude Code settings: what this kit sets, and how to change it

**Load when:** changing settings, permissions, hooks or the status line; something in the
setup does not work as expected.
**Skip when:** normal project work.

Last verified: 2026-10-07, against code.claude.com/docs (settings, permissions, hooks, memory,
skills). Claude Code changes quickly: check the docs when something here does not match.

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

**What this kit sets:** git and `uv` / `Rscript` commands allowed; deleting asks; reading
secret files (`.env`, SSH keys), force-pushing, `git reset --hard` and `git clean` denied.

## Permission modes

`Shift+Tab` cycles through them: **Manual** (asks for every edit and most commands), **Accept
edits** (file edits run, commands ask), **Auto** (a reviewer model decides; `ask` and `deny`
rules still apply), **Plan** (reads and plans, changes nothing).

## Hooks

A hook is a command Claude Code runs on an event, not something Claude decides to do. This kit
has one: at session start (`SessionStart`), `scripts/session-start.ps1` prints the project's
`claude/next_steps.md`, `claude/OPEN_ISSUES.md` and any panic dump, plus the git state; Claude
Code adds what it prints to the session.

- On Windows a hook command runs in Git Bash, or in PowerShell when Git Bash is not installed.
  The kit's command, `powershell -NoProfile -ExecutionPolicy Bypass -File "$HOME/.claude/..."`,
  works from both.
- **On a Mac,** Windows PowerShell does not exist. Either install PowerShell
  (`brew install powershell`) and change `powershell` to `pwsh` in `settings.json` (both
  places), or remove the hook and the status line and run `/startup` at the start instead.
- `/hooks` lists the hooks in force. A hook that fails shows an error and the session goes on.

## Status line

`scripts/statusline.ps1` shows the folder, git branch and session name, then the model and how
full the context is. The context figure is what the "wrap up at about half full" rule reads.

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
