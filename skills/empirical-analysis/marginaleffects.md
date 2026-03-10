# Sub-skill: marginaleffects (Empirical Analysis)

**Load when:** computing predictions, comparisons, slopes, marginal effects, ATE/ATT/CATE, hypothesis tests on model output, or using `marginaleffects` functions.
**Skip when:** the task is model estimation (not interpretation), or the user is not using the marginaleffects package.

R and Python package for interpreting statistical models. Load alongside `empirical-analysis/SKILL.md`.

**Primary reference:** https://marginaleffects.com (free book, case studies, vignettes)
**Book:** Arel-Bundock (2026), *Model to Meaning: How to Interpret Statistical Models in R and Python*, CRC Press.

---

## Core framework: Five questions for every interpretation task

1. **Quantity**: What estimand? (predictions, comparisons, slopes, or tests)
2. **Predictors (Grid)**: Where to evaluate? (observed values, counterfactual scenarios, balanced grids via `datagrid()`)
3. **Aggregation**: Over whom? (unit-level, group means with `by=`, weighted averages)
4. **Uncertainty**: Which inference method? (delta method, robust SE, bootstrap, Bayesian via `vcov`/`inferences()`)
5. **Test**: What hypothesis? (null tests, equivalence, pairwise contrasts via `hypothesis`/`equivalence` arguments)

Apply this framework to structure every interpretation response.

---

## Request classification

- **Conceptual** (which estimand? how to interpret?) → explain using the five-question framework
- **Implementation** (function syntax, arguments) → provide code with the correct function
- **Mixed** → start with conceptual framing, then provide code

---

## Core functions (R)

| Function | Purpose | Avg variant |
|----------|---------|-------------|
| `predictions()` | Predicted values / expected outcomes at specific points | `avg_predictions()` |
| `comparisons()` | Counterfactual comparisons, ATE, risk ratios, odds ratios | `avg_comparisons()` |
| `slopes()` | Marginal effects / partial derivatives | `avg_slopes()` |
| `hypotheses()` | Hypothesis tests and equivalence tests on any quantity | — |
| `datagrid()` | Construct prediction grids (typical, counterfactual, balanced) | — |
| `plot_predictions()` | Plot predicted values | — |
| `plot_comparisons()` | Plot comparisons | — |
| `plot_slopes()` | Plot marginal effects | — |
| `inferences()` | Alternative inference: bootstrap, simulation, conformal | — |

Python equivalents use the same names via `import marginaleffects as me`.

---

## Common patterns

### Average marginal effects
```r
mod <- glm(y ~ x1 + x2, data = df, family = binomial)
avg_slopes(mod)  # AME on probability scale
```

### Predicted probabilities at specific values
```r
predictions(mod, newdata = datagrid(x1 = c(0, 1), x2 = median))
```

### Average treatment effect (comparison)
```r
avg_comparisons(mod, variables = list(treatment = c(0, 1)))
```

### Risk ratio
```r
avg_comparisons(mod, variables = list(treatment = c(0, 1)), comparison = "ratio")
```

### Conditional effects (interactions)
```r
# Effect of x1 at different levels of x2
slopes(mod, variables = "x1", by = "x2")
```

### Hypothesis testing on quantities
```r
# Test whether two group effects differ
cmp <- avg_comparisons(mod, variables = "treatment", by = "group")
hypotheses(cmp, "b1 = b2")
```

### Equivalence test
```r
avg_slopes(mod, equivalence = c(-0.1, 0.1))
```

### Clustered / robust standard errors
```r
avg_slopes(mod, vcov = ~cluster_id)          # clustered
avg_slopes(mod, vcov = "HC3")                # robust
```

---

## Key concepts

- **Comparisons** generalise treatment effects: ATE (`avg_comparisons`), ATT (with `wts`), CATE (with `by`), risk differences, risk ratios, odds ratios — all from the same function.
- **G-computation** for causal inference: fit model → `avg_comparisons()` with counterfactual grid → delta method or bootstrap CI. See `experiments` and `gcomputation` chapters at marginaleffects.com.
- **Interactions**: never interpret interaction coefficients directly. Use `predictions()`, `comparisons()`, or `slopes()` with `by=` to get interpretable quantities.
- **`datagrid()`** controls the grid: `datagrid(x1 = c(0, 1))` sets x1 to specific values, other variables at mean/mode. Use `grid_type = "balanced"` for factorial designs.

---

## When to consult marginaleffects.com

- Specific chapter topics: framework, predictions, comparisons, slopes, hypothesis testing, interactions, categorical predictors, experimental designs, G-computation, uncertainty quantification, MRP, machine learning models
- Full function reference with all arguments
- Case studies with worked examples
