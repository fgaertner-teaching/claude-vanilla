# Skill: Empirical Analysis

**Load when:** running regressions, causal analysis, or any econometric task.
**Skip when:** the task is table formatting, paper writing, or project organisation with no new analysis.

Domain expertise for empirical economic analysis — identification, estimation, diagnostics. For general principles see global `CLAUDE.md`. For project setup and output formatting see `reference/academic_conventions.md`. For language-specific tooling load `r.md` (R) or `python.md` (Python) as needed.

---

## Data Object Naming

Final analysis-ready datasets must be named `data_final_{study}_{phase}`, e.g.:
- `data_final_experiment1_pilot`
- `data_final_experiment1_main`
- `data_final_experiment2_pilot`

**Never** use generic names like `df`, `df_long`, `data`, or `data_clean`. Generic names cause silent collisions when multiple studies or phases are loaded in the same environment.

The same logic applies to intermediate objects: use `data_interim_{study}_{phase}_{step}` for anything saved to `2_interim_data_steps/`. Objects saved to `3_clean_data/` are always `data_final_*`.

For sub-datasets derived from the final dataset (e.g. a final-round dataset), suffix with the scope: `data_final_experiment1_pilot_finalround`.

---

## EDA Workflow

**Always start with exploratory plots before any quantitative analysis.**

Before running regressions, produce at minimum:
1. Outcome distributions by treatment arm
2. Key predictor distributions — check for outliers, clumping, ceiling/floor effects
3. Raw Y–X scatter plots for the central relationships
4. Panel trends or time series if applicable

EDA plots are for the researcher, not the paper. They belong in a dedicated `2_3_EDA_Plots.R` script (or equivalent) that runs *before* stage 3 (formal analysis), so there is a paper trail of what the data look like before any modeling assumptions are imposed.

---

## Data Validation

**Run programmatic checks on every dataset before analysis — not just visual EDA.**

After data cleaning and before formal analysis, include a validation step that checks:
1. **Completeness** — missing values per variable, unexpected NAs in required fields
2. **Type integrity** — numeric columns are numeric, factors have expected levels, dates parse correctly
3. **Range plausibility** — values within expected bounds (e.g., Likert 1–7, ages 18–99, probabilities 0–1)
4. **Uniqueness constraints** — one row per subject (or per subject-round), no duplicate IDs
5. **Treatment assignment** — expected group sizes, no unassigned observations

Implement as assertions that **stop the pipeline** on failure, not warnings that scroll past. In R: `stopifnot()` or `assertthat::assert_that()`. In Python: plain `assert` or `pandas` `.pipe()` with validation functions.

Place validation in the cleaning script (stage 2), after the final dataset is assembled but before it's saved as `data_final_*`. This catches issues at the source, not downstream when a regression produces weird results.

---

## Identification & Causal Inference

**Design selection:** What variation identifies the causal effect? → Choose strategy accordingly.

**RCT** (Gerber & Green 2012)
- Assumptions: random assignment, SUTVA, no attrition bias
- Diagnostics: balance tables, attrition analysis, compliance rates
- Fails when: differential attrition, non-compliance, spillovers

**Difference-in-Differences** (Roth et al. 2023)
- Assumptions: parallel trends, no anticipation, stable composition
- Diagnostics: pre-trend plots, event study, placebo tests
- Fails when: time-varying confounders, compositional changes

**Instrumental Variables** (Angrist & Pischke 2009; Imbens & Angrist 1994)
- Assumptions: relevance, exclusion restriction, monotonicity (LATE)
- Diagnostics: tF procedure (Lee et al. 2022 AER) — F-dependent adjusted critical values; F>10 with cv=1.96 is anti-conservative. Also: reduced form, overid tests
- Fails when: weak instruments, exclusion violation

**Regression Discontinuity** (Cattaneo et al. 2020)
- Assumptions: continuity of potential outcomes at cutoff, no manipulation
- Diagnostics: McCrary density test, covariate smoothness, bandwidth sensitivity
- Fails when: manipulation/sorting, discrete running variable

