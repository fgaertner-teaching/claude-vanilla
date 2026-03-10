# Convention Map: Which File Does What

**Load when:** unsure which file to read/update, or after adding/moving/retiring files in `~/.claude/`.
**Skip when:** you know exactly which file to work with.

---

### Core files

| File | Purpose | Updated when |
|------|---------|-------------|
| `CLAUDE.md` | Main entry point: project type rules, skill triggers, communication conventions | Rare — only universal rules |
| `rules/rules.md` | Consolidated conventions: session protocol, workflow, technical standards | Convention changes |
| `about-me.md` | Researcher profile (from template) | Profile changes |
| `settings.json` | Permissions (allow/deny) and hooks (SessionStart, PreToolUse) | Permission or hook changes |

### Commands

| File | Purpose | Updated when |
|------|---------|-------------|
| `commands/startup.md` | `/startup` — session start protocol | Startup convention changes |
| `commands/session-end.md` | `/session-end` — session end protocol | Session end changes |
| `commands/newproject.md` | `/newproject` — new project setup | Project setup changes |
| `commands/panic.md` | `/panic` — emergency session dump | Rarely |

### Skills

| File | Purpose | Updated when |
|------|---------|-------------|
| `skills/empirical-analysis/SKILL.md` | Econometrics, identification, estimation | Methods guidance needed |
| `skills/empirical-analysis/r.md` | R setup (renv), toolkit, package gotchas | Working in R |
| `skills/empirical-analysis/python.md` | Python setup (uv), toolkit | Working in Python |
| `skills/empirical-analysis/plotting.md` | Data visualisation conventions | Creating or modifying plots |
| `skills/empirical-analysis/marginaleffects.md` | marginaleffects package guide | Model interpretation |
| `skills/research-paper/SKILL.md` | LaTeX tables, figures, formatting | Output formatting |
| `skills/analysis-plan/SKILL.md` | Pre-registration, hypothesis architecture | Analysis plan design |
| `skills/project-organizer/SKILL.md` | Pipeline architecture, project layout | Structuring a pipeline |
| `skills/auditor/SKILL.md` | Structured quality review (2+1 protocol) | Audit or quality review |
| `skills/pre-submission-audit/SKILL.md` | Final manuscript check before submission | Pre-submission |

### Reference

| File | Purpose | Updated when |
|------|---------|-------------|
| `reference/new_project.md` | Project setup protocol: folder structure, git, initial files | Setup convention changes |
| `reference/academic_conventions.md` | Defaults for academic projects | Academic convention changes |
| `reference/collaboration.md` | Multi-author workflow | Collaboration setup |
| `reference/gitignore_policy.md` | .gitignore template and policy | Policy changes |
| `reference/checklist.md` | Pre-commit checklist | New obligation identified |
| `reference/convention_map.md` | This file — structure guide | Files added/moved/retired |
| `reference/claude_code_settings.md` | Claude Code configuration reference | CC feature documented |
| `reference/overleaf_conventions.md` | Overleaf setup and conventions | Overleaf changes |
| `reference/skill_catalog.md` | Skills overview with triggers | Skill added/removed |
| `reference/template_main_file.R` | Template for main R file | Template changes |

### Scripts

| File | Purpose | Updated when |
|------|---------|-------------|
| `scripts/session-start.sh` | SessionStart hook — git checks at session start | Session protocol changes |
| `scripts/hooks/commit_guard.sh` | PreToolUse hook — prompts before git commit | Commit convention changes |
| `scripts/hooks/pipeline_guard.sh` | PreToolUse hook — prompts before editing pipeline scripts | Staging convention changes |

### Project-level files (in each project)

| File | Purpose | Updated when |
|------|---------|-------------|
| `CLAUDE.md` | Project type, context, conventions | Project structure changes |
| `claude/next_steps.md` | Session handoff | Session end |
| `claude/OPEN_ISSUES.md` | Open bugs, questions, to-dos | Issue found or resolved |
| `claude/SUPERSEDED_IDEAS.md` | Rejected approaches with reasoning | Idea rejected |
| `claude/analysis_plan.md` | Research questions, hypotheses, analyses | Analysis plan changes |
| `claude/output_spec.md` | Table/figure specifications | Output section designed |
| `claude/pipeline_map.md` | Script-by-script pipeline overview | Scripts added/removed |
