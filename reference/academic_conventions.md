# Academic Conventions (Defaults)

**Load when:** starting a new academic-research project or making structural decisions about project layout, analysis plan, or deviation tracking.
**Skip when:** the project is already set up and the task is implementation, analysis, or output.

> **Scope:** Project conventions, workflow defaults, and setup decisions. Folder structures live in `reference/new_project.md` (single source of truth). Low-level implementation details — code recipes, LaTeX templates, package-specific how-tos — belong in `skills/*/SKILL.md` files or `skills/*/recipes/` subfolders, not here.

Use these as starting defaults when initializing a new academic research project. Discuss adjustments with the user before finalizing the project-level CLAUDE.md.

---

## Language

- Use **American English** spelling throughout (e.g., "centered" not "centred", "analyze" not "analyse"). This is the standard for economics journals.

## Research Identity

When assisting with data analysis, econometrics, or quantitative research:
- Reason at the level of a published empirical economist. Prioritize identification, causal inference, and statistical validity over prediction accuracy.
- When recommending methods, cite the standard reference (e.g., "following Wooldridge 2010" or "as in Imbens & Angrist 1994"). If you cannot name a specific reference, flag that your suggestion needs verification.
- State assumptions explicitly. If an assumption is unlikely to hold, say so.
- When uncertain about a method's properties or applicability, say "I'm not confident about this" rather than generating a plausible-sounding answer.
- Prefer well-established methods over novel ones unless asked otherwise.
- Do not invent paper titles, journal citations, or author attributions. If asked for a reference you're unsure about, say so.

## Analysis Plan Discipline

- Always check whether an analysis plan (preregistration, specification document) exists. If not, suggest creating one before beginning analysis.
- Maintain an `analysis_plan_deviations.md` file whenever deviating from the plan, including: the original plan, the decision made, and a full discussion of pros and cons.
- Maintain a `SUPERSEDED_IDEAS.md` file whenever an idea is considered and not adopted, including: the problem it was trying to solve, the pros, reasons for superseding, and the solution implemented instead (with a summary table at the top).
- Keep both files updated continuously, not retroactively.
- Code structure should mirror paper section structure.

## Output Design Protocol

Before writing output-generating code (tables, plots, exports):
- First specify: which variables, what aggregation level, what statistics, what format, how it maps to the paper.
- Discuss the spec with the user, then implement.
- When file structure changes, ask the user whether output files should be renamed. Do NOT rename outputs without asking.
- All table and figure output should target LaTeX. Use `booktabs` formatting and keep output Overleaf-friendly — avoid hardcoded formatting that Overleaf should handle (e.g., manual spacing, page breaks, font commands).
- For detailed table/figure formatting, load the research-paper skill (`skills/research-paper/`).

---

## Project Setup Workflow

When starting a new academic data analysis project, follow these three steps **in order** before writing any analysis code:

### Step 0: Repository Setup

**At the start of every new project, ask the user whether to initialize a git repository and create a GitHub remote.** Git is recommended but not required. If the user wants git, set up `.gitignore` for the project type (data, outputs, and generated artifacts excluded). If not, skip to Step 1 — the project works without version control.

### Step 1: Analysis Plan

**At the start of every new project, ask the user whether we should develop an analysis plan first.** Do not proceed to writing analysis code until this is resolved — either by creating a plan together, confirming an existing plan, or the user explicitly deciding to skip it.

Write (or review) the analysis plan — a document specifying what analyses go in each section of the paper's results. This may be a preregistration, a specification document, or an `analysis_plan.md`. It should cover:

- The paper's results section structure (e.g., 4.1 Descriptives, 4.2.1 Manipulation Check, ...)
- For each section: what hypothesis is tested, what model is estimated, what the key variables are
- Identification strategy and assumptions
- Any pre-specified robustness checks or sensitivity analyses

### Step 2: File Structure

Translate the analysis plan into a numbered script structure **before writing code**. Each paper section maps to one or more scripts. Establish the full set of scripts upfront.

**Canonical folder structures (single-study and multi-study layouts) are defined in `reference/new_project.md` step 2.** Refer to that file for the full directory trees, key conventions per layout, and common conventions for both.

### Step 3: Output Specification

Before implementing each section, write its output specification in `output_spec.md`:

- Which tables and figures this section produces
- For each output: variables, aggregation level, statistics, format, file name
- Formatting conventions (established once, applied to all outputs)

The analysis plan covers *what* to analyze. The output specification covers *how* to present it. Spec at implementation time (not all upfront), one section at a time.

---

## Per-Project Decisions

These should be discussed and decided at project start:

### Regression Table Conventions
- Star thresholds (*, **, ***)
- GOF rows to include (N, R², AIC, etc.)
- Coefficient renaming to human-readable labels
- Default standard error clustering
- Model comparison layout (columns = models, rows = coefficients)

### Plot Conventions
- Theme (minimal, classic, custom)
- Color palette (colorblind-friendly, journal-specific)
- Font sizes for publication
- Axis label conventions
- Export dimensions and resolution (DPI)

### Communication Style for Results
- Distinguishing statistical significance from economic/substantive significance
- Interpreting coefficients in real-world units
- Reporting effect sizes alongside p-values

## Code Change Staging

All code suggestions must be drafted in a project's `Claude_suggestions.R` file first — never edit main codebase scripts directly.

Workflow:
1. Write proposed code into `Claude_suggestions.R` with a numbered suggestion header (e.g., `# Suggestion #11: ...`)
2. Present the suggestion to the user and explain what it does
3. Wait for explicit approval before pushing changes to the target scripts
4. After pushing, clear the suggestion from `Claude_suggestions.R`
5. Record non-adopted code in `SUPERSEDED_IDEAS.md`

Record non-adopted code in `SUPERSEDED_IDEAS.md`; park approved-but-waiting code in `Claude_backlog.R`.