**Panel Fixed Effects** (Wooldridge 2010, ch. 10)
- Assumptions: strict exogeneity (no feedback), time-invariant unobservables
- Diagnostics: Hausman test, within-R², pre-treatment falsification
- Fails when: time-varying unobservables, Nickell bias (short T)

**Matching/IPW** (Imbens 2004; Ho et al. 2007)
- Assumptions: CIA/unconfoundedness, common support
- Diagnostics: propensity score overlap, balance after matching, sensitivity analysis (Rosenbaum bounds)
- Fails when: unobserved confounders

For experiments (primary domain): always report ITT. Report LATE/TOT only with clear first-stage and exclusion-restriction argument.

---

## Statistical Methods & Estimation

### ANOVA & Factorial Designs
- Use `afex::aov_ez()` or `afex::aov_car()` for factorial and repeated-measures ANOVA — handles sphericity (GG correction) and Type III SS correctly by default
- Contrast coding: set contrasts explicitly (`contr.sum` for Type III SS); document the coding scheme
- Report partial eta-squared (η²_p) for effect sizes; use `effectsize::eta_squared()`
- ANOVA is a special case of regression — switch to regression when covariates, unbalanced designs, or continuous moderators are needed
- For post-hoc comparisons: `emmeans` with Tukey or Holm adjustment

### Mixed / Multilevel Models
- Use `lme4::lmer()` when: repeated measures, nested/clustered data, crossed random effects, interest in variance components
- Always specify the maximal random-effects structure justified by design (Barr et al. 2013), then simplify if convergence fails
- Report fixed effects, random effects SDs, ICC; use `lmerTest` for p-values (Satterthwaite)
- Convergence issues: try `bobyqa` optimizer, scale predictors, simplify random slopes

### Fixed Effects (Panel)
- Use `fixest::feols()` for panel FE — fast, flexible, built-in clustering
- Prefer FE over RE when unobserved heterogeneity likely correlates with regressors (Hausman test)
- Cluster SEs at the level of treatment assignment (Abadie et al. 2023)
- `fixest` syntax: `feols(y ~ x | fe1 + fe2, cluster = ~cluster_var, data = df)`

### Robust Standard Errors & Clustering
- Default: cluster at treatment assignment level; if only one level of clustering, use `sandwich::vcovCL` or `fixest` built-in
- For few clusters (<50): use wild cluster bootstrap (`fwildclusterboot`)
- HC1 (Stata default) vs HC2/HC3: prefer HC2 for small samples (`estimatr::lm_robust`)

### Multiple Hypothesis Testing
- Pre-specify primary vs. secondary/exploratory outcomes
- Bonferroni-Holm (FWER control): `p.adjust(p, method = "holm")` — default choice
- Benjamini-Hochberg (FDR control): when many outcomes, exploratory context
- Romano-Wolf (randomization-based FWER): `rwolf` package, accounts for dependence across outcomes

### Effect Sizes
- Cohen's d: `effectsize::cohens_d()` — between-group standardized difference
- Partial eta-squared: ANOVA effect sizes
- Standardized regression coefficients: scale variables or use `effectsize::standardize_parameters()`
- Marginal effects for nonlinear models: `marginaleffects::avg_slopes()`

### Mediation Analysis
- Use the Imai et al. (2010) framework (`mediation` package) — allows nonlinear models, provides sensitivity analysis
- Baron & Kenny (1986) approach: outdated, low power, no inference on indirect effect — avoid
- Always report ACME + sensitivity analysis (ρ at which ACME = 0)
- Sequential ignorability is strong and untestable — state this explicitly

---

## Diagnostics Checklist

### Pre-Analysis
- [ ] Descriptive statistics (distributions, outliers, missingness patterns)
- [ ] Balance checks across treatment arms (normalized differences, not just p-values)
- [ ] Attrition analysis (differential by treatment?)
- [ ] Power analysis (ex ante or minimum detectable effect)

