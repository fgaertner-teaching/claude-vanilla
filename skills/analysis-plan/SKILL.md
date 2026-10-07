---
name: analysis-plan
description: "Analysis plans and pre-registrations: hypotheses, estimating equations, sample and exclusion rules, multiple-testing families, power analysis and sample size, and success criteria written before results are seen. ALWAYS use this skill before writing or reviewing a pre-registration (OSF, AsPredicted, AEA registry) or an analysis_plan.md, before a power analysis or sample-size justification, and before writing any criterion that decides whether a result counts: a threshold, a success or failure criterion, an expected result written down before a run. Use it when starting a study or planning analysis before outcomes exist. Not for carrying out a finished plan (empirical-analysis) or writing the paper (author)."
---

# Skill: Analysis Plan

**Purpose:** Design what a study commits to before seeing outcomes: hypotheses, equations, samples, tests, power, and criteria that can actually fail.
**Load when:** starting a study, writing or reviewing a pre-registration or analysis plan, sizing a sample, or writing down what result would count as success.
**Skip when:** the plan is final and the task is running it or formatting its output.
**Modifies behavior:** every confirmatory test gets a written equation, sample rule and threshold before data; every criterion is checked for whether it could fail.

Where the neighbors fit: `reference/academic_conventions.md` covers the *process* (when to make a
plan, the deviation log); `empirical-analysis` covers *methods* (estimation, diagnostics); this
skill covers the *content* of the plan.

---

## 1. What a plan is for

A plan is a commitment device that separates confirmatory from exploratory inference. It works
only if it is:

- **Written before outcome data are seen.** For a mid-study revision, record what was and was not known then.
- **Specific enough to be falsifiable:** a reader can tell whether a reported result followed it.
- **Complete for the primary tests:** no open choices about controls, functional form, sample or clustering.
- **Not over-specified:** exploratory analyses are fine if labeled as such.

The usual failure: hypotheses stated precisely, equation left vague ("we will run regressions"),
which leaves every consequential choice open.

## 2. Hypotheses in three tiers

- **Primary:** the core tests; usually one to three; directional where theory is clear;
  multiple-testing correction across them.
- **Secondary:** theoretically motivated but not central (mechanisms, pre-specified subgroups,
  secondary outcomes); a separate correction family.
- **Exploratory:** hypothesis-generating, no confirmatory inference, labeled as exploratory in the
  plan and the paper. Report them anyway: suppressing null exploratory results is its own bias.

For each primary and secondary hypothesis, pre-specify: (1) the prediction with its sign, (2) the
outcome and exactly how it is computed, (3) the estimating equation, (4) the test and threshold,
(5) its multiple-testing family.

## 3. Write the estimating equation out

"We control for demographics" is not a pre-specified equation. Templates:

```
RCT              Y_i  = α + β T_i + γ X_i + ε_i
RCT, ANCOVA      Y_i  = α + β T_i + ρ Y_i,pre + γ X_i + ε_i          (more efficient)
2×2 factorial    Y_i  = α + β₁ A_i + β₂ B_i + β₃ (A_i × B_i) + γ X_i + ε_i
Within-subject   Y_ij = α + β T_ij + γ X_i + u_i + ε_ij               (random intercept u_i)
Sharp RDD        Y_i  = α + β D_i + f(R_i) + γ X_i + ε_i
DiD, 2×2         Y_it = β (Treat_i × Post_t) + α_i + δ_t + γ X_it + ε_it
IV               T_i  = π₀ + π₁ Z_i + γ X_i + η_i ;   Y_i = α + β T̂_i + γ X_i + ε_i
Panel FE         Y_it = β X_it + α_i + δ_t + γ Z_it + ε_it
```

What to pre-specify with each:

- **RCT:** covariates (pre-treatment only), ITT or TOT (and the instrument for TOT), SE level;
  for ANCOVA, that ρ is not interpreted causally.
- **Factorial:** whether the interaction β₃ is a primary test. Deciding after a null main effect
  that the interaction was the point makes it exploratory.
- **Within-subject:** the random-effects structure, and whether treatment gets a random slope.
- **RDD:** bandwidth rule (data-driven optimal or fixed), kernel (triangular), polynomial order
  (linear unless the bandwidth is wide), covariates for robustness only. Fuzzy RDD: first stage on
  1[R ≥ c], and both reduced form and 2SLS reported.
