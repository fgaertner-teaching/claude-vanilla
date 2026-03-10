# Overleaf Project Conventions

**Load when:** setting up or modifying an Overleaf project connected to an R analysis pipeline.
**Skip when:** no Overleaf involvement in the current task.

Standard structure and conventions for Overleaf projects connected to a `new_project.md`-style
R analysis pipeline.

---

## Standard Folder Structure

```
<overleaf_project_root>/
├── main.tex                    # Main paper manuscript
├── online_appendix.tex         # Online appendix (separate submission file)
├── elevator_pitch.tex          # Brief written summary — proto-abstract
├── ideas_and_sketches.tex      # Free-form scratchpad for ideas, notes, fragments
├── table_sandbox.tex           # Compilable preview: \input{} refs to every table
├── todo.tex                    # Paper-level to-do list (not analysis to-dos)
├── readme.tex                  # Explains the folder structure (for self and co-authors)
├── library.bib                 # Main paper bibliography
│
├── study_1/
│   ├── pilot/
│   │   ├── tables/             # Main tables (synced from R pipeline)
│   │   │   └── appendix/       # Appendix tables
│   │   ├── plots/              # Main plots (synced from R pipeline)
│   │   │   └── appendix/       # Appendix plots
│   │   └── pilot_results.tex   # Results narrative (standalone, compilable)
│   └── main/                   # Same structure (for main study)
│       ├── tables/appendix/
│       └── plots/appendix/
│
├── study_2/              # Add when applicable (same structure)
│
├── archive/                    # Old versions of main.tex and other root files
├── grants/                     # Grant applications and materials
│   └── <grant_name>/           # e.g. dfg_2026/, erc_2027/
├── materials/
│   ├── preregistration/        # Pre-registration reports
│   ├── ethics/                 # Ethics certificates and approvals
│   └── experiment/             # Experiment materials (instructions, screenshots, oTree)
├── presentations/              # Beamer slides, posters, conference talks
│   └── <talk_name>/
│       ├── slides.tex
│       ├── Literature.bib      # Presentation-specific bib (stays here, not in library.bib)
│       └── pictures/
├── sections/                   # When main.tex is split via \input{} chapters
├── style/                      # Custom .sty / .cls files, journal templates
└── submission/
    └── <journal_name>/         # e.g. aer/, restud/, jpe/
        ├── first_submission/   # Submission files, cover letter
        ├── first_rnr/          # Revised manuscript, response to reviewers
        └── ...
```

---

## Root File Conventions

