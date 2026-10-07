# R for Empirical Analysis

**Load when:** writing or running R code, setting up or restoring `renv`, a package will not install or compile, or exporting results from R.
**Skip when:** the task is in Python, or is pure interpretation with no R code to write or run.

R setup, toolkit and Windows traps for empirical work. Load alongside `SKILL.md`.

---

## Running R from Claude Code on Windows

- **`Rscript` is usually not on PATH.** The R installer does not add it. Find the installed
  version under `C:\Program Files\R\` and call `"C:/Program Files/R/R-<version>/bin/Rscript.exe"`
  by full path, or ask the user to add that `bin` folder to PATH once.
- **Run scripts from files, not long `Rscript -e '...'` one-liners.** On Windows a `|` anywhere in
  the `-e` expression, even inside an R string, breaks the call with a misleading "path not found"
  error, because the command line treats it as a pipe.
- **A script must run top to bottom in a fresh R process** (`Rscript script.R`, started from the
  folder that holds `renv.lock`, so renv's `.Rprofile` switches the project library on). Why:
  interactive sessions carry objects from earlier runs, so a script can "work" only because
  something left over in memory filled a gap.

## Project setup with renv

`renv` records the exact package versions a project uses (in `renv.lock`), so the analysis can be
rerun later, or on another computer, with the same results.

1. **Windows needs Rtools** (cran.r-project.org/bin/windows/Rtools/, the version matching the R
   version). Without it, any package that must be compiled from source fails to install.
2. On a new project: `update.packages(ask = FALSE)`, then `renv::init()`, so the lockfile starts
   from current versions.
3. After installing a package: `renv::install("pkg")`, then `renv::snapshot()`.
4. After cloning or pulling a changed lockfile: `renv::restore()`.
5. **Commit** `renv.lock`, `.Rprofile`, `renv/activate.R`, `renv/settings.json`. **Never commit**
   `renv/library/` (it is the installed packages themselves, large and machine-specific).

- **Before writing code that uses a package, check that `renv.lock` records it.** If it is
  missing, say so and suggest `renv::install()` + `renv::snapshot()` first. Why: a package
  installed globally on this machine makes the code run here and fail for anyone else.
- Avoid superseded packages: `dplyr` over `plyr`, `tidyr` over `reshape2`, `readr` over
  `read.csv`. Where old code loads one, namespace-qualify calls (`dplyr::filter()`) to avoid clashes.

### renv traps

- **Load the project before installing or updating.** `renv::update(project = path)` without
  `renv::load(path)` first installs into the user library, not the project library; the `project =`
  argument only redirects where the lockfile is read. Use `renv::load(path); renv::update(prompt = FALSE)`.
- **`renv::snapshot()` records what is in the project library.** If that library is nearly empty
  (packages were installed elsewhere), snapshot strips the lockfile down to the few packages it
  sees. If `renv.lock` suddenly shrinks, restore it from git immediately, run `renv::restore()`,
  and snapshot again.
- **A lockfile is bound to its R version, not only its packages.** A minor R upgrade (e.g. 4.5 →
  4.6) can make old locked package sources impossible to compile (R 4.6 removed C entry points
  that older `dplyr` versions use), and no compiler flag fixes that. If `renv.lock`'s R version
  differs from the installed R, install the recorded R version side by side (Windows allows several)
  rather than forcing the restore.
- **Windows binaries exist only for current package versions.** Restoring an older lockfile means
  compiling from source, which needs Rtools. Budget time for it, or update the lockfile deliberately
  (see below).
- **Repository mismatch noise.** `renv::status()` may flag `[repo: RSPM != CRAN]` when a binary came
  from Posit's package manager; versions still match, and `renv::restore()` cleans it up.
- **`set.seed()` makes a simulation reproducible within one environment, not across them.** A
  package update can change the number or order of random draws, so a bootstrap or simulation
  table moves slightly, and a significance star can cross a threshold. Verify reproducibility by
  rerunning twice with any result cache disabled; never trust the `set.seed()` line alone.

---

## Paths: use `here::here()` for every file read and write

- **Never use bare relative paths for outputs** (`"5_tables/tab.tex"`). They resolve against the
  current working directory, which changes when a script calls `setwd()` or is run from elsewhere,
  and the file then lands silently in the wrong place.
- `here::here("5_tables", "tab.tex")` anchors to the project root (marked by a `.here` file or the
  `.Rproj` / git root) and returns an absolute path, wherever the script runs from.
- For a multi-study project, wrap the prefix once:
  `study1_path <- function(...) here::here("study_1", ...)`.
- Never hardcode a machine-specific path (`C:/Users/...`) in a script; put it in a gitignored
  `config_local.R` that the script sources if present.

## CSV output: European style

For German Excel (semicolon delimiter, decimal comma):

```r
readr::write_excel_csv2(data_final_survey_main, here::here("3_clean_data", "survey_main.csv"))
                               # with a byte-order mark: Excel then shows umlauts correctly
