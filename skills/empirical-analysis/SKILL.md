---
name: empirical-analysis
description: "Empirical research methods in R or Python: identification, estimation, standard errors, diagnostics, robustness, data validation, and interpreting and reporting results. ALWAYS use this skill when designing a study, running or interpreting a regression or any other statistical model, choosing standard errors or clustering, arguing identification (RCT, DiD, IV, RDD, panel fixed effects, matching), validating a dataset before analysis, checking a number before it goes into a paper, talk or proposal, or writing up results. Sub-files cover R (renv), Python (uv), plotting, marginaleffects, causal reasoning and research integrity. Not for LaTeX table formatting (research-paper), prose (author), writing a pre-registration or power analysis (analysis-plan), or project setup with no analysis."
---

# Skill: Empirical Analysis

**Purpose:** Identification-first empirical work: pick the design from the variation, estimate it correctly, check it, and claim only what the data support.
**Load when:** running or interpreting any statistical analysis, or deciding anything about identification, standard errors, samples or robustness.
**Skip when:** the task is pure table formatting, prose, or project organization with no analysis.
**Modifies behavior:** look at the data and assert its shape before modeling; run diagnostics before interpreting; tie every number to a script; match causal language to the design.

Project setup and the analysis-plan process: `reference/academic_conventions.md`. Writing the plan
itself (hypotheses, power, success criteria): the `analysis-plan` skill.

## Sub-files: load the one the task needs

| File | Load when |
|---|---|
| `r.md` | writing or running R; renv; a package will not install |
| `python.md` | writing or running Python; uv; encoding errors |
| `plotting.md` | any figure for a paper, talk or report |
| `marginaleffects.md` | interpreting model output: predictions, AMEs, interactions |
| `causal_reasoning.md` | the task IS causal reasoning (see below) |
| `research_integrity.md` | a number may enter a paper, talk, proposal or pre-registration; an LLM produces or codes data |

`causal_reasoning.md` is for auditing an identification argument, challenging a causal claim,
drawing a DAG, or checking causal wording in a draft. A passing mention of causation is not enough.

---

## Data object naming

Final analysis-ready datasets are `data_final_{study}_{phase}` (`data_final_survey_pilot`,
`data_final_survey_main`); intermediate ones `data_interim_{study}_{phase}_{step}`; subsets get a
suffix (`data_final_survey_main_wave2`). **Never** `df`, `data`, `data_clean`.
Why: generic names collide silently when two studies or phases are loaded in one session, and the
wrong dataset gets analyzed without any error. (Folder layout: `reference/new_project.md`.)

## Describe a derived variable by what was measured

- **"Imputed" means missing values were estimated.** Never use it for a deterministic recode (a
  qualification mapped to years of schooling, a rescaled Likert item). It claims numbers were made
  up, and a referee will ask which. Say *translates to / corresponds to / on the standard mapping*.
- **Lead with what the instrument recorded; let the derived number be the gloss.**

```
# WRONG
"Participants completed an average of 16 years of formal education."
# RIGHT
"The median participant holds a bachelor's degree, which the standard mapping translates into 16 years."
```

Why: prose in the derived units inherits every objection to those units (16 years in a classroom?),
and the data cannot settle them.

---

## Before any model: look, then assert

**Exploratory plots first.** Before any regression, plot outcome distributions by treatment arm, key
predictors (outliers, clumping, floor and ceiling effects), raw Y–X scatters for the central
relationships, and group trends for panel data. Keep them in their own script that runs before the
analysis stage (e.g. `2_3_eda_plots.R`), so there is a record of what the data looked like before
any model assumption was imposed. These plots are for the researcher, not the paper.

**Validate with assertions that stop the run.** After cleaning, before saving `data_final_*`:

1. Completeness: missing values per variable; none in required fields
2. Types: numerics are numeric, factor levels as expected, dates parse
3. Ranges: Likert 1–7, ages 18–99, shares 0–1
4. Uniqueness: one row per unit (or unit-period); no duplicate IDs
5. Assignment: expected group sizes; no unassigned units
6. Sample size: N matches the source, and every dropped row is accounted for

R: `stopifnot()`; Python: `assert`. Why: a warning scrolls past; a stopped pipeline gets fixed at the
source instead of surfacing weeks later as a strange coefficient.

---

## Identification: what variation identifies the effect?

