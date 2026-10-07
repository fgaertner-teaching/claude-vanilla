# Interpreting Models with marginaleffects

**Load when:** turning a fitted model into interpretable quantities: predictions, comparisons, average marginal effects, ATE/ATT/CATE, interaction effects in nonlinear models, hypothesis or equivalence tests on such quantities, in R or Python.
**Skip when:** the task is fitting the model (not interpreting it), or a linear model whose coefficients already answer the question.

`marginaleffects` works the same way in R and Python. Load alongside `SKILL.md`.
Reference: marginaleffects.com (free book, vignettes, case studies); Arel-Bundock, *Model to
Meaning: How to Interpret Statistical Models in R and Python* (CRC Press).

---

## Five questions for every interpretation

Answer them in this order, explicitly, before writing code:

1. **Quantity:** what estimand? A prediction, a comparison (difference, ratio), a slope, or a test.
2. **Grid:** evaluated where? The observed data, a counterfactual scenario, or a constructed grid (`datagrid()`).
3. **Aggregation:** over whom? Each unit, groups (`by =`), or a weighted average.
4. **Uncertainty:** delta method (default), robust or clustered (`vcov =`), or bootstrap (`inferences()`).
5. **Test:** against what? Zero, another estimate (`hypothesis =`), or an equivalence range (`equivalence =`).

Why: most misreadings of nonlinear models come from an unstated answer to 2 or 3 (an effect "at
the mean" reported as if it were the average effect).

For a conceptual question (which estimand fits?), answer with the five questions; for a syntax
question, give the code; for both, framing first, then code.

---

## Core functions

| Function | Returns | Averaged version |
|---|---|---|
| `predictions()` | predicted outcomes at given values | `avg_predictions()` |
| `comparisons()` | differences, ratios, odds ratios between counterfactuals | `avg_comparisons()` |
| `slopes()` | partial derivatives (marginal effects) | `avg_slopes()` |
| `hypotheses()` | tests on any of the above, or on coefficients | — |
| `datagrid()` | a grid of values to evaluate at | — |
| `plot_predictions()`, `plot_comparisons()`, `plot_slopes()` | the matching plots | — |
| `inferences()` | bootstrap or simulation-based intervals | — |

## Common patterns (R)

```r
mod <- glm(employed ~ treatment * female + age, data = data_final_survey_main, family = binomial)

avg_slopes(mod)                                              # AMEs on the probability scale
avg_comparisons(mod, variables = "treatment")                # ATE (risk difference)
avg_comparisons(mod, variables = "treatment", comparison = "ratio")   # risk ratio
avg_comparisons(mod, variables = "treatment", by = "female") # effect by group (CATE)
predictions(mod, newdata = datagrid(treatment = c(0, 1), age = 40))   # at chosen values

cmp <- avg_comparisons(mod, variables = "treatment", by = "female")
hypotheses(cmp, "b1 = b2")                                   # do the two group effects differ?

avg_slopes(mod, equivalence = c(-0.05, 0.05))                # equivalence test
avg_slopes(mod, vcov = ~school_id)                           # clustered SEs
avg_slopes(mod, vcov = "HC3")                                # robust SEs
```

## Python

```python
import statsmodels.formula.api as smf
from marginaleffects import avg_slopes, avg_comparisons

mod = smf.logit("employed ~ treatment * female + age", data=df).fit()
avg_slopes(mod)
avg_comparisons(mod, variables="treatment", by="female")
```

---

## Key concepts

- **Interactions: never read the interaction coefficient directly** in a nonlinear model; it is not
  the interaction effect (Ai & Norton 2003). Compute comparisons or slopes `by =` the moderator.
- **One function, many treatment effects.** ATE (`avg_comparisons`), ATT (restrict to the treated
  or use `wts =`), CATE (`by =`), risk differences, risk ratios, odds ratios.
- **G-computation:** fit the outcome model, then `avg_comparisons()` over the counterfactual grid,
  with delta-method or bootstrap intervals (see the "G-computation" chapter on marginaleffects.com).
- **`datagrid()`** sets the named variables and holds the rest at their mean or mode;
  `grid_type = "balanced"` gives every combination of factor levels, which suits factorial designs.

## Mixed models: `re.form` is a substantive choice

With `lme4`/`glmer` models, `marginaleffects` warns that it accounts only for uncertainty in the
fixed effects. **Do not silence the warning by switching `re.form` without deciding what you
want to estimate.** For nonlinear mixed models (logit, Poisson) the two settings give materially
different average effects:

- `re.form = NULL` (default): **cluster-specific** effects, conditional on each cluster's random
  effect, then averaged. Answers "the effect within a typical cluster". Usually smaller.
- `re.form = NA`: **population-averaged** effects, integrating over the random-effect
  distribution. Answers "the effect on the population probability". Usually larger.

Both are valid; they answer different questions. Choose the estimand, pass `re.form` explicitly,
and rerun every downstream test after a switch: SEs and significance can change too. A switch made
"just to silence the warning" can move published effects by several percentage points.

---

## When to look things up

The function reference on marginaleffects.com lists every argument; the book's chapters cover
predictions, comparisons, slopes, hypothesis tests, interactions, categorical predictors,
experiments, G-computation, uncertainty, and machine-learning models. Check the documentation
before using an argument you are not certain of: the interface has changed across versions.
