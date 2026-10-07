---
name: project-organizer
description: "Script pipelines and paper file layout: numbered scripts, raw -> interim -> clean data folders, one main file that runs everything, setup/content/save scripts, where a script, dataset or output belongs, output file naming, mapping tables and figures to paper sections, and the LaTeX/Overleaf project layout (main.tex, preamble, sections, tables/, figures/, labels, the blind-review toggle, the submission/ folder). ALWAYS use this skill when structuring or restructuring an analysis pipeline, adding a pipeline stage or script, deciding which folder or stage a file belongs in, or laying out a paper's LaTeX project. Not for writing the code inside one script (coder, empirical-analysis), formatting a single table or figure (research-paper), or deciding what to analyse (analysis-plan)."
---

# Skill: Project Organizer

**Purpose:** Give an analysis project a pipeline anyone can rerun from raw data with one command, and a paper whose every table and figure traces back to the script that made it.
**Load when:** structuring a script pipeline, adding or moving a stage, deciding where a file belongs, laying out a LaTeX/Overleaf project, or mapping outputs to paper sections.
**Skip when:** the structure is settled and the task is writing or running the analysis inside it.
**Modifies behavior:** Claude places every script, dataset and output by the stage rules below, keeps the main file and `claude/pipeline_map.md` in step with the scripts, and names each output after what it shows in the paper.

Distinct from `research-paper` (how one table or figure looks) and `analysis-plan` (what to
analyse). The empty skeleton of a new project is created by `/newproject`
(`reference/new_project.md`); this skill says what the folders mean.

---

## The pipeline in one picture

```
analysis/
  0_shared/0_Setup.R        libraries, paths, helpers every stage uses      (in git)
  1_raw_data/               the data as received, never changed             (not in git)
  2_interim_data_steps/     steps on the way: merged, reshaped, half-clean  (not in git)
  3_clean_data/             the analysis-ready data the results read        (not in git)
  4_scripts/                every script, numbered by stage                 (in git)
  5_tables/                 generated .tex tables (+ appendix/)             (not in git)
  6_plots/                  generated figures (+ appendix/)                 (not in git)
  7_r_objects/              saved models and data objects (.rds, .RData)    (not in git)
  Data_Analysis_Main_File_OPEN_ME_FIRST.R    runs everything, top to bottom
```

The numbers make a plain folder listing show the order the data flows in, so anyone who opens
the folder sees the pipeline before reading a line of code.

**Python:** the same folders, `.py` scripts, `7_objects/` for saved objects (`.parquet`,
`.pkl`), and a main file `Data_Analysis_Main_File_OPEN_ME_FIRST.py` run with
`uv run python analysis/Data_Analysis_Main_File_OPEN_ME_FIRST.py`. Make each Python script
self-contained (it reads its inputs from files and writes its outputs to files); the main file
runs them in order with `runpy.run_path(...)`.

## Six rules, each with its reason

1. **Raw data is read-only.** Every change (a renamed variable, a dropped respondent, a recode)
   happens in a script that writes to `2_` or `3_`. *Why:* the original stays available to rerun
   from, and every change is written down where a referee or co-author can read it. A hand edit
   in Excel is invisible and cannot be repeated.
2. **Data flows forward only.** A script reads from earlier folders and writes to its own.
   Results scripts read `3_clean_data/` or saved objects, never `1_raw_data/`. *Why:* otherwise
   the order the scripts must run in is hidden, and a fix to the cleaning silently fails to reach
   the results.
3. **Interim or clean?** Ask: *would a results script read this file?* Yes: `3_clean_data/` (the
   dataset the analysis uses, one per unit of analysis). No: `2_interim_data_steps/` (anything
   that is only a step on the way and can be regenerated).
4. **One main file runs everything.** `Data_Analysis_Main_File_OPEN_ME_FIRST.R` sources the
   scripts in order (template: `reference/template_main_file.R`). *Why:* replication is one
   command, and running it top to bottom in a fresh R session catches objects that only existed
   in someone's workspace. After a change, rerun from the main file, not only the edited script.
5. **Everything generated can be deleted and rebuilt.** `2_`, `3_`, `5_`, `6_` and `7_` are
   outputs of the scripts: they stay out of git and must reappear when the main file runs. If
   deleting one would lose work, that work is in the wrong place.
6. **Hand-made inputs are not outputs.** A codebook, a crosswalk you typed, a questionnaire, a
   list of sample exclusions: written by a person, read by a script, produced by no script. Commit
   them in a tracked folder (e.g. `analysis/0_shared/`) unless they hold personal data. *Test:*
   search the scripts for the file name. If a script reads it and none writes it, it is an input.

## Script numbering: stage, position, role

`S_N_Name.R`: `S` is the stage, `N` the position inside the stage.

| Stage | Does | Typical scripts |
|---|---|---|
| 1 | load raw data | `1_0_Load_Data_Setup.R`, `1_1_Load_Data.R` |
| 2 | clean, build variables | `2_1_Clean_Data.R`, `2_2_Clean_Data_Save_Objects.R`, `2_3_EDA_Plots.R` |
| 3 | estimate | `3_1_Results_Descriptives.R`, `3_2_Results_Main_Analysis.R`, `3_3_Results_Robustness.R` |
| 4 | tables | `4_0_Tables_Setup.R`, `4_2_Tables_Main_Analysis.R` |
| 5 | figures | `5_0_Plots_Setup.R`, `5_2_Plots_Main_Analysis.R`, `5_5_Plots_Export.R` |

