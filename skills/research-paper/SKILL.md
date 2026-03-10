# Skill: Research Paper

**Load when:** creating or modifying tables, figures, or any LaTeX output for a paper.
**Skip when:** running analysis only, with no paper output needed in this step.

Domain expertise for academic paper writing and presentation — LaTeX tables, figures, formatting. For project setup and analysis conventions see `reference/academic_conventions.md`. For empirical methodology see `skills/empirical-analysis/SKILL.md`. For Overleaf folder structure, path convention, table sandbox, and sync pipeline see `reference/overleaf_conventions.md`.

**Results narrative check:** Before writing analysis output (tables, plots, or narrative text) for a new experiment × phase, check whether the corresponding `{phase}_results.tex` exists in the Overleaf folder. If it does not, suggest creating it first. See `reference/overleaf_conventions.md` § Results Narrative Files for the full convention (tone, audience, required section structure).

---

## General Table Conventions

- **Every table must have a title.** Pass it via the `title` argument in `modelsummary` or equivalent. No table should be output without one.
- **Every results table must also have notes.** Notes go below the table and must cover: model specification, standard error type/clustering, and the star threshold legend. Descriptive tables need notes only when aggregation level or variable scaling is non-obvious.
- **Captions must be self-contained:** only reference what is visible in the table. If a concept is required for understanding but not shown, add it to the table — do not patch it into the caption. A caption that needs to explain table structure is a sign the table structure is incomplete.
- Caption/title placement: **above** the table (`caption.placement = "top"` in xtable).
- Formatting: `\hline` rules only (no vertical lines). 2 decimal places for continuous, 0 for counts.
- Table notes: self-contained, placed **outside** the tabular environment as `\parbox{\textwidth}{...}` between `\end{tabular*}` and `\end{table}`. Each note should specify the aggregation level, variable scale, and any special columns.
- Observation level: demographics always participant-level. DVs in repeated-measures designs: choose one level but report both N-participants and N-observations.

## Sample Characteristics Table (Table 1)

- Continuous variables: columns N, Mean, SD, Min, Max. SD over SEM always.
- Categorical variables: integrate into the same table as indented sub-rows, separated by `\midrule` with a **sub-header row** showing "N" and "%" to replace the continuous column headers. This avoids needing to explain dual column meanings in the caption.
- Categorical levels should use human-readable labels (e.g., "Yes"/"No", not 0/1; "Male"/"Female", not coded values).

## Treatment-Level Descriptive Tables

- Columns: Treatment, N, Mean, SD, Median.
- For bounded variables (e.g., 0-100 scales), add a threshold share column (e.g., ">25%") instead of Min/Max.
- Threshold column note should be specific: name the variable, the aggregation unit (participants/observations), and the threshold value.
- Group rows by treatment factor (e.g., "Investing" / "Borrowing" sub-headers).

## tinytable (LaTeX output)

- **Escape underscores in `notes` strings.** In `tinytable::tt()`, the `notes` argument is rendered inside tabularray's note field, which processes text as LaTeX. Bare underscores (e.g., `sample_size`) are interpreted as subscript commands, causing surrounding text to collapse with no spaces. Always escape: `w\\_auto\\_design`, `pred\\_bayes`, etc. This applies to all variable names, column names, or file names referenced in note text.
- **Table width:** Before writing table-generation code, count the planned columns. If ≥7 columns, plan for overflow protection upfront — not as a post-hoc fix. After `save_tt()`, post-process the `.tex` to wrap `talltblr` in `adjustbox` (`adjustbox` is more compatible with tabularray than `\resizebox`):
  ```r
  tex <- readLines("5_tables/my_table.tex")
  i1  <- grep("\\\\begin\\{talltblr\\}", tex)
  i2  <- grep("\\\\end\\{talltblr\\}", tex)
  tex[i1] <- paste0("\\begin{adjustbox}{max width=\\linewidth}\n", tex[i1])
  tex[i2] <- paste0(tex[i2], "\n\\end{adjustbox}")
  writeLines(tex, "5_tables/my_table.tex")
  ```
- **Verify compiled output before committing.** After generating `.tex` files with `save_tt()`, compile the document and check: (1) note text has no collapsed words or garbled subscripts, (2) no columns overflow the page margin. Fix any issues in the R source before committing.

## Recipes

As you develop recurring patterns (e.g., regression table formatting, specific ggplot themes), save them as `.md` files in a `recipes/` subfolder here. This keeps implementation details separate from the skill's core principles.
