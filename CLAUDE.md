# Global Instructions

## Structure

**Always-loaded files** (present in every session):
- **`CLAUDE.md`** (this file) — universal identity and behaviors
- **`rules/rules.md`** — session protocol, process conventions, technical conventions

**On-demand files** (loaded when triggered — see skill trigger table below):
- **`skills/*/SKILL.md`** — domain expertise (loaded per trigger table)
- **`reference/collaboration.md`** — co-author workflow (read proactively for collaboration tasks)
- **`reference/new_project.md`** — project setup checklist (used when initialising new projects)
- **`reference/academic_conventions.md`** — loaded at project start for academic-research projects
- **`reference/`** — other reference materials loaded as needed

## Project Type

Every project CLAUDE.md should declare two dimensions:
- **`project-type`**: `academic-research`, `software`, `exploration`, etc.
- **`project-context`**: `work` or `leisure`

If either is missing, ask the user before proceeding.

**Convention loading by context:**
- All `work` projects: full tracking — `OPEN_ISSUES.md`, discussion files, and `SUPERSEDED_IDEAS.md` in `claude/` (flat, no subfolder)
- All `leisure` projects: lightweight — `claude/next_steps.md` only; `OPEN_ISSUES.md` optional
- `academic-research` + `work`: also read `~/.claude/reference/academic_conventions.md` and `~/.claude/skills/empirical-analysis/SKILL.md` at session start

## General Workflow

- **Research before building.** Before setting up something new, search for current best practices and official documentation first. Present findings to the user before committing to an approach.
- Work modularly. Complete one logical unit at a time, report what was done and show results, then wait for confirmation before proceeding.
- Be explicit about unknowns. If unsure, say so rather than guessing.
- Before large-scale refactoring or architectural changes, confirm the plan with the user first.
- When making changes in a project with existing tests, run them before and after to catch regressions.
- **Skill triggers:** Before starting any task, check whether a relevant skill applies using the table below. Two behaviors:
  - **Read proactively** — read the skill file before implementing, no need to ask.
  - **Suggest and ask** — propose loading the skill and wait for confirmation.

  | Skill | Task-type trigger | Topic trigger | Behavior |
  |-------|------------------|---------------|----------|
  | `skills/research-paper/SKILL.md` | Writing tables, figures, or LaTeX output | — | Read proactively |
  | `skills/empirical-analysis/SKILL.md` | — | — | Auto-loaded for `academic-research` projects |
  | `skills/empirical-analysis/r.md` | R package management | renv, R setup | Suggest and ask |
  | `skills/empirical-analysis/python.md` | Python package management | uv, Python setup | Suggest and ask |
  | `skills/empirical-analysis/plotting.md` | Creating or modifying plots | ggplot2, data visualisation | Read proactively |
  | `skills/empirical-analysis/marginaleffects.md` | Interpreting model output | marginaleffects, ATE | Suggest and ask |
  | `skills/analysis-plan/SKILL.md` | Creating or reviewing output specs | Analysis plan, pre-registration, PAP | Suggest and ask |
  | `skills/project-organizer/SKILL.md` | Structuring a script pipeline | Script architecture, pipeline layout | Suggest and ask |
  | `skills/auditor/SKILL.md` | Reviewing any artifact for quality | Audit, review, quality check | Suggest and ask |
  | `skills/pre-submission-audit/SKILL.md` | Final manuscript check | Pre-submission, manuscript audit | Suggest and ask |
  | `reference/collaboration.md` | Adding a co-author | Collaboration, co-author onboarding | Read proactively |
  | `reference/new_project.md` | Setting up a new project | new project, new repo | Read proactively |

  **When suggesting a skill:** say "This task involves [X] — shall I load the [skill name] skill first?" and wait for the user's answer before reading the file.
- **Skill maintenance:** When a discussion reveals a skill-relevant insight, propose updating the relevant `SKILL.md` at the end of the conversation.
- Don't read entire files or papers upfront. Read what's needed for the current step; load more as needed.

## Communication

- **A message ending in `?` is a genuine question, not an instruction.** Respond with your opinion or analysis first. Do not implement anything until the user explicitly confirms they want it done.

## Approach Selection

- Start by evaluating the simplest approach. If it answers the question convincingly, prefer it.
- But always consider whether a more complex approach adds something the simple one misses — stronger identification, robustness to alternative explanations, richer information.
- Present the trade-offs and let the user decide.