Inside each stage, three roles:

- **`S_0_..._Setup.R`**: constants and helpers for that stage only (significance stars and
  goodness-of-fit rows for tables; theme and sizes for figures). *Why:* a helper defined once
  cannot drift between two tables.
- **`S_N_....R`**: the content.
- **`S_M_..._Save_Objects.R`**: writes the stage's results to `7_r_objects/`, so a later stage,
  or a reader without the raw data, can load instead of recompute.

Stages 3, 4 and 5 reuse the same section words (`Descriptives`, `Main_Analysis`, `Robustness`),
so the table in `4_2_Tables_Main_Analysis.R` is fed by `3_2_Results_Main_Analysis.R`.

Every content script opens with what it needs and what it makes:

```r
# Depends on: 4_0_Tables_Setup.R (stars, gof_map)
# Needs in memory: main_models (from 3_2_Results_Main_Analysis.R)
# Writes: 5_tables/tab_main_effects.tex
```

*Why:* a new session, or a co-author, can run or change one script without reading the others.

**Adding a script.** Take the next free number in its stage, and in the same change add its
`source()` line to the main file and its row to `claude/pipeline_map.md`. If it must run between
two existing scripts, renumber, and update the main file, the map and every `Depends on:` header
in the same change (search for the old names). A stale number misleads more than a renumbering
costs.

## Several studies

Several studies, or one study with a pilot and a main wave: each gets its own pipeline,
`analysis/study_1/pilot/` and `analysis/study_1/main/`, each with folders `1_` to `7_` and a
`run_pilot.R` / `run_main.R` entry point. The main file sources the `run_*.R` files; comparisons
across studies live in `analysis/cross_study/`; shared helpers stay in `analysis/0_shared/`.
Start single-study unless a second study is already planned: splitting later is a mechanical
move, while nesting a lone study adds a folder layer to every path for nothing.

## `claude/pipeline_map.md`

One table, one row per script:

```markdown
| Script | Reads | Writes | Does |
|---|---|---|---|
| 2_1_Clean_Data.R | 1_raw_data/survey.csv | 3_clean_data/survey_clean.rds | drops speeders, builds indices |
```

Read it before working on the pipeline instead of opening scripts one by one, and update it in
the same change that adds, removes or renames a script. *Why:* one file orients a fresh session
in seconds; a stale map is worse than none, because it is trusted.

## Outputs and the paper

**Map outputs to sections before producing them.** Keep `claude/output_spec.md`, one row per
table or figure: file name, LaTeX label, paper section, what it shows. Write the row before the
code. *Why:* no orphan tables nobody cites, no section left without its evidence.

**Naming.** The same descriptor in the file name, the label and the spec, so one search finds
the script, the file and every place the paper cites it:

- Tables: `5_tables/tab_<descriptor>.tex`, cited as `\label{tab:<descriptor>}`
- Figures: `6_plots/fig_<descriptor>.pdf`, cited as `\label{fig:<descriptor>}`
- Appendix outputs: the same names inside an `appendix/` subfolder.

**Never edit a generated table or figure by hand.** The next run overwrites the edit, silently.

```
# WRONG: fix a coefficient label in the output
edit 5_tables/tab_main_effects.tex
# RIGHT: fix it where it is made, then rerun
edit 4_0_Tables_Setup.R (coefficient labels) -> rerun the main file
```

## The paper's LaTeX project

How outputs reach Overleaf: `reference/overleaf_conventions.md`. The layout:

```
main.tex          \documentclass, \input{preamble}, \input{sections/...}
preamble.tex      packages and custom commands only
sections/         one .tex per section (introduction.tex, data.tex, results.tex, ...)
tables/           generated tables, same file names as in 5_tables/
figures/          generated figures, same file names as in 6_plots/
library.bib
submission/       what was sent to and received from journals (below)
```

- `\input{tables/tab_main_effects.tex}`: the path ends in the exact file name the script wrote.
- Tables and figures should arrive by a sync step, not by hand. If they are uploaded by hand,
  re-upload after every rerun, or the paper shows numbers the code no longer produces.

### Blind-review toggle

Journals want one version with author names and one without. One switch in `main.tex`:

```latex
\newif\ifblindreview
\blindreviewtrue   % \blindreviewfalse for the version with names

\ifblindreview
  \title{Paper Title}
  \author{}
\else
  \input{titlepage}
\fi
```

`titlepage.tex` holds only the author block (names, affiliations, ORCID, e-mail,
acknowledgements). Abstract, JEL codes and keywords stay in `main.tex`, because both versions
need them. Before sending the blind PDF, look for names elsewhere: acknowledgements in a
footnote, "our earlier work", the PDF's document properties.

### Submission folder

```
submission/
  <journal>/
    first_submission/     the PDF sent, cover letter, reviewer reports received
    first_rnr/            revised manuscript, reply to reviewers
    second_rnr/
  <next_journal>/
```

One round, one folder: what was sent, what came back and the reply sit together, so a later
round can see exactly what a referee saw.

## Signs the structure has drifted

- A script in stage 3 or later reads `1_raw_data/`.
- A file in `5_tables/` that no script writes, or a table in the paper missing from
  `output_spec.md`.
- The main file does not run start to finish in a fresh session.
- `pipeline_map.md` lists a script that no longer exists, or misses one that does.

When you see one, tell the user and propose the fix; do not restructure silently, because moving
files breaks paths in scripts and in the paper.
