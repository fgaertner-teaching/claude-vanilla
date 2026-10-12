# Academic Conventions (Defaults)

**Load when:** starting or restructuring an academic research project, or deciding how analysis plans, deviations, output specifications and rejected ideas are tracked in one.
**Skip when:** the project is set up and the task is running analysis, writing code, or formatting output.

Starting defaults for an empirical research project. Discuss adjustments with the user before
writing them into the project's `CLAUDE.md`, which wins wherever it differs. Folder layout:
`reference/new_project.md` (also used by `/newproject`). Methods: the `empirical-analysis` skill.

---

## Language

- Papers in **American English** spelling ("analyze", "center", "behavior"), the standard in
  economics journals, unless the target journal asks otherwise.

## Working as a research assistant

When helping with data analysis, econometrics or quantitative research:

- Reason like a published empirical researcher: identification, causal inference and statistical
  validity come before predictive fit.
- Name the standard reference when recommending a method ("following Wooldridge 2010"). If you
  cannot name one, say the suggestion needs checking.
- State assumptions explicitly, and say so when one is unlikely to hold.
- When unsure about a method's properties, say "I am not confident about this" instead of giving
  a plausible-sounding answer.
- Prefer well-established methods to novel ones unless asked otherwise.
- **Never invent a paper, title, journal or author.** Cite only what you have opened or can look
  up; otherwise mark it `[unverified]`.

---

## Project setup: in this order, before any analysis code

### Step 0: repository

Set up the project as a git repository in a **local, not cloud-synced** folder (cloud sync corrupts
`.git`), with a private remote if the user wants one, and a `.gitignore` that excludes data,
outputs and generated files. `/newproject` does this.

### Step 1: analysis plan

**Ask the user whether to write an analysis plan first.** Do not write analysis code until this is
settled: a plan written together, an existing plan confirmed, or the user deciding to skip it.

The plan says what analysis goes into each section of the paper's results: the results structure
(4.1 Descriptives, 4.2 Manipulation check, ...), for each section the hypothesis, model and key
variables, the identification strategy and its assumptions, and the pre-specified robustness
checks. It may be a pre-registration, a specification document or `analysis_plan.md`. Writing it:
the `analysis-plan` skill.

### Step 2: script structure

Translate the plan into numbered scripts **before writing code**: each results section maps to one
or more scripts, and the full set is listed up front. Why: code that mirrors the paper's structure
lets anyone go from a table in the paper to the script that made it.

### Step 3: output specification, one section at a time

Before implementing a section, write its entry in `claude/output_spec.md`: which tables and figures it
produces, and for each the variables, aggregation level, statistics, format and file name. Fix the
formatting conventions once and apply them to every output. The plan says *what* to analyze; the
output specification says *how* to present it. Specify at implementation time, not all up front.

---

## While the analysis runs

- **Check for an analysis plan** at the start of any analysis work; if there is none, suggest one.
- **Log every deviation from the plan** in `claude/analysis_plan_deviations.md` as it happens:
  the original plan, the decision, and the reasons for and against. A deviation reconstructed at
  submission is a deviation nobody can verify.
- **Record ideas considered and not adopted** in the project's decision file on that topic,
  `claude/decision_<topic>.md` (an idea with no decision file gets one): the problem it
  addressed, its advantages, why it was rejected, and what was done instead. Why: otherwise the same idea is proposed and
  re-evaluated in a later session.
- **Before writing output code** (tables, plots, exports), state the specification (variables,
  aggregation, statistics, format, where it goes in the paper), agree it with the user, then implement.
- **Do not rename output files without asking.** The paper refers to them by name.
- **Tables and figures target LaTeX** unless the paper is written in Word (then agree the format
  with the user first): `booktabs` tables, PDF figures, nothing the document class should
  control (manual spacing, page breaks, font commands). Formatting details: the
  `research-paper` skill.
- **Claude edits analysis scripts directly**; for a large change, or one Claude is unsure about,
  show it before it lands. The thorough review happens over the finished code before submission
  (the `pre-submission-audit` skill). Co-authored projects may agree on a stricter staging
  convention (`reference/collaboration.md`).

---

## Decide at project start

**Regression tables:** star thresholds (or none); goodness-of-fit rows (N, R², ...); readable
coefficient labels; default SE clustering; layout (columns = models, rows = coefficients).

**Figures:** theme; colorblind-safe palette, consistent across the paper; font sizes; axis-label
conventions; export size and format.

**Reporting results:** separate statistical from economic significance; interpret coefficients in
real-world units; report effect sizes and confidence intervals, not only p-values.

## Tracking files for research projects

Besides the files `rules/rules.md` § Project tracking names: `claude/analysis_plan.md`,
`claude/analysis_plan_deviations.md`, `claude/pipeline_map.md` and `claude/output_spec.md`, each
named in the project's `CLAUDE.md` with when to read it (`reference/new_project.md` § 2).

- **Prefer checks to checklists.** "Did LaTeX compile?" or "do the table notes match the
  estimates?" belong in the script that builds the output, where a failure prints and stops.
  A checklist is read once, then answered from memory and skipped without anyone noticing.