| Design | Key assumptions | Diagnostics | Breaks when |
|---|---|---|---|
| RCT | random assignment, SUTVA | balance, attrition, compliance | spillovers, differential attrition |
| DiD | parallel trends, no anticipation | event study, pre-trends, placebo | time-varying confounders |
| IV | relevance, exclusion, monotonicity | first stage, tF, reduced form | weak instrument, exclusion fails |
| RDD | continuity at cutoff | density test, covariate smoothness | sorting, discrete running variable |
| Panel FE | strict exogeneity | within-R², pre-period placebo | time-varying unobservables, short T |
| Matching / IPW | unconfoundedness, overlap | overlap, post-match balance | unobserved confounders |

- **Experiments: always report ITT.** LATE/TOT only with a clear first stage and exclusion argument.
- **Balance by normalized differences, not p-values.** A p-value on balance mostly reports N.
- **IV:** F > 10 with a 1.96 critical value is anti-conservative; use the tF procedure (Lee et al. 2022).
- **Staggered DiD:** never vanilla TWFE as the primary estimator (negative weights). Use Callaway &
  Sant'Anna (`did`), Sun & Abraham (`fixest::sunab()`) or Borusyak et al. (`did2s`).
- Partial controls, colliders, mechanism vs confounder: `causal_reasoning.md`.

---

## Estimation defaults

**Standard errors**
- Cluster at the level of treatment assignment (Abadie et al. 2023). Why: that is where the
  correlated shocks come from; clustering lower overstates precision.
- Fewer than ~50 clusters: wild cluster bootstrap (R `fwildclusterboot`).
- Small samples without clustering: HC2 over HC1 (`estimatr::lm_robust`).
- A single time series: textbook Newey–West (short lag, normal critical values) over-rejects under
  persistence. Use fixed-b inference: Newey–West with lag ≈ 1.3·√T and fixed-b critical values, or
  the equal-weighted cosine estimator (Lazarus, Lewis, Stock & Watson 2018). For near-unit-root
  series (ρ ≳ 0.9) even these over-reject: use a longer series or local-to-unity corrections.

**Panel fixed effects:** `fixest::feols(y ~ x | unit + year, cluster = ~unit, data = ...)`. Prefer
FE over RE when unobserved heterogeneity plausibly correlates with the regressors.

**ANOVA and factorial designs:** `afex::aov_ez()` / `aov_car()` (sphericity correction; Type III
sums of squares with `contr.sum`, set explicitly). Partial η² via `effectsize::eta_squared()`;
post-hoc via `emmeans` with Holm or Tukey. ANOVA is a regression: switch to one when you need
covariates, unbalanced cells or continuous moderators.

**Mixed models:** `lme4::lmer()` for repeated measures, nesting or crossed random effects. Start
from the maximal random-effects structure the design justifies, simplify only on non-convergence
(Barr et al. 2013); p-values via `lmerTest`. Convergence: `bobyqa` optimizer, scale predictors,
drop random slopes last.

**Multiple testing:** pre-specify the families. Holm (FWER) by default; Benjamini–Hochberg (FDR)
for many exploratory outcomes; Romano–Wolf when outcomes are correlated.

**Effect sizes:** report in the outcome's own units first; standardized (Cohen's d,
`effectsize::cohens_d()`) as a supplement. Nonlinear models: average marginal effects
(`marginaleffects.md`).

**Mediation:** Imai et al. (2010), R `mediation`: report the ACME plus its sensitivity (the ρ at
which it reaches zero), and state that sequential ignorability is strong and untestable. Not Baron &
Kenny: low power and no inference on the indirect effect.

---

## Diagnostics checklist

- **Before:** descriptives and missingness; balance by arm; attrition by arm; power or MDE
- **Model:** residual plots; VIF > 10 as a flag (`car::vif()`); influence (Cook's distance, DFBETAS)
- **Robustness:** add/drop controls and FEs; alternative outcome measures; alternative samples
  (outliers, subgroups, winsorizing at 1/99); alternative SEs; a specification curve (Simonsohn et
  al. 2020) when the space of reasonable choices is large

---

## Reading and reporting results

For each analysis, hand over a short interpretation block before any prose is written:

1. **Estimated:** which hypothesis or plan item
2. **Specification:** model, controls, fixed effects, clustering, N
3. **Key results:** by condition or group, with effect sizes in real units
4. **Benchmark:** how the result compares with the theoretical or rational prediction
5. **Pattern:** what the results look like across conditions taken together
6. **Surprises:** reversals, non-linearities, nulls where effects were expected
7. **Connections:** how it bears on the other analyses in the paper
8. **Limitations:** caveats specific to this analysis

Why: without fields 5–7 the write-up reports numbers mechanically and the argument goes missing.

- **Compare pooled with per-condition results.** A pooled coefficient can hide a sign reversal.
- **Interpret from the formatted table the reader will see**, not raw console output: it catches
  wrong rounding and missing stars.
- **Never name a derived variable after one of its inputs** (`wtp_diff_benchmark`, not
  `wtp_rational`): the abbreviation confuses input and output in code, headers and axis labels.
- **Separate statistical from economic significance**; interpret coefficients in real units.
- **Own every number in the table.** If someone points at any number and asks "what is going on
  here?", have an answer or know how to get one. Two always matter: the sample size (a surprising N
  is almost never random: a merge, an implicit restriction, missing-data handling) and the pattern
  of coefficients across columns (controls that flip sign, estimates that move when a variable enters).