- **DiD:** unit and time FE, clustering at the treated unit, any time-varying controls (they risk
  being bad controls). **Staggered adoption:** name the heterogeneity-robust estimator now
  (Callaway & Sant'Anna; Sun & Abraham; Borusyak et al.), never vanilla TWFE as primary. Event
  study: the omitted period (usually −1), the number of pre-periods shown, and the pre-trend test.
- **IV:** the exclusion argument in words, the estimand (LATE, and for whom), the weak-instrument
  procedure (tF, Lee et al. 2022; not just F > 10).
- **Panel FE:** the FE dimensions, the clustering level, and how a possibly endogenous X is handled.

## 4. Sample and exclusion rules

Write each rule as an operation, before outcomes are seen:

- **Inclusion:** who is eligible (age, region, dates, data availability).
- **Exclusions:** attention checks, comprehension failures, implausible responses, each as a rule
  ("response time under 3 seconds", not "obvious non-responders").
- **Outliers:** the rule and the variable (winsorize at 1/99? drop |z| > 3?).
- **Missing data:** listwise deletion, bounds, or imputation (and which method).
- **Subgroups:** each one listed and tiered (primary, secondary or exploratory).
- **Did the instrument actually operate?** When each observation depends on something working
  (a device, an API, an LLM's tool call, a treatment that must be seen), make "it worked" a
  validity condition with a pilot-tested threshold. A response that is well-formed is not the same
  as one where the manipulation reached the person; logging non-engagement as a valid response pays
  for data the confirmatory test cannot use.

## 5. Measure broadly, claim narrowly

- **Admit a measure if it needs no new arm.** A measure computed from data the design already
  collects costs almost nothing and is easily ignored if irrelevant; discovering later that a needed
  measure was never collected can mean collecting again. A measure that needs a new condition, new
  instrument or new data round competes for budget and belongs in its own design.
- **Declare every measure confirmatory or exploratory before data.** The tier split, not
  restraint, is what stops a broad catalogue becoming a fishing licence. Only confirmatory additions
  enlarge the multiple-testing family.
- **Do the coverage review just before the expensive act** (data collection, the main run).
- **At write-up, select.** Pre-registration constrains what you may *claim*, not what deserves a
  section: report every registered outcome, but build the argument from the few that carry it and
  put the rest in an appendix.

## 6. Multiple testing

Name the families (primary, secondary, subgroups), the method for each (Holm by default;
Benjamini–Hochberg for many exploratory outcomes), every test in each family, and α (0.05 unless
powered for stricter). Exploratory analyses: state that no correction is applied and inference is
descriptive. A test added later is a deviation.

## 7. Power and sample size

Required for every confirmatory hypothesis:

- **Effect size:** justify it (prior studies, pilot); prefer unstandardized units to Cohen's d.
- **Report the MDE** (smallest effect detectable at 80% power with your N): more honest than
  "powered for d = 0.3".
- **Design parameters:** two-sided test, α, assumed variance, allocation across cells.
- **Clustering:** effective N = N / (1 + (m − 1) × ICC), m = cluster size. Treatment assigned by
  group with power computed per individual is badly over-optimistic.
- **Within-subject:** state the assumed correlation ρ; the variance of a difference is 2σ²(1 − ρ).
- **Attrition:** inflate the target N by the assumed dropout rate and state it.

**Simulation and LLM-agent designs have several n's; name each with the claim it carries.**
(1) individual decisions or calls: cheap and rarely binding; (2) independent runs of the whole
system: the real n for claims about outcomes or distributions, usually small; (3) system size
(agents, horizon): a parameter, not a sample size, so vary it as robustness and never report it as
power; (4) models: tiny, non-random and non-independent (see `skills/empirical-analysis/research_integrity.md`),
so say plainly that no power calculation applies. **Resolution is not power:** a threshold
expressed as a share of N agents cannot be resolved below 1/N, and a value at that floor is
censored, not estimated.

## 8. Criteria that can fail

A success criterion, threshold or expected result is a measurement, and it can be built so that it
passes whatever happens.

- **Write the prediction into a file before the run, and commit it.** A prediction that exists
  only in the conversation was never made: written down afterwards, it cannot be told apart from
  one invented afterwards.
- **Ask: if the claim is exactly true, what value does this statistic take?** If the answer clears
  the bar regardless of the alternative, the bar is decorative. Prefer statistics whose expected
  value under the hypothesis can be computed in advance, and write that value beside the bar.

  ```
  # WRONG: a level bar for a rate claim
  Claim: attendance falls by at most 1% per week.  Bar: week-26 attendance >= 70% of baseline.
  (Exactly 1% per week gives 0.99^26 = 0.77: pass. A 25% drop in week 1, then flat: 0.75: also pass.)
  # RIGHT: a statistic of the claimed quantity
  Bar: the largest single-week decline <= 1%.  Expected under the claim: <= 0.010.
  ```

- **Ask where the yardstick comes from.** If the values used to grade a mechanism are derived from
  that same mechanism (labels from the classifier being validated, valuations taken from the very
  bids an auction uses), the grade is fixed by construction. Name the yardstick's source in the plan.
  Where you can, run yardstick and mechanism on a few hand-made inputs: zero disagreement means the
  instrument cannot grade this mechanism; add a case where the two genuinely differ to show it can.
- **In a simulation, a tolerance needs a named, measured source of variation** (variation across
  seeds, usually) before it is set; a run that settles to a fixed value has none.
- **Flaw found after freezing but before the scored run?** Add the corrected criterion as a dated
  amendment, labeled as written with hindsight, and report the original criterion's verdict
  unchanged beside it. Silently replacing it destroys the pre-registration.

## 9. Pre-registration

**Timing:** before data collection (strongest); before analysis of collected data (still useful;
say the data existed); a mid-study revision states what data were available. "Before analysis" is
weaker than "before collection", and readers check.

**OSF / AsPredicted fields:** data collected yet? · one sentence per primary hypothesis · dependent
variables and how they are computed · conditions · analyses (equations, covariates, families) ·
outliers and exclusions · sample size and its justification. Registrations can be embargoed.

**AEA RCT Registry (field experiments) adds:** intervention dates · primary vs secondary outcomes ·
randomization unit and method (simple, stratified, clustered) · IRB reference · intervention description.

**Fine to leave open:** exploratory analyses (labeled), the exact covariate sets of robustness
checks (state the logic), auxiliary model selection, presentation.

## 10. `analysis_plan.md` skeleton

```
# Analysis Plan: <study>
## Registration      platform, date (before collection / before analysis), link or embargo
## Design            type, unit of randomization and observation, sample rules, target N
## Hypotheses        Primary H1..: sign + variable + condition, equation, family (Holm), α
                     Secondary H..: same, separate family
                     Exploratory E..: no correction, descriptive
## Equations         every model in full: controls, FE, clustering
## Multiple testing  families, method, threshold
## Sample rules      every inclusion, exclusion, outlier and missing-data rule as an operation
## Power             effect size and source, α, power, MDE, N, clustering and attrition
## Criteria          each threshold with its expected value under the hypothesis
## Robustness        alternative specifications reported regardless of results
```

## 11. Common mistakes

- **Vague outcome:** "decision quality" instead of its formula.
- **Open control set:** "relevant controls" instead of a list or a selection rule.
- **Subgroups called confirmatory without a correction family.**
- **Exclusion rules written after seeing outcomes.**
- **Parse-validity taken for construct-validity:** a well-formed answer from an instrument that
  did not operate (§ 4).
- **A factorial interaction promoted to primary after the fact.**
- **Power computed per individual for a clustered design.**
- **Unclear registration timing.**

## References

Nosek et al. (2018, PNAS) pre-registration; Olken (2015, JEP) pre-analysis plans in economics;
Cohen (1988) power; Bloom (1995) MDE; Duflo, Glennerster & Kremer (2008) power for RCTs;
Callaway & Sant'Anna (2021), Sun & Abraham (2021), Roth et al. (2023) staggered DiD; List et al.
(2019) and Romano & Wolf (2005) multiple testing; Cattaneo, Idrobo & Titiunik (2020) RDD.
