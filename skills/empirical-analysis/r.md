# Sub-skill: R (Empirical Analysis)

**Load when:** managing R packages, setting up renv, or debugging R environment issues.
**Skip when:** the R environment is already configured and the task is analysis or output.

R-specific setup and toolkit for empirical work. Load alongside `empirical-analysis/SKILL.md`.

---

## Project Setup

- Use `renv` for dependency management — on a **new project**, run `update.packages(ask = FALSE)` before `renv::init()` so the lock file captures current package versions. Then `renv::init()` at project start, `renv::snapshot()` after installing packages.
- Commit `renv.lock` and `renv/activate.R`; never commit `renv/library/`
- **Before suggesting code that uses a package, check `renv.lock` to verify it is recorded.** If it is missing, flag this explicitly and suggest `renv::install("package")` + `renv::snapshot()` before the user runs the code. Do not assume a package is available just because it is installed globally.
- Avoid deprecated packages: prefer `dplyr` over `plyr`, `readr` over `read.csv`, `tidyr` over `reshape2`
- When an existing project loads a deprecated package, namespace-qualify calls to avoid conflicts

---

## Working Directory and Output Paths

- **Never use bare relative paths for output saves.** Paths like `"5_tables/tab.tex"` resolve relative to the current WD — which can change during pipeline execution (e.g. an orchestrator script temporarily `setwd()`s into a subdirectory so `source()` calls resolve). After WD is restored, bare paths silently point to the wrong location.
- **Use `here::here()` for all output paths.** It anchors to the `.here` sentinel file (placed in the project root or analysis root) and always returns an absolute path regardless of WD. Example: `here::here("study_1", "pilot", "5_tables", "tab.tex")`.
- **Wrap in a phase-level helper** to avoid repeating the root prefix everywhere:
  ```r
  pilot_path <- function(...) here::here("study_1", "pilot", ...)
  ```
  Define this helper in both the orchestrator script (e.g. `run_pilot.R`) and the phase setup scripts (e.g. `4_0_Tables_Setup.R`, `5_0_Plots_Setup.R`). The orchestrator definition covers pipeline runs; the setup-script definitions cover standalone script execution (Mode 3 / interactive re-runs).
- **`source()` calls are different** — they do need WD to be in the right place, since R resolves `source("4_scripts/script.R")` relative to WD. Keep the WD switch for sourcing; use `here::here()` for everything else.

---

## Toolkit

| Package | When to use |
|---|---|
| `fixest` | Panel FE, multi-way FE, clustered SEs, IV — fast and flexible |
| `lme4` / `lmerTest` | Mixed models, crossed random effects, variance components |
| `afex` | Factorial ANOVA, repeated measures — correct Type III SS + GG |
| `emmeans` | Post-hoc comparisons, estimated marginal means, contrasts |
| `car` | Type III SS (Anova), VIF, Levene's test |
| `modelsummary` | Publication-quality regression/summary tables |
| `tinytable` | Default modelsummary backend (preferred over kableExtra for LaTeX output) |
| `kableExtra` | Table styling and column group headers for LaTeX/HTML output |
| `sandwich` / `estimatr` | Robust SEs (HC0-HC3), clustered SEs outside fixest |
| `marginaleffects` | Marginal effects, predictions, interaction effects in nonlinear models |
| `mediation` | Causal mediation analysis (Imai et al. framework) |
| `MatchIt` / `cobalt` | Propensity score matching, covariate balance diagnostics |
| `rdrobust` | RD estimation + inference, bandwidth selection |
| `fwildclusterboot` | Wild cluster bootstrap (few clusters) |
| `effectsize` | Cohen's d, eta-squared, standardized coefficients |
| `sensemakr` | Sensitivity analysis for omitted variable bias (Cinelli & Hazlett 2020) |

---

## Package Gotchas

- `lme4`: convergence failures — try `control = lmerControl(optimizer = "bobyqa")`, center/scale predictors
- `fixest`: cluster SE syntax changed in v0.10 — use `vcov = ~cluster_var` not `se = "cluster"`
- `afex`: set `contrasts` before fitting; `aov_ez()` requires factors as character/factor, not numeric
- `modelsummary` + `kableExtra` override: `tidyverse` loads `kableExtra`, which silently overrides `modelsummary`'s default backend. Fix: add `library(tinytable)` **and** `options(modelsummary_factory_default = "tinytable")` in `0_Setup.R` (after `library(tidyverse)`). Setting the option alone is not enough — tinytable must be explicitly loaded.
- `tinytable` S4 notes slot: `modelsummary()` auto-generates a significance legend as `tab@notes[[1]]`. Post-process with `gsub("<", "$<$", tab@notes[[1]])` before saving — the bare `<` renders as `¡` in LaTeX under OT1 encoding.