- **A falsification test is not a box to tick.** State which alternative story it tests, what
  estimate would be worrying, and what you expected. A noisy null is not evidence of validity unless
  the imprecision was expected.

---

## Verifying a result

- **Ask for a figure, not only a number.** "ATT = −0.73" is easy to accept; a plot of the wrong
  pattern is obvious. Raw group trends for DiD, binned scatters, residuals.
- **"Almost right" is wrong.** A number close to but not exactly what you expected means stop and
  find out why. In research a subtle bug does not crash; it becomes a published conclusion.
- **An internally consistent table is not a verified one.** A row that sums to its own N proves
  nothing when the N was computed from that row: the check compares a number with its own inputs.
  Recount every row against the data, not only the rows that look wrong. A table that is *almost*
  in the right order is the dangerous one: the first columns check out by eye and the errors sit in
  the displaced cells.
- **Generate tables by script; never transcribe them.** Order categories by an explicit level
  order, so a missing level counts 0 instead of shifting every later cell. (Classic failure: Likert
  categories sorted as text, so the labelled endpoint "1 = not at all" lands after "5".)
- **Get a check from outside the session.** After a self-contained analysis, run `/what-slipped`, or ask
  a fresh session to reproduce the headline number from the raw data and the plan alone. The full
  check for anything publication-bound is in `research_integrity.md`.

---

## Common pitfalls

This list grows. When Claude gets an analysis wrong, Claude proposes adding the mistake and the
rule that prevents it here, and adds it once the user agrees.

- **Bad controls:** never control for post-treatment variables or mediators (Angrist & Pischke 2009, 3.2.3).
- **Interactions in nonlinear models:** the coefficient on X₁×X₂ is not the interaction effect
  (Ai & Norton 2003); compute it with `marginaleffects`.
- **Collider bias:** conditioning on a common effect of treatment and outcome creates an association.
- **Partial confounder control can increase bias.** Biases carry signs and partly cancel: with two
  confounders biasing by +5 and −2 the net bias is +3; control for the −2 one and it becomes +5. So
  "we control for what we observe" does not mean "closer to the truth", and a coefficient that moves
  as control blocks are added is not converging. Sign the biases before claiming a direction.
- **Measurement error:** classical error in X attenuates; in Y it inflates SEs without bias (OLS).
- **Ecological fallacy:** group-level correlations are not individual effects.
- **Subgroups:** adjust for multiple comparisons or label them exploratory.
- **Forking paths:** Claude makes "one more specification" effortless. Pre-specify, report every
  specification run (or a specification curve), and log each deviation from the plan with its reason.

---

## Standard references

- **Econometrics:** Angrist & Pischke (2009) *Mostly Harmless Econometrics*; Wooldridge (2010)
  *Econometric Analysis of Cross Section and Panel Data*; Cameron & Trivedi (2005) *Microeconometrics*
- **Experiments:** Gerber & Green (2012) *Field Experiments*; Athey & Imbens (2017), *Handbook of
  Economic Field Experiments*, ch. 3
- **Methods:** Roth et al. (2023, JoE) DiD; Cattaneo, Idrobo & Titiunik (2020) RDD; Lee et al.
  (2022, AER) IV inference; Imbens & Angrist (1994) LATE; Imai et al. (2010) mediation; Barr et al.
  (2013) random effects; Abadie et al. (2023, QJE) clustering
- **Robustness:** Simonsohn et al. (2020) specification curve; Cinelli & Hazlett (2020) omitted-variable sensitivity

If you recommend a method and cannot name its standard reference, say the suggestion needs checking.

## Follow-up ideas

When a finding suggests a new research question, offer it in one line at a natural pause, not after
every output. If the user wants to keep it, append it to `claude/research_ideas.md` with title,
date, what prompted it, the idea (1–3 sentences) and a one-line feasibility note.
