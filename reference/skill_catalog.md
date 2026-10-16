# What is in this setup

**Load when:** looking for the right skill, command or agent; adding, renaming or removing one
(update this file and `kit_guide.md` in the same step); unsure which file owns a convention.
**Skip when:** you already know which file to use.

## Skills (`skills/<name>/SKILL.md`, loaded by their description)

| Skill | For | Sub-files |
|---|---|---|
| `empirical-analysis` | estimation, identification, diagnostics, interpretation | `r.md`, `python.md`, `plotting.md`, `marginaleffects.md`, `causal_reasoning.md`, `research_integrity.md` |
| `analysis-plan` | pre-registrations, analysis plans, power, success criteria | |
| `research-paper` | LaTeX tables and figures, on Overleaf or locally | `regression_tables.md` |
| `author` | prose that others read: papers, proposals, referee replies | `diagnostics.md`, `sections.md` |
| `pre-submission-audit` | the last check before submitting a paper: consistency, upload, anonymisation | |
| `journal-formalia-check` | a manuscript against one journal's author guidelines, supplied, never from memory | |
| `project-organizer` | script pipelines, folder layout, outputs mapped to the paper | |
| `coder` | writing and debugging R and Python | `windows.md`, `long_runs.md`, `debugging.md` |
| `auditor` | independent review of a document, plan, code or setup | |
| `skill-builder` | writing a new skill | |

## Commands (`commands/<name>.md`, typed as `/<name>`)

| Command | Does |
|---|---|
| `/startup` | shows where the project stands (when the start hook did not) |
| `/session-end` | updates `next_steps.md`, `OPEN_ISSUES.md` and the session log, records decisions, commits, pushes |
| `/newproject` | sets up a new project |
| `/what-slipped` | a fresh subagent critiques the work just done |
| `/explain` | explains the last thing in plain terms |
| `/panic` | saves everything to `claude/panic_dump.md` when the session is about to end |

## Agents (`agents/<name>.md`)

| Agent | Does |
|---|---|
| `literature-scout` | searches the web for existing work on a question; every reference copied from a page it opened |
| `verifier` | read-only pass/fail check that a task was done |
| `referee2` | adversarial referee for a finished analysis and its code: five audits, a replication in the other language, a report in `claude/referee2/`; reads but never runs or changes the author's files, installs nothing |

## Where each convention lives

| What | File |
|---|---|
| What each file does, in plain words | `reference/kit_guide.md` |
| How Claude talks, plans, checks, handles sessions | `CLAUDE.md` |
| Files and data, project tracking, git, code, quality | `rules/rules.md` |
| Who you are, your language and field | `about-me.md` |
| Permissions, the two hooks, the status line | `settings.json`, `scripts/` |
| Settings explained | `reference/claude_code_settings.md` |
| Setting up a project | `reference/new_project.md` (used by `/newproject`) |
| `.gitignore` patterns | `reference/gitignore_policy.md` |
| Working with co-authors | `reference/collaboration.md` |
| An Overleaf paper | `reference/overleaf_conventions.md` |
| Deadlines | `reference/deadlines.md` |
| Defaults for academic projects | `reference/academic_conventions.md` |
| Before committing | `reference/checklist.md` |
| A main R script to start from | `reference/template_main_file.R` |

## In each project

| File | Holds |
|---|---|
| `CLAUDE.md` | what Claude needs to know about the project |
| `claude/next_steps.md` | where the project stands; overwritten at each session end |
| `claude/OPEN_ISSUES.md` | what is still open; resolved items deleted |
| `claude/long_term_open_issues.md` | what is open but can wait; read only when asked |
| `claude/session_log.md` | one dated entry per session; never rewritten |
| `claude/decision_<topic>.md` | a decision, its options and its reasons |
| `claude/referee2/` | `referee2`'s reports and replication scripts, once it has run |
| `.claude/settings.json` | the project's own permissions, e.g. the raw-data lock |