readr::write_csv2(...)         # the same without the mark, when only R reads the file
readr::read_csv2(path)         # reading our own CSVs back
```

Use `write_csv2`/`write_excel_csv2`, not `write_csv(delim = ";")`, which keeps the decimal point.
Third-party CSVs (downloads, exports from other tools) are read with their own format, usually
`readr::read_csv()`.

---

## Toolkit

| Package | Use for |
|---|---|
| `fixest` | panel FE, multi-way FE, clustered SEs, IV, `sunab()` event studies |
| `did` / `did2s` | staggered difference-in-differences |
| `lme4` / `lmerTest` | mixed models, crossed random effects |
| `afex` | factorial and repeated-measures ANOVA |
| `emmeans` | estimated marginal means, post-hoc contrasts |
| `car` | Type III tests, VIF |
| `sandwich` / `estimatr` | robust and clustered SEs outside `fixest` |
| `fwildclusterboot` | wild cluster bootstrap (few clusters) |
| `marginaleffects` | predictions, AMEs, interactions (see `marginaleffects.md`) |
| `rdrobust` | regression discontinuity |
| `MatchIt` / `cobalt` | matching and balance diagnostics |
| `mediation` | causal mediation (Imai et al.) |
| `sensemakr` | omitted-variable-bias sensitivity |
| `effectsize` | Cohen's d, η², standardized coefficients |
| `modelsummary` + `tinytable` | regression and summary tables to LaTeX |

### Package traps

- `lme4` convergence failures: `control = lmerControl(optimizer = "bobyqa")`, center and scale predictors.
- `fixest` clustering: `vcov = ~cluster_var` (the old `se = "cluster"` syntax is outdated).
- `afex`: set contrasts before fitting; `aov_ez()` needs factors, not numeric codes.
- **`modelsummary` output backend:** loading `kableExtra` (the tidyverse can pull it in) silently
  switches `modelsummary`'s backend. Load `library(tinytable)` **and** set
  `options(modelsummary_factory_default = "tinytable")` in the setup script, after the tidyverse.
- **`<` in a table note** renders as `¡` in LaTeX under the default font encoding. Replace it with
  `$<$` before saving (`modelsummary` writes the significance legend into the note).

---

## Updating packages deliberately

Lockfiles drift; letting them drift for years ends in a restore that compiles dozens of packages.
Update at milestones, not on a calendar: before submitting a paper or replication package, before
a new analysis phase, after upgrading R.

1. `renv::update(check = TRUE)` lists what is outdated without changing anything.
2. Update in batches, lowest risk first: utilities (`cli`, `rlang`), then output packages
   (`modelsummary`, `tinytable`), then estimation packages (`fixest`, `lme4`, `sandwich`) last,
   because those can change results.
3. After each batch, rerun the whole pipeline. After an estimation-package update, compare
   coefficients, SEs and p-values with the previous run: tiny floating-point differences are fine;
   anything substantive needs explaining before the update is kept.
4. `renv::snapshot()`, and commit `renv.lock` on its own: `chore: update renv lockfile (<batch>)`.

With co-authors, one person updates at a time; the others run `renv::restore()` after pulling.
