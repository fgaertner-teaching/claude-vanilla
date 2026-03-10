# Claude Code Starter Kit for Academic Researchers

A ready-to-use `~/.claude/` configuration for Claude Code, designed for researchers doing empirical work in economics, finance, and social sciences. Copy it, fill in your details, and start working.

## Prerequisites

- **Anthropic account** with a Max or Team subscription (Claude Code requires a paid plan)
- **Node.js** (version 18+) — Claude Code runs on Node.js. Download from [nodejs.org](https://nodejs.org/)
- **A terminal** — on Windows, use Git Bash, PowerShell, or Windows Terminal. On Mac, use Terminal.

## Quick Start

### 1. Install Claude Code

Follow [the official guide](https://docs.anthropic.com/en/docs/claude-code/overview). After installation, verify it works by typing `claude` in your terminal.

### 2. Copy this folder to `~/.claude/`

> **What is `~/.claude/`?** The `~` symbol means your home folder. On Windows, that's `C:\Users\YourName\`. On Mac, it's `/Users/YourName/`. The `.claude` folder is where Claude Code looks for its configuration. Folders starting with `.` are hidden by default — you may need to enable "Show hidden files" in your file explorer to see it.

**If you have git:**
```bash
git clone <your-repo-url> ~/.claude
```

**If you don't have git:**
1. Click the green "Code" button on the GitHub page, then "Download ZIP"
2. Unzip the downloaded file
3. Rename the unzipped folder to `.claude` (note the dot at the start)
4. Move it to your home folder (`C:\Users\YourName\` on Windows, `/Users/YourName/` on Mac)

### 3. Set up your profile

- Inside `~/.claude/`, copy `about-me.md.template` to `about-me.md`
- Open `about-me.md` in any text editor and fill in the placeholders (name, institution, research area, methods)

### 4. Review permissions

- `settings.json` (already inside `~/.claude/`) pre-approves safe operations: reading files, running R/Python scripts, and git commands
- You don't need to change anything to get started

### 5. Verify setup

Open a terminal, navigate to any folder, and run `claude`. Ask: "What skills do you have available?" Claude should list the skills from this kit (Empirical Analysis, Plotting, etc.). If it doesn't, the `~/.claude/` folder may not be in the right place.

### 6. Start your first project

- Create a new folder for your project
- Open Claude Code in that folder: `cd your-project-folder && claude`
- Type `/newproject` — Claude will walk you through setting up the project step by step
- When asked about project type, choose `academic-research` and `work`
- When asked about git, choose yes if you use git, or no to skip it

## What This Does

### The problem it solves

Without instructions, Claude Code starts every session with no memory of your field, your methods, or your project conventions. You end up repeating the same context ("I'm an economist", "use renv", "don't commit data files") every time.

This starter kit gives Claude persistent knowledge about:
- How empirical research projects are structured
- What econometric methods and packages you use
- How to format tables and figures for journals
- How to track what happened in each session so the next one can pick up seamlessly

### How it works

Claude Code reads `CLAUDE.md` and `rules/rules.md` at the start of every session. These contain universal instructions: how to track issues, naming conventions, session protocols.

**Skills** in `skills/` are loaded only when relevant. For example, the plotting skill loads when you create a figure, the R skill loads when you manage packages. This keeps Claude focused on what you're doing right now.

### Session protocol

Sessions follow a simple cycle:

1. **Start:** Claude reads your `next_steps.md` and `OPEN_ISSUES.md` to pick up where you left off
2. **Work:** You work together on your project
3. **End:** Type `/session-end` — Claude updates tracking files so the next session continues seamlessly. If you use git, it also commits and pushes.

### Tracking files (in each project)

| File | What it does |
|------|-------------|
| `claude/next_steps.md` | Session handoff — what was done, what to do next |
| `claude/OPEN_ISSUES.md` | Open bugs, questions, to-dos |
| `claude/SUPERSEDED_IDEAS.md` | Approaches that were considered and rejected, with reasoning |

These files live inside your project, not in `~/.claude/`. Claude creates them when you run `/newproject`.

## Do I Need Git?

**No.** Git is recommended but not required. The starter kit works without it:

- Without git, the session-start hook won't run (no sync checks). That's fine — just type `/startup` manually when you start a session.
- `/session-end` will update your tracking files but skip the commit/push step.
- You lose version history, which means you can't undo mistakes as easily. Consider learning git basics when you're ready — it's worth it.

If you do use git, this kit pre-approves common git commands so Claude won't ask for permission on every `git status` or `git commit`.

## Included Skills

| Skill | When it loads | What it helps with |
|-------|--------------|-------------------|
| **Empirical Analysis** | Academic-research projects | Econometrics, identification, causal inference, diagnostics |
| **R** | R package management | renv setup, package hygiene |
| **Python** | Python package management | uv setup, virtual environments |
| **Plotting** | Creating figures | ggplot2 themes, export settings, colorblind-friendly palettes |
| **marginaleffects** | Model interpretation | Predictions, comparisons, slopes, average treatment effects |
| **Research Paper** | Tables and figures | LaTeX formatting, booktabs, Overleaf-friendly output |
| **Analysis Plan** | Pre-registration | Hypothesis architecture, power analysis, specification design |
| **Project Organizer** | Pipeline structure | Script numbering, folder layout, output-to-paper mapping |
| **Auditor** | Quality review | Structured 2+1 review protocol for any artifact |
| **Pre-Submission Audit** | Before submission | Cross-reference check, consistency, production quality |

## Slash Commands

| Command | What it does |
|---------|-------------|
| `/startup` | Pick up where you left off (reads next_steps, open issues) |
| `/session-end` | Save progress, update tracking files, commit if using git |
| `/newproject` | Set up a new research project (walks you through it) |
| `/panic` | Emergency dump if session is about to crash (saves everything to one file) |

## Customization

### Adding your own skills

Create a new file at `skills/<skill-name>/SKILL.md`. Start with:

```markdown
# Skill Name

**Load when:** [when should Claude load this skill]
**Skip when:** [when is this skill irrelevant]

[Your domain knowledge, conventions, and instructions here]
```

Then add a trigger entry to the skill table in `CLAUDE.md`.

### Modifying conventions

All conventions live in `rules/rules.md`. Edit it directly. If it grows too large, split into separate files under `rules/` and update the file list in `CLAUDE.md`.

## What's NOT Included

This is a starter kit — intentionally simpler than a fully customized setup. Features you might want to add later as you get comfortable:

- **Custom agents** — specialized subagents for literature search, idea evaluation, proposal writing
- **Multi-PC sync** — automatic repo synchronization if you work on multiple machines
- **Research proposal pipeline** — automated idea-to-proposal workflow with literature scouts
- **Career management** — periodic self-assessment and career planning tools

## File Structure

```
~/.claude/
  CLAUDE.md                    # Main instructions for Claude
  about-me.md                  # Your profile (you fill this in)
  settings.json                # Permissions and hooks
  rules/
    rules.md                   # All conventions in one file
  commands/                    # Slash commands (/startup, /session-end, etc.)
  skills/                      # Domain knowledge (loaded when needed)
    empirical-analysis/        # Econometrics and methods
    research-paper/            # LaTeX and formatting
    analysis-plan/             # Pre-registration
    project-organizer/         # Pipeline structure
    auditor/                   # Quality review
    pre-submission-audit/      # Manuscript check
  reference/                   # Setup protocols and templates
  scripts/                     # Hooks that run automatically
```
