# Claude Code starter kit for researchers

A ready-made global setup for Claude Code, for empirical researchers in economics, business and
the social sciences. It gives Claude standing instructions for every project, a way to pick up
each project where the last session stopped, and skills for analysis, LaTeX papers and review.
Claude writes R, Python and LaTeX for you, and the kit is set up so you can check results
without reading code.

Last updated: 2026-10-14. Written for Windows first (for a Mac, see § On a Mac).

## What you get

| Part | What it does |
|---|---|
| `CLAUDE.md`, `rules/rules.md` | Instructions Claude reads in every session |
| `about-me.md` | Your profile: field, language, tools (you fill it in) |
| `settings.json` | Asks before deleting or pushing; blocks risky git commands and edits in raw-data folders; status line; two hooks |
| `commands/` | `/startup`, `/session-end`, `/newproject`, `/what-slipped`, `/explain`, `/panic` |
| `skills/` | Analysis, analysis plans, LaTeX papers, writing, code, review, a journal's author guidelines |
| `agents/` | A literature scout, a verifier, and a referee for a finished analysis |
| `reference/` | Background files the skills and commands point to |
| `reference/kit_guide.md` | What every file in the kit does, in plain words, and how the parts work together |
| OpenAlex (MCP server) | The open literature database as a tool: Claude searches papers, citations and authors. Connected by the install, not a file here |

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

   > Install this starter kit into my global Claude Code folder, ~/.claude. If
   > ~/.claude/settings.json exists, first copy it to ~/.claude/settings.before-kit.json. Copy
   > CLAUDE.md, about-me.md.template and the folders rules, skills, commands, agents, reference
   > and scripts. Where a file already exists in ~/.claude, show me the difference and ask before
   > changing it. Merge settings.json into my existing ~/.claude/settings.json: keep my own
   > settings, add the kit's permissions, hooks, status line and skillListingBudgetFraction,
   > and show me the merged file
   > before saving it. The kit's prompt hook only repeats the context figure the kit's status
   > line writes: if I keep a status line of my own, tell me, and offer to add the kit's lines
   > that write the figure to mine. Do not copy README.md, .git or .gitignore. On a Mac, point the three
   > hook and status-line commands in settings.json at the .sh scripts instead of the .ps1
   > ones (sh "$HOME/.claude/scripts/<name>.sh"). Then interview me, one question at a time,
   > to create ~/.claude/about-me.md from the template. Then connect the OpenAlex literature
   > database for all my folders: claude mcp add --scope user --transport stdio openalex --
   > npx -y openalex-research-mcp@0.5.0 . If ~/.openalex_api_key exists, pass its content as
   > OPENALEX_API_KEY with -e, placed before --transport, without printing the key. Last, check whether git, Rscript, uv,
   > quarto and pdftotext are found from a terminal, and for each one that is not, say where
   > it is installed and offer to add it to my PATH.

4. Approve the file changes as Claude asks, and read the merged `settings.json` before you
   approve it.
5. Close Claude Code and start it again in any folder. Check six things:
   - Two lines under the input box show the folder, the model and how full the context is.
   - `/context all` lists `CLAUDE.md`, `about-me.md` and `rules/rules.md` under Memory files.
   - `/permissions` lists the kit's rules: under Ask, `Bash(rm *)`, `PowerShell(Remove-Item *)`
     and `Bash(git push *)`; under Deny, the `git … --force` and `git … --hard` rules and
     `Edit(**/1_raw_data/**)`.
   - `/hooks` lists a `SessionStart` and a `UserPromptSubmit` hook.
   - `/mcp` lists `openalex`. If it shows the server failed, Node.js is missing: ask Claude to
     install it, then start Claude Code again.
   - Ask *"What do you know about me, and which skills and commands do you have?"* The answer
     should come from your profile and name the kit's skills. (Names are always listed; whether
     their descriptions fit is what `/context`'s Skills row shows.)

   If a check fails, ask Claude to compare `~/.claude/settings.json` with the kit's
   `settings.json` and show you what is missing.

**By hand instead:** copy the files listed in step 3 into `~/.claude` (merge folders, keep
your own files), copy `about-me.md.template` to `about-me.md` and fill it in, and add the
`permissions`, `hooks`, `statusLine` and `skillListingBudgetFraction` parts of `settings.json`
to your own settings file (save a copy of it first). On a Mac, point those three commands at the `.sh` scripts (§ On a
Mac).

## A working day with it

1. **Start Claude Code in the project's folder.** The start hook shows Claude the project's
   `claude/next_steps.md`, so it knows where things stand. If the hook is missing, type
   `/startup`.
2. **Work.** Claude says what "done" will look like before bigger tasks, explains technical
   terms the first time, and asks before deleting anything.
3. **When Claude says the context is about half full, or you stop:** `/session-end`. Claude
   updates the project's files, commits and pushes (you approve the push). Then `/clear`, and
   the next session starts fresh with everything it needs on disk.

## Starting a project

In an empty folder (outside OneDrive, Dropbox and similar synced folders), type `/newproject`.
Claude asks what the project is and sets up its `CLAUDE.md`, the `claude/` tracking files, the
folders, git, and a lock on the raw-data folder. The project works on a copy of your raw data,
which you copy in yourself. The original stays where it is. At the end, Claude asks before
adding the project to your list of projects, `~/.claude/projects.md`.

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
| `research-paper` | LaTeX tables and figures, on Overleaf or locally |
| `author` | prose others will read: papers, proposals, referee replies |
| `pre-submission-audit` | the last check before submitting a paper: does it agree with itself? |
| `journal-formalia-check` | a paper against the journal's own author guidelines, which you supply |
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

The hooks and the status line are PowerShell scripts, and each has a twin in `sh`
(`scripts/*.sh`). The install request has Claude switch `settings.json` to the twins. They have
not been tried on a Mac yet: if `/hooks` shows an error, ask Claude to look at the script it
names.

## Updating the kit

Get the new version as a folder, start Claude in it, and ask:

> Compare this kit with my ~/.claude. Which changes are upgrades for me, and which would undo
> something I set up on purpose? Show me each one, and change nothing until I say so.

Do not simply copy the new files over yours: your own additions, your `about-me.md` and your
settings would be lost.

## Not included

Things that pay off only in a larger setup: syncing several computers, and automated
multi-step research pipelines.
