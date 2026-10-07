# Claude Code starter kit for researchers

A ready-made global setup for Claude Code, for empirical researchers in economics, business and
the social sciences. It gives Claude standing instructions for every project, a way to pick up
each project where the last session stopped, and skills for analysis, LaTeX papers and review.
Claude writes R, Python and LaTeX for you, and the kit is set up so you can check results
without reading code.

Last updated: 2026-10-07. Written for Windows first (for a Mac, see § On a Mac).

## What you get

| Part | What it does |
|---|---|
| `CLAUDE.md`, `rules/rules.md` | Instructions Claude reads in every session |
| `about-me.md` | Your profile: field, language, tools (you fill it in) |
| `settings.json` | Asks before deleting, blocks risky git commands, status line, start hook |
| `commands/` | `/startup`, `/session-end`, `/newproject`, `/what-slipped`, `/explain`, `/panic` |
| `skills/` | Analysis, analysis plans, LaTeX papers, writing, code, review |
| `agents/` | A literature scout and a verifier |
| `reference/` | Background files the skills and commands point to |

## Before you start

- Claude Code is installed and you are logged in (`claude` in a terminal opens it).
- Recommended: Git for Windows (git-scm.com). Without it Claude Code uses PowerShell, which
  works too, but you want git for your projects anyway.
- Check your privacy setting at claude.ai/settings/data-privacy-controls, especially before
  working with personal data.

## Install: let Claude do it

Your `~/.claude` folder (on Windows `C:\Users\<you>\.claude`) already exists once Claude Code
has run, and may already hold settings of yours. So do not copy the kit over it. Ask Claude to
merge it in:

1. Get the kit as a folder: on GitHub, Code → Download ZIP (if you have access to the
   repository), or the zip from whoever gave it to you. Unzip it anywhere, for example into
   `Downloads`.
2. Open a terminal in the unzipped folder and start `claude`. **Switch to Manual mode**
   (`Shift+Tab` until the mode shown under the input box reads Manual, or `default`). *Why:*
   `~/.claude` is a protected folder. In Manual mode Claude Code asks you before each write
   there; in auto mode a reviewer model decides instead, and it may refuse changes to permission
   settings, leaving the install half done.
3. Paste this request:

   > Install this starter kit into my global Claude Code folder, ~/.claude. Copy CLAUDE.md,
   > about-me.md.template and the folders rules, skills, commands, agents, reference and
   > scripts. Where a file already exists in ~/.claude, show me the difference and ask before
   > changing it. Merge settings.json into my existing ~/.claude/settings.json: keep my own
   > settings, add the kit's permissions, hook and status line, and show me the merged file
   > before saving it. Do not copy README.md, .git or .gitignore. Then interview me, one
   > question at a time, to create ~/.claude/about-me.md from the template.

4. Approve the file changes as Claude asks, and read the merged `settings.json` before you
   approve it.
5. Close Claude Code and start it again in any folder. Check five things:
   - Two lines under the input box show the folder, the model and how full the context is.
   - `/context` lists `CLAUDE.md`, `about-me.md` and `rules/rules.md`.
   - `/permissions` lists the kit's rules: under Ask, `Bash(rm *)` and `PowerShell(Remove-Item *)`;
     under Deny, the `git … --force` and `git … --hard` rules.
   - `/hooks` lists one `SessionStart` hook.
   - Ask *"What do you know about me, and which skills and commands do you have?"* The answer
     should come from your profile and name the kit's skills.

   If a check fails, ask Claude to compare `~/.claude/settings.json` with the kit's
   `settings.json` and show you what is missing.

**By hand instead:** copy the files listed in step 3 into `~/.claude` (merge folders, keep
your own files), copy `about-me.md.template` to `about-me.md` and fill it in, and add the
`permissions`, `hooks` and `statusLine` parts of `settings.json` to your own settings file.

## A working day with it

1. **Start Claude Code in the project's folder.** The start hook shows Claude the project's
   `claude/next_steps.md` and `claude/OPEN_ISSUES.md`, so it knows where things stand. If the hook
   is missing, type `/startup`.
2. **Work.** Claude says what "done" will look like before bigger tasks, explains technical
   terms the first time, and asks before deleting anything.
3. **When the status line shows the context about half full, or you stop:** `/session-end`.
   Claude updates the two files, commits and pushes. Then `/clear`, and the next session starts
   fresh with everything it needs on disk.

## Starting a project

In an empty folder (outside OneDrive, Dropbox and similar synced folders), type `/newproject`.
Claude asks what the project is and sets up its `CLAUDE.md`, the `claude/` tracking files, the
folders, git, and a lock on the raw-data folder.

## Commands

| Command | Use it to |
|---|---|
| `/startup` | see where the project stands (when the hook did not show it) |
| `/session-end` | save the state, commit, push, before you stop |
| `/newproject` | set up a new project |
| `/what-slipped` | have a fresh reviewer check the work just done |
| `/explain` | get the last thing explained in plain terms |
| `/panic` | save everything to one file when the session is about to die |

Claude Code's own commands matter as much: `/context` (how full), `/rewind` (back to an
earlier point), `/compact`, `/clear`, `/rename`, `/usage`, `/btw`.

## Skills

Claude loads a skill when the task matches its description, and says which one it loaded. You
can also call one directly, for example `/auditor`.

| Skill | For |
|---|---|
| `empirical-analysis` | estimation, identification, diagnostics, R and Python setup, plots |
| `analysis-plan` | pre-registrations and analysis plans, power, success criteria |
| `research-paper` | LaTeX tables and figures, the Overleaf project |
| `author` | prose others will read: papers, proposals, referee replies |
| `pre-submission-audit` | the last check before submitting a paper |
| `project-organizer` | script pipelines and folder layout |
| `coder` | writing and debugging R and Python |
| `auditor` | an independent review of any document, plan or code |
| `skill-builder` | writing a skill of your own |

## Making it yours

- **After Claude makes a mistake, keep the fix.** Claude proposes a line for the right file, and
  you decide whether it goes in. Over months this is what makes the setup fit you.
- **Keep the always-loaded files short.** Everything in `CLAUDE.md`, `rules/` and `about-me.md`
  takes room in every session. Rarely needed knowledge belongs in a skill or a `reference/` file.
- **A new skill:** ask Claude to write one with the `skill-builder` skill.
- **Settings, permissions, hooks:** `reference/claude_code_settings.md`.

## On a Mac

The start hook and the status line run Windows PowerShell. Either install PowerShell
(`brew install powershell`) and change `powershell` to `pwsh` in the two commands in
`settings.json`, or delete the `hooks` and `statusLine` parts and type `/startup` at the
start of each session.

## Updating the kit

Download the new version and run the install request again. Claude shows each difference
before changing anything, so your own additions and your `about-me.md` stay.

## Not included

Things that pay off only in a larger setup: syncing several computers, running several sessions
in parallel on one repository, literature databases connected as tools, and automated
multi-step research pipelines.