- **`main.tex`** — the manuscript. Can include author annotation commands
  (e.g., `(e.g., \todo{}, \note{}) for collaborative drafting. Strip before submission.
- **`online_appendix.tex`** — compiled independently; same preamble as `main.tex`.
  Keep the same preamble (tabularray, tinytable macros, etc.).
- **`elevator_pitch.tex`** — short written pitch for the paper; will eventually evolve
  into the abstract. **Not** a slide deck — slides live in `presentations/`.
- **`ideas_and_sketches.tex`** — free-form working document; not expected to compile
  cleanly. Distinct from `todo.tex` (actionable items) and the analysis `OPEN_ISSUES.md`.
- **`table_sandbox.tex`** — see § Table Sandbox Convention below.
- **`todo.tex`** — paper-writing to-dos. Analysis to-dos go in `claude/OPEN_ISSUES.md`.
- **`readme.tex`** — explains the folder structure for self-reference and co-authors.
  Update when the structure changes significantly.
- **`library.bib`** — the main paper bibliography. Presentation-specific bib files
  live alongside the relevant `.tex` in `presentations/<name>/`.

---

## Path Convention (\input and \includegraphics)

**Critical:** Overleaf resolves all paths relative to the **project root**, regardless
of where the source file lives. A file at `study_1/pilot/pilot_results.tex` that
includes a table must use the full root-relative path:

```latex
% Correct:
\input{study_1/pilot/tables/tab_descriptive_stats}
\includegraphics{study_1/pilot/plots/plot_treatment_effect.pdf}

% Wrong — even if the .tex file lives in study_1/pilot/:
\input{tables/tab_descriptive_stats}
\includegraphics{plots/plot_treatment_effect.pdf}
```

Convention: omit the `.tex` extension in `\input{}` (LaTeX resolves both, without is cleaner).
Use `.pdf` for plots (vector graphics, scales cleanly) unless the file is only available as PNG.

---

## Retired: `preliminary_N` Pattern

An earlier approach used a `save_preliminary()` helper to copy individual tables/plots
into the Overleaf folder as `preliminary_1.tex`, `preliminary_1.pdf`, etc. for quick
preview. This is **retired** — `table_sandbox.tex` covers the same use case cleanly:
tables are always synced via `sync_to_dropbox()` and always referenced in the sandbox,
so any table can be previewed by compiling that one file. Do not reintroduce temporary
`preliminary_N` files.

## Table Sandbox Convention

**`table_sandbox.tex`** is a compilable document containing `\input{}` references to
every table in the project. It serves as a single-file preview environment — compile it
to check any table without compiling the full manuscript.

**Rule (for Claude):** Every time a new table is added to the R pipeline and its `.tex`
file is synced to Overleaf, immediately add the corresponding `\input{}` line to
`table_sandbox.tex`. This applies to:
- Main paper tables (`study_1/pilot/tables/tab_name`)
- Appendix tables (`study_1/pilot/tables/appendix/tab_name`)

Do this as part of the same step as writing the table-generation code, before presenting
the suggestion to the user.

---

## Results Narrative Files

Every experiment × phase gets a standalone results narrative. Naming convention: `{phase}_results.tex`, located inside its study-phase subfolder.

| Phase | Overleaf path |
|-------|--------------|
| Experiment 1, pilot | `study_1/pilot/pilot_results.tex` |
| Experiment 1, main | `study_1/main/main_results.tex` |
| Experiment 2, pilot | `study_2/pilot/pilot_results.tex` |
| ... | ... |

### File properties

- **Self-contained:** own `\documentclass` and preamble — compiles independently without `main.tex`
- **Linked to outputs via `\input{}` and `\includegraphics{}`** — never copy-paste table content
- **Updated as analysis results solidify** — grows alongside the pipeline, not written retrospectively
- **Eventually feeds into `main.tex`** as the results section when writing begins

### Tone and audience

The intended reader is a first-year economics PhD student — someone who knows econometrics and micro theory, but has no prior exposure to behavioral economics or to the specific experiment design. The file serves dual purpose: (1) making results legible to collaborators unfamiliar with the sub-field, and (2) forcing the authors to articulate their reasoning before it hardens into unspoken assumptions.

Each analysis section must include:
- **Background:** what question this analysis answers and why it is interesting
- **Design motivation:** why this particular specification was chosen (e.g., why OLS vs. IV, why these controls, why this benchmark rather than another)
- **Concept explanations:** any behavioral-economics concept the reader needs before interpreting the result — do not assume the reader knows what weight recovery is, what a Bayesian optimal prediction looks like, or why a trust bias is non-trivial
- **Plain-language interpretation:** what the result means, not just its statistical form

**Tone check:** would a first-year PhD student with no behavioral economics background be able to follow the argument from scratch? If not, add context.

**Tone is textbook-style, not paper-draft style.** Err on the side of too much background rather than too little.

### Claude rule: proactive file creation

When the first results for a new experiment × phase are about to be written, pushed to the pipeline, or discussed — **check whether the corresponding `{phase}_results.tex` exists**. If it does not, suggest creating it before proceeding.

The file can start as a minimal compiled shell with section placeholders. Creating it early costs almost nothing; creating it retrospectively means reconstructing reasoning from code comments and memory.

### Co-author visibility

**This convention must also be included inline in the project `CLAUDE.md`** — `~/.claude/` is machine-local and invisible to a co-author's Claude session. This file is the canonical template; copy the tone/audience and proactive-creation rule into the project file so both authors' Claude sessions enforce it.

---

## Submission Folder

```
submission/
  <journal_name>/         e.g. aer/, restud/, jpe/
    first_submission/     submission package, cover letter
    first_rnr/            revised manuscript, response to reviewers
    second_rnr/           (if needed)
  <another_journal>/      (if resubmitting after rejection)
```

Cover letters and response-to-reviewers letters live **inside the relevant round
subfolder**, not in a separate `cover_letters/` folder. This keeps everything for one
submission round co-located.

---

## Sync: R Pipeline → Overleaf

Outputs sync via Dropbox (automatic when pipeline runs `sync_to_dropbox()`):

| R pipeline output | Overleaf target |
|---|---|
| `5_tables/tab_name.tex` | `study_1/pilot/tables/tab_name.tex` |
| `5_tables/appendix/tab_name.tex` | `study_1/pilot/tables/appendix/tab_name.tex` |
| `6_plots/plot_name.pdf` | `study_1/pilot/plots/plot_name.pdf` |
| `6_plots/appendix/plot_name.pdf` | `study_1/pilot/plots/appendix/plot_name.pdf` |

Setup: see `rules/rules.md` § Machine-Specific Paths and `reference/new_project.md` step 7.