### Model Diagnostics
- [ ] Residual plots (linearity, homoscedasticity, normality for small samples)
- [ ] Multicollinearity: VIF > 10 is a flag (`car::vif()`)
- [ ] Influential observations: Cook's distance, DFBETAS
- [ ] For ANOVA: sphericity (handled by `afex`), normality of residuals

### Post-Analysis Robustness
- [ ] Alternative specifications (add/drop controls, different FEs)
- [ ] Alternative DVs (transformations, alternative measures)
- [ ] Alternative samples (drop outliers, subgroups, winsorize at 1%/99%)
- [ ] Different SEs (robust, clustered at different levels, bootstrap)
- [ ] Specification curve analysis (Simonsohn et al. 2020) for comprehensive robustness

---

## Verification Rules

**Never trust numbers alone. Always request a figure.**

A table that says "ATT = -0.73" is easy to accept uncritically. A visualization showing the wrong pattern is immediately obvious. Request plots proactively — not just for publication, but to understand what the code is computing.

- For treatment effects: plot raw distributions, event-study figures, or binned scatter plots alongside point estimates
- For regressions: plot residuals, leverage, and the key relationship visually
- For panel/DiD: plot raw group trends, not just the estimated treatment effect
- "Almost right" is never good enough — if a number is close but not exact to what's expected, stop and investigate. In research, unlike software, a subtle bug produces a wrong conclusion in a published paper.

---

## Common Pitfalls

- **Bad controls:** Don't control for post-treatment variables or mediators (Angrist & Pischke 2009, ch. 3.2.3)
- **Interpreting interactions:** The coefficient on X₁×X₂ is NOT the interaction effect in nonlinear models (Ai & Norton 2003); use `marginaleffects` for correct marginal interaction effects
- **p-hacking / researcher degrees of freedom:** Pre-register, report all specifications, use specification curves
- **Ecological fallacy:** Group-level correlations ≠ individual-level effects — match analysis level to theory
- **Measurement error:** Classical error in X → attenuation bias; error in DV → inflated SEs but no bias (under OLS)
- **Collider bias:** Conditioning on a collider (common effect of treatment and outcome) induces spurious association
- **Multiple comparisons in subgroup analyses:** Always adjust or frame as exploratory

---

## Standard References

**Causal inference & econometrics:**
Angrist & Pischke (2009) *Mostly Harmless Econometrics*; Angrist & Pischke (2014) *Mastering 'Metrics*; Wooldridge (2010) *Econometric Analysis of Cross Section and Panel Data*; Imbens & Angrist (1994, Econometrica) — LATE framework; Cameron & Trivedi (2005) *Microeconometrics*

**Experiments:**
Gerber & Green (2012) *Field Experiments*; Athey & Imbens (2017) ch. 3 in *Handbook of Economic Field Experiments*

**Specific methods:**
Roth et al. (2023, JoE) — DiD review; Cattaneo et al. (2020, CUP) — RD; Lee et al. (2022, AER) — valid IV inference, tF procedure; Imai et al. (2010, Psych Methods) — causal mediation; Barr et al. (2013, JML) — random effects structure; Abadie et al. (2023, QJE) — when to cluster

**Robustness & reporting:**
Simonsohn et al. (2020, Nature Human Behaviour) — specification curve; Cinelli & Hazlett (2020, JRSS-B) — omitted variable bias sensitivity

## Research Follow-Up Ideas

When discussing substantive findings — after presenting results, after a robustness check reveals something unexpected, or after discussing implications — proactively suggest follow-up research questions if they arise naturally. Frame as "here's something that might be interesting to explore" rather than a recommendation.

Save ideas to `claude/research_ideas.md` in the project. Format:

```
## [Short idea title]
- **Date:** YYYY-MM-DD
- **Prompted by:** [which finding or discussion]
- **Idea:** [1–3 sentences]
- **Feasibility:** [one-line assessment — data availability, method complexity, scope]
```

Do this only at natural pause points, not after every minor output. The user decides whether to keep, develop, or discard each idea.
