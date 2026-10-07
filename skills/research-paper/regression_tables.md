# Regression tables from R or Python

**Load when:** building or changing a regression table that a script writes to LaTeX
(modelsummary/tinytable in R, or a Python estimation package's table export).
**Skip when:** the table is descriptive (see `SKILL.md` § 3), or no table is being produced.

The general table rules in `SKILL.md` § 2 (title, notes, booktabs, labels, width) apply here too.
This file is the recipe for getting there.

---

## R: modelsummary with the tinytable backend

`modelsummary` (version 2.0 and later) produces `tinytable` tables, which write LaTeX in the
`tabularray` format. Keep that backend; do not switch to kableExtra. The paper's preamble needs
`\usepackage{tabularray}` and `\UseTblrLibrary{booktabs}`, plus `\usepackage{adjustbox}` for the
width wrapper below; the tinytable documentation lists any further lines its current version
needs.

### Minimal call

```r
stars <- c("*" = 0.1, "**" = 0.05, "***" = 0.01)   # one definition for the whole project

modelsummary::modelsummary(
  models,                  # named list: list("(1)" = m1, "(2)" = m2)
  stars    = stars,
  coef_map = coef_map,     # which coefficients, in which order, with which labels
  gof_map  = gof_map,      # which fit statistics
  escape   = FALSE,        # needed for LaTeX math in labels and notes
  title    = "Effect of the brochure on fund choice",
  notes    = "OLS. Standard errors clustered at the participant level in parentheses.",
  output   = "tinytable"
) |>
  tinytable::save_tt(here::here("5_tables", "tab_fund_choice.tex"), overwrite = TRUE)

finish_table(here::here("5_tables", "tab_fund_choice.tex"))   # label + width, see below
```

### The arguments that matter

- **`escape = FALSE` always.** Otherwise `$`, `\` and `_` in labels and notes are escaped and
  any LaTeX math breaks. The price: you escape special characters yourself, so a variable name
  in a note is written `w\\_auto` in the R string, or it turns into a subscript and the note's
  words collapse.
- **`coef_map`** is a named vector `c("term_in_model" = "Label shown")`. It decides which
  coefficients appear (unlisted ones are dropped) and their order. Order: main variables of
  interest, then other main effects and controls, then interactions (after every variable they
  involve), then the constant **last**.

  ```r
  coef_map <- c(
    "treatment"           = "Brochure",
    "age"                 = "Age",
    "treatment:financial" = "Brochure $\\times$ Financial literacy",
    "(Intercept)"         = "Constant"
  )
  ```

- **`gof_map`** chooses the fit rows and their labels:

  ```r
  gof_map <- tibble::tribble(
    ~raw,        ~clean, ~fmt,
    "nobs",      "N",    0L,
    "r.squared", "R$^2$", 3L
  )
  ```

  A model without a constant (`feols(y ~ 0 + x)`) reports an uncentred R², not comparable with
  the R² of models that have one; leave it out of those columns or say so in the note.
- **`coef_map` and `coef_rename` cannot be combined** (modelsummary stops with an error). When
  the same interaction is named differently across models (`x:treat` in one, `treat:x` in
  another), normalise the names in a `tidy_fun`, which runs before `coef_map`:

  ```r
  tidy_norm <- function(x, ...) {
    out <- broom::tidy(x, ...)
    out$term <- gsub("x:treat", "treat:x", out$term)
    out
  }
  modelsummary::modelsummary(models, tidy_fun = tidy_norm, coef_map = coef_map, ...)
  ```

- **Column group headers** with `tinytable::group_tt()` before saving. Column 1 is the row-label
  column, so data columns start at 2:

  ```r
  modelsummary::modelsummary(..., output = "tinytable") |>
    tinytable::group_tt(j = list("Saving" = 2:3, "Borrowing" = 4:5)) |>
    tinytable::save_tt(here::here("5_tables", "tab_name.tex"), overwrite = TRUE)
  ```

### Post-processing: label and width

tinytable writes no `\label`, so `\ref` cannot find the table, and it does not protect against
tables wider than the text. One helper, run after every `save_tt()`, fixes both. Keep it in the
project's table setup script:

```r
# Adds \label{tab:<name>} (derived from tab_<name>.tex) and an \adjustbox width wrapper
# that only shrinks tables wider than the text. Needs \usepackage{adjustbox}.
finish_table <- function(path, label = NULL) {
  tex <- readLines(path)
  if (is.null(label)) {
    label <- sub("^tab_", "tab:", tools::file_path_sans_ext(basename(path)))
  }
  # tabularray takes the label as an outer-spec key, right after caption={...}
  i_caption <- grep("^caption=\\{", tex)
  if (length(i_caption) == 1 && !any(grepl("^label=", tex))) {
    tex <- append(tex, paste0("label={", label, "},"), after = i_caption)
  }
  i_begin <- grep("\\\\begin\\{talltblr\\}", tex)
  i_end   <- grep("\\\\end\\{talltblr\\}", tex)
  tex[i_begin] <- paste0("\\adjustbox{max width=\\linewidth}{%\n", tex[i_begin])
  tex[i_end]   <- paste0(tex[i_end], "\n}")
  writeLines(tex, path)
}
```

The helper matches on the text tinytable writes, which can change between versions (Last
verified: 2026-10-07, modelsummary 2.6.0 and tinytable 0.16.0, where `stars = ...` also adds the
star legend as a table note by itself). After the first table, compile and check that
`Table~\ref{tab:...}` shows a number, not `??`.

## Python

Python's estimation packages export LaTeX too: `pyfixest` has `etable()`, and statsmodels'
`summary_col()` result has `.as_latex()`. Check the installed version's documentation for the
current arguments rather than relying on memory. Whatever the package, the output must meet the
same rules before it goes into the paper:

- written by the script to `5_tables/tab_<name>.tex` (the pipeline's tables folder), never
  pasted;
- booktabs rules (replace `\hline` with `\toprule` / `\midrule` / `\bottomrule` in a small
  post-processing step if the package writes `\hline`);
- the same star thresholds as the R tables, if a project uses both languages;
- coefficients ordered and labelled as above, constant last;
- title, `\label{tab:<name>}` and notes (specification, standard errors, star legend).

## Check before calling a table done

Compile the paper (or a small preview file that only `\input`s the tables) and look at the
table, not only the log:

1. the notes read as words, with no collapsed text or stray subscripts (escaping);
2. no column runs past the margin;
3. `\ref` resolves;
4. every number the text quotes from the table matches it, sign and rounding included.
