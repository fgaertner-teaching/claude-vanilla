# Python for Empirical Analysis

**Load when:** writing or running Python for data work, setting up or syncing a `uv` project, an import or encoding error appears, or exporting results from Python.
**Skip when:** the task is in R, or is pure interpretation with no Python code to write or run.

Python setup, toolkit and Windows traps for empirical work. Load alongside `SKILL.md`.

---

## Environments: `uv` with one `.venv` per project

`uv` installs Python itself and each project's packages into a `.venv` folder inside the project,
and records exact versions in `uv.lock`, so the analysis reruns later with the same packages.

| Task | Command |
|---|---|
| install uv (once, Windows) | `winget install --id=astral-sh.uv -e` |
| start a project | `uv init` (creates `pyproject.toml`, `.python-version`) |
| add a package | `uv add pandas` (installs and records it) |
| reproduce the environment | `uv sync` (after cloning or pulling a changed lockfile) |
| run a script | `uv run python 4_scripts/analysis.py` |
| pin a Python version | `uv python install 3.12`, then `uv python pin 3.12` |

- **Run through `uv run`, not bare `python`.** `uv run` always uses this project's `.venv`. Bare
  `python` on Windows may be the Microsoft Store placeholder, another project's environment, or a
  system Python without the packages, and the error then points at the wrong cause.
- **Never `pip install` into a global Python.** Use `uv add`. Why: a package that exists only on
  this machine makes the code run here and fail everywhere else.
- **Before writing code that imports a package, check `pyproject.toml`.** If it is missing, say
  so and suggest `uv add <package>` first.
- **Commit** `pyproject.toml`, `uv.lock`, `.python-version`. **Never commit** `.venv/` (large,
  machine-specific, rebuilt by `uv sync`).
- **A virtual environment left active from another project is ignored by `uv`** (it prints a
  warning that `VIRTUAL_ENV` does not match). Read that warning: it means a bare `python` in this
  shell would use the wrong environment. Run from the project folder with `uv run`, or
  `uv run --directory <project>`.

---

## Windows traps

- **Console encoding.** Python's console output on Windows may use a legacy code page (cp1252),
  which crashes or garbles on umlauts and other non-ASCII text. Put this at the top of any script
  that prints text from data, `.bib` files or APIs:

  ```python
  import sys
  sys.stdout.reconfigure(encoding="utf-8")
  ```

- **Always pass `encoding="utf-8"`** to `open()`, `read_text()`, `write_text()`, `pd.read_csv()`.
  Why: the Windows default is not UTF-8, so the same script reads a file correctly on a Mac and
  garbles it on Windows.
- **Use `pathlib.Path`** and forward slashes; never build paths by string concatenation with `\`.
  Never hardcode `C:/Users/...`: put machine-specific paths in a gitignored config file.
- **Never write a file inside the expression that reads it.**
  `open(p, "w").write(f(open(p).read()))` truncates `p` before reading it, and silently leaves it
  empty. Read fully into a variable, then write.

## CSV output: European style

For German Excel (semicolon delimiter, decimal comma):

```python
data_final_survey_main.to_csv(
    path, sep=";", decimal=",", index=False,
    encoding="utf-8-sig",   # byte-order mark: Excel then shows umlauts correctly
)
pd.read_csv(path, sep=";", decimal=",")   # reading our own CSVs back
```

With the `csv` module, open the file with `newline=""`, otherwise Windows writes an extra blank
line after every row:

```python
import csv
with open(path, "w", encoding="utf-8-sig", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=fields, delimiter=";")
    writer.writeheader()
    writer.writerows(rows)   # format floats first: f"{x:.4f}".replace(".", ",")
```

Third-party CSVs (downloads, exports from other tools) are read with their own format, usually
the pandas default (`,` and `.`).

---

## Toolkit

| Package | Use for |
|---|---|
| `pandas` / `polars` | data wrangling; `polars` for large data |
| `pyfixest` | fixed effects, clustered SEs, IV, DiD (a port of R's `fixest`) |
| `statsmodels` | OLS/GLM with formulas, tests, time series |
| `linearmodels` | panel and IV estimators |
| `marginaleffects` | predictions, AMEs, interactions (see `marginaleffects.md`) |
| `scikit-learn` | prediction and machine learning |
| `matplotlib` / `seaborn` | figures (see `plotting.md`) |
| `ruff` | linting and formatting (`uv run ruff check`, `uv run ruff format`) |

```python
import pyfixest as pf
fit = pf.feols("y ~ treatment | unit + year", data=data_final_panel_main, vcov={"CRV1": "unit"})
fit.summary()
```

**Python or R?** Python for large data, scraping, APIs, text and machine learning, general
scripting. R for econometrics, mixed models and ANOVA, and LaTeX tables, where its packages are
more mature (see `r.md`). For a deterministic data-preparation step whose output enters a paper, a
second implementation in the other language is a strong check (`research_integrity.md`).

---

## Updating packages deliberately

Update at milestones (before submission, before a new analysis phase, after a Python upgrade), not
continuously:

1. `uv pip list --outdated` shows what is behind.
2. `uv lock --upgrade-package <pkg>` for one package, or `uv lock --upgrade` for all; then `uv sync`.
3. Rerun the whole pipeline and compare key results with the previous run.
4. Commit `uv.lock` on its own: `chore: update uv lockfile (<what>)`.

With co-authors, one person updates at a time; the others run `uv sync` after pulling.
