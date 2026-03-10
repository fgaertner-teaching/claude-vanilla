# Sub-skill: Python (Empirical Analysis)

**Load when:** managing Python packages, setting up uv, or debugging Python environment issues.
**Skip when:** the Python environment is already configured and the task is analysis or output.

Python-specific setup and toolkit for empirical/data work. Load alongside `empirical-analysis/SKILL.md`.

---

## Project Setup

- Use `uv` for dependency management — `uv init` at project start, `uv add <package>` to install, `uv sync` to reproduce environment
- Commit `pyproject.toml` and `uv.lock`; never commit `.venv/`
- **Before suggesting code that uses a package, check `pyproject.toml` (or `uv.lock`) to verify it is recorded.** If it is missing, flag this explicitly and suggest `uv add <package>` before the user runs the code. Do not assume a package is available just because it is installed globally.

## Package Hygiene

- Prefer `pathlib` over `os.path`, `httpx` over `requests` for async, `ruff` over separate `flake8`/`black`
- Use `ruff` for linting and formatting (`ruff check`, `ruff format`)

## Toolkit

| Package | When to use |
|---|---|
| `polars` / `pandas` | Data wrangling — prefer `polars` for large datasets |
| `scikit-learn` | ML, prediction, preprocessing pipelines |
| `statsmodels` | Regression, time series, statistical tests |
| `linearmodels` | Panel FE, IV, between estimators (econometrics in Python) |
| `matplotlib` / `seaborn` | Visualization |
| `transformers` / `spacy` | NLP tasks |

## When Python vs R

- **Prefer Python for:** datasets >1M rows, ML/prediction, NLP, web scraping, API work, general scripting
- **Prefer R for:** econometrics, causal inference, ANOVA/mixed models, academic output (see `SKILL.md` + `r.md`)
