# Skill: Analysis Plan Planner

Expertise for designing and writing analysis plans and pre-registrations — before or during a study.

**Relationship to other skills:**
- `academic_conventions.md` covers the *process*: when to create a plan, which files to maintain, deviation tracking.
- `empirical-analysis` covers *methods*: estimation, packages, diagnostics, assumptions.
- **This skill** covers the *content design* of the plan: what to pre-specify, how to write estimating equations, how to structure hypotheses, pre-registration conventions.

**Load when:** starting a new study, writing a pre-registration, or deciding what to pre-specify vs. leave flexible.
**Skip when:** the analysis plan is finalised and the task is implementation or output.

---

## 1. What a Good Analysis Plan Achieves

A plan is a commitment device that separates confirmatory from exploratory inference. Its value comes from being:
- **Written before looking at outcome data** (for pre-registration; for mid-study revisions, document what was and wasn't known at revision time)
- **Specific enough to be falsifiable** — a reader should be able to tell whether a reported result matches or deviates from the plan
- **Complete enough to prevent researcher degrees of freedom** in the primary tests
- **Not over-specified** — exploratory analyses are fine; just label them as such

A common failure mode: plans that specify hypotheses but leave the estimating equation vague ("we will run regressions"), leaving room for undisclosed choices about controls, functional form, sample restrictions, and SE clustering.

---

## 2. Hypothesis Architecture

Structure hypotheses in three tiers. Pre-specify which tier each belongs to upfront.

### Primary hypotheses
- The study's core tests; corrections for multiple comparisons applied across these.
- Should be directional where theory is clear (more power; more commitment).
- One to three per study is typical; more dilutes confirmatory value.

### Secondary hypotheses
- Theoretically motivated but not the primary focus; apply a separate adjustment.
- Can include mechanism tests, pre-specified subgroup analyses, secondary outcomes.

### Exploratory analyses
- Hypothesis-generating; no confirmatory inference claimed.
- Must be labeled as exploratory in the plan and in the paper.
- Include them — suppressing null exploratories is its own form of bias.

**For each hypothesis, pre-specify:**
1. The testable prediction (direction and sign, not just "an effect exists")
2. The outcome variable and its operationalization
3. The estimating equation (see Section 3)
4. The statistical test and significance threshold
5. Whether it is part of a multiple-testing family (and which adjustment applies)

---

## 3. Estimating Equation Pre-Specification

Write out the equation explicitly. Vague language ("we control for demographics") is not a pre-specified equation.

### RCT (two-arm)

**Simple:**
```
Y_i = α + β T_i + γ X_i + ε_i
```
Pre-specify: which covariates X (pre-treatment only; avoid bad controls), whether β is ITT or TOT (and if TOT: the instrument), SE clustering level.

**ANCOVA (pre-registered covariate adjustment — preferred for efficiency):**
```
Y_i = α + β T_i + ρ Y_i,pre + γ X_i + ε_i
```
Pre-specify: that the pre-measure Y_i,pre is included, and that ρ is not interpreted causally.

**Blocked RCT — test whether blocking variable moderates the effect:**
```
Y_i = α + β₁ T_i + β₂ B_i + β₃ (T_i × B_i) + γ X_i + ε_i
```
Pre-specify: whether β₃ is a primary or secondary hypothesis; if secondary, whether it is included in the correction family.

**2×2 Factorial:**
```
Y_i = α + β₁ A_i + β₂ B_i + β₃ (A_i × B_i) + γ X_i + ε_i
```
Pre-specify: whether the interaction β₃ is a primary hypothesis or only the main effects are. A common mistake is running a factorial design but treating the interaction as exploratory after finding a null main effect.

**Within-subject / repeated measures:**
```
Y_ij = α + β T_ij + γ X_i + u_i + ε_ij     (with random intercept u_i)
```
Pre-specify: random effects structure (maximal vs. simplified), whether random slopes are included for treatment.

### Natural Experiment / Sharp RDD

```
Y_i = α + β D_i + f(R_i) + γ X_i + ε_i
```
Pre-specify: the bandwidth selection rule (CCT/IK optimal or fixed), kernel (triangular preferred), polynomial order (linear preferred unless bandwidth is large), covariates X (for robustness, not identification), whether the RD is geographic/administrative/cutoff-based.

For fuzzy RDD (D_i instrumented by crossing the cutoff):
- First stage: `D_i = π₀ + π₁ 1[R_i ≥ c] + f(R_i) + ξ_i`
- Reduced form and 2SLS both reported.

### Difference-in-Differences

**Two-way FE (classic 2×2):**
```
Y_it = β (Treat_i × Post_t) + α_i + δ_t + γ X_it + ε_it
```
Pre-specify: unit and time FE, clustering at the treatment unit level (not observation level), whether X_it includes time-varying controls (risk of bad controls).

**Staggered adoption:** Pre-specify which heterogeneity-robust DiD estimator to use before seeing data. Options (all valid; choose based on assumptions):
- Callaway & Sant'Anna (2021) — `did` package; preferred when treatment timing varies and parallel trends may differ by cohort
- Sun & Abraham (2021) — `fixest::sunab()` if using TWFE infrastructure
- Borusyak et al. (2024) — `did2s` package; imputation-based
Do NOT use vanilla TWFE with staggered timing as the primary estimator (negative weights problem).

**Event study (pre-trend test + dynamic effects):**
Pre-specify: the omitted period (typically t = −1), number of pre-periods reported, whether pre-trends will be tested formally (joint F-test or Roth 2022 sensitivity).

### Instrumental Variables

Pre-specify:
- The instrument Z and the exclusion restriction argument (why Z → Y only through T)
- First stage: `T_i = π₀ + π₁ Z_i + γ X_i + η_i`; report F statistic
- 2SLS equation: `Y_i = α + β T̂_i + γ X_i + ε_i`
- Whether LATE or ATE is the estimand, and for whom the LATE applies (complier characterization)
- The weak instrument test to be used (tF procedure, Lee et al. 2022 AER, not just F > 10)

### Panel Fixed Effects (Observational)

```
Y_it = β X_it + α_i + δ_t + γ Z_it + ε_it
```
Pre-specify: which FE dimensions (unit, time, unit×time, etc.), clustering level, whether X_it is potentially endogenous and how that is addressed.

---

## 4. Sample and Exclusion Rules

Pre-specify all sample restrictions before seeing outcomes:

- **Inclusion criteria:** who is eligible (age, geography, dates, data availability)
- **Exclusion criteria:** comprehension failures, attention checks, implausible responses — and the exact operationalization of each (e.g., "exclude if response time < 3 seconds", not "exclude obvious non-responders")
- **Outlier rules:** winsorize at p1/p99? Drop if |z| > 3? State the rule and the variable it applies to.
- **Missing data:** listwise deletion, imputation, or bounds? If imputation: pre-specify the method.
- **Pre-specified subgroups:** list subgroups that will be analyzed separately; note whether each is confirmatory (primary/secondary) or exploratory.

---

## 5. Multiple Testing Plan

Pre-specify the correction family structure:

1. **Define families:** which hypotheses are tested together? Corrections apply within a family. Primary hypotheses form one family; secondary another; subgroups often a third.
2. **Choose the method:** Bonferroni-Holm (FWER control, default) or Benjamini-Hochberg (FDR, when many outcomes). Pre-specify which.
3. **State which tests are in the family:** list them explicitly. Post-hoc additions are deviations.
4. **Threshold:** α = 0.05 unless powered for something stricter.

For exploratory analyses: explicitly state that no correction is applied and inference is descriptive only.

---

## 6. Power Analysis

Required for confirmatory hypotheses. Pre-specify and document assumptions:

- **Effect size:** justify the assumed effect size (prior literature, pilot, MDE-focused framing). Report as Cohen's d or unstandardized (the latter is more interpretable).
- **Minimum Detectable Effect (MDE):** often more honest than "we are powered at 80% for δ = 0.3" — report the smallest effect you can detect at 80% power given your N.
- **Design parameters:** two-tailed test, α = 0.05, assumed variance (for continuous DVs), proportion in each cell (for factorial designs).
- **Clustering:** if observations are clustered (classrooms, sessions), power drops. Use the intraclass correlation (ICC) to adjust: effective N = N / (1 + (m−1)×ICC) where m = cluster size.
- **Attrition buffer:** if you expect dropout, inflate target N and state the assumed attrition rate.

For within-subject designs: power is higher due to the correlation between repeated measurements; state the assumed within-subject correlation ρ. The variance of the difference is 2σ²(1−ρ).

---

## 7. Pre-Registration Conventions

### When to pre-register
- **Before data collection:** strongest form; covers both design and analysis choices.
- **Before analysis (data already collected):** still valuable; pre-specifies analysis choices while data is locked. Document that data were collected before registration.
- **Mid-study revision:** document clearly what data were available at revision time; distinguish new from revised hypotheses.

### OSF Pre-Registration (behavioral/social science standard)
Key fields in the standard AsPredicted or OSF template:
1. **Have data collection been completed?** (be accurate — reviewers and readers check)
2. **Main question / hypothesis:** one sentence per primary hypothesis
3. **Dependent variable(s):** operationalization, scale, how computed
4. **Conditions:** between/within, manipulation description
5. **Analyses:** the estimating equation(s), covariates, exclusion rules, MHT family
6. **Outliers and exclusions:** exact rules
7. **Sample size and power:** target N, MDE, power assumptions

Embargo option: you can register privately and embargo until publication.

### AEA RCT Registry (field experiments)
Additional required fields beyond OSF:
- Intervention start and end dates
- Primary and secondary outcomes distinguished
- Randomization unit (individual, village, school, etc.)
- Randomization method (simple, stratified, clustered)
- IRB approval reference
- Intervention description

### What to leave unspecified
Not everything needs to be pre-specified. Appropriate to leave open:
- Exploratory analyses (label them so)
- Exact covariate selection for robustness checks (specify the logic, not every combination)
- Model selection for auxiliary/secondary estimations
- Presentation choices (figure aesthetics, table layout)

---

## 8. Writing the analysis_plan.md

Suggested structure for the project document:

```
# Analysis Plan: [Study Name]

## Pre-Registration
- Platform: [OSF / AEA / None]
- Registration date: [date or "before data collection" / "before analysis"]
- Link: [URL or "embargoed until [date]"]

## Study Design
- Design type: [RCT / DiD / IV / RDD / Observational panel / Cross-sectional]
- Unit of randomization/observation: [individual / cluster / etc.]
- Sample: [inclusion/exclusion criteria]
- N target: [with power analysis summary]

## Hypotheses

### Primary
H1: [Direction + variable + condition]. Estimating equation: [write it out].
Correction family: Primary (Holm). α = 0.05.

### Secondary
H2–H4: [List with equations]
Correction family: Secondary (Holm, separate). α = 0.05.

### Exploratory
E1–En: [List. No correction. Descriptive only.]

## Estimating Equations
[Full equations for each model, not just the hypothesis. Include controls, FE, SE clustering.]

## Multiple Testing Plan
[Family structure: which hypotheses in which family, which method, which threshold.]

## Sample and Exclusion Rules
[Exact operationalization of all restrictions.]

## Power Analysis
[Assumed effect size, α, power, MDE, N, any clustering/attrition adjustments.]

## Robustness Checks (Pre-specified)
[List alternative specifications to be reported regardless of results.]
```

---

## 9. Common Mistakes

- **Vague outcome operationalization:** "we will measure decision quality" — write the exact formula.
- **Leaving the control set open:** "we will include relevant controls" — list them, or state the selection rule explicitly.
- **Calling subgroup analyses confirmatory without MHT correction:** either correct within the subgroup family or label as exploratory.
- **Undisclosed flexibility in exclusions:** "we will exclude poor-quality responses" — the rule must be written before seeing outcomes.
- **Treating the interaction in a factorial design as confirmatory post-hoc:** if you don't pre-specify the interaction as a primary test, it's exploratory.
- **Ignoring clustering in power:** if treatment is assigned at the group level, individual-level power calculations are badly anti-conservative.
- **Ambiguous pre-registration timing:** "before analysis" is weaker than "before data collection" — be explicit; reviewers and readers notice.

---

## Standard References

**Pre-registration & open science:**
Nosek et al. (2018, PNAS) — pre-registration; Wagenmakers et al. (2012) — distinction confirmatory vs. exploratory; Olken (2015, JEP) — pre-analysis plans in development economics

**Power analysis:**
Cohen (1988) *Statistical Power Analysis for the Behavioral Sciences*; Bloom (1995, Evaluation Review) — MDE framework; Duflo, Glennerster & Kremer (2008) ch. 3 in *Handbook of Development Economics* — power for RCTs

**Staggered DiD:**
Callaway & Sant'Anna (2021, JoE); Sun & Abraham (2021, JoE); Roth et al. (2023, JoE) — review with guidance on estimator choice

**Multiple testing:**
List et al. (2019, NBER) — MHT in field experiments; Romano & Wolf (2005, Econometrica) — stepdown procedure

**RDD:**
Cattaneo, Idrobo & Titiunik (2020, CUP) — bandwidth selection, validity checks
