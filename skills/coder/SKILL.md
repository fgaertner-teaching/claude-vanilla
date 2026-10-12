---
name: coder
description: "Writing, running and debugging R and Python scripts for research: silent failures, hard-coded numbers, scripts that cannot be re-run from raw data, results the user checks by their outputs instead of by reading code, inspecting data files with code, Windows traps (Git Bash and PowerShell, UTF-8, CRLF line endings, paths, the Python Store stub, Rscript not on PATH), long and background jobs, finding the cause of a bug before fixing it. ALWAYS use this skill before writing, editing or debugging any R, Python, shell or PowerShell script, and before running a script, a long job or a batch operation, even when no code is edited. Not for choosing statistical methods (empirical-analysis), formatting tables and figures (research-paper), package setup with renv or uv (empirical-analysis r.md / python.md), or prose-only edits."
---

# Skill: Coder

**Purpose:** Make the code Claude writes for a researcher correct, re-runnable from raw data, and
checkable by its outputs, and avoid the traps of running it on Windows.
**Load when:** writing, editing, running or debugging any script or command that computes or
changes something.
**Skip when:** pure discussion, prose-only edits, reading code without running or changing it.
**Modifies behavior:** every script reports what it read, did and wrote; assertions stop a wrong
run; numbers come from code, never from typing; commands are Windows-safe; a bug's cause is found
before it is fixed.

**Sub-files — open the one that fits before the step it governs, not after it fails:**

- **`windows.md`** — before running commands or writing files on Windows: which shell runs your
  command, encodings, line endings, paths, quoting, calling Python and R from a shell.
- **`long_runs.md`** — before starting anything that may run longer than ~2 minutes, in the
  background, unattended or overnight, and when waiting on or stopping a running job.
- **`debugging.md`** — when investigating an error, a crash, a failing check, or a result that
  looks wrong.

Not here: package setup (renv, uv), the R and Python toolkits, CSV
export, and the Rscript-on-PATH and console-encoding traps are in `skills/empirical-analysis/r.md`
and `skills/empirical-analysis/python.md`; load the one for the language you write. Pipeline
folder layout: the `project-organizer` skill.

---

## 1. The user checks outputs, not code

The user may not read R or Python. So the code has to prove itself in what it prints and writes:
someone who never opens the script must be able to tell whether it did the right thing.

**End every script with a run report.** Print, in plain words: which files it read (path, rows,
columns), what each major step did to the row count (each merge, filter, reshape), which files it
wrote, and the key numbers. *Why:* the report is what the user checks; a script that prints nothing
can only be trusted by reading it.

```r
# Report what this run did --------------------------------------------------
message("Read   ", raw_path, ": ", nrow(raw), " rows, ", ncol(raw), " columns")
message("After merging firm data: ", nrow(merged), " rows (expected ", nrow(raw), ")")
message("Dropped ", n_implausible, " rows with implausible ages")
message("Wrote  ", out_path)
```

**Assertions stop a wrong run; warnings scroll past.** After every merge, filter or reshape, assert
what must be true — row count, unique key, no missing values in key variables, plausible ranges —
with a message that says what was expected. `stopifnot()` in R; `assert` or `raise` in Python.
*Why:* a run that stops tells the user something broke; a run that finishes with wrong numbers
tells them nothing. (The full checklist for the final dataset is in `empirical-analysis`.)

```r
# WRONG — a duplicated firm_id in firm_data silently multiplies rows
merged <- dplyr::left_join(survey, firm_data, by = "firm_id")

# RIGHT
stopifnot("firm_id is not unique in firm_data" = !anyDuplicated(firm_data$firm_id))
merged <- dplyr::left_join(survey, firm_data, by = "firm_id")
stopifnot("merge changed the row count" = nrow(merged) == nrow(survey))
```

In pandas, `survey.merge(firm_data, on="firm_id", how="left", validate="m:1", indicator=True)`
raises when `firm_id` is duplicated in `firm_data` (the right side), and the `_merge` column
counts what did not match.

**Prove a check can fail.** A check that reports "0 problems" is evidence only if it reports a
problem when there is one. When you add a check, run it once on input with a planted defect of the
real kind (a duplicated ID, a missing value, a wrong type), see it fail, then remove the plant.
*Why:* a broken check and a clean dataset print the same "0".

**Run a known-answer check before trusting new results.** Before an estimator or a pipeline is
trusted on real data, run it where the answer is known: simulated data with an effect you built in,
or a published table from the same data. If it cannot recover the known answer, its new answer
means nothing.

**Read the exit code, and say what was checked.** A script ran only if its exit status is 0 *and*
its own last line says it finished. When reporting "done", name what was run and which checks
passed. Exit codes read through a pipe or from a background job lie — see `long_runs.md`. A
failed LaTeX build still writes a PDF: check the exit code and `grep "^!" main.log` before quoting
a page count or a figure position.

**Read the whole output.** When a command's output is long, Claude Code may show only a preview and
save the rest to a file (Last verified: 2026-10-07). The preview looks like the answer. Read the
saved file, or rerun the command narrowed, before concluding anything from it.

## 2. Research-code anti-patterns

| Anti-pattern | Why it hurts | Do instead |
|---|---|---|
| Swallowed errors (`tryCatch(..., error = function(e) NA)`, `except: pass`) | the run "works", the numbers are wrong | catch only errors you can handle; let the rest crash |
| Silenced warnings (`suppressWarnings()`, `warnings.filterwarnings("ignore")`) | hides coercion and convergence problems | fix the cause, or catch the one warning you understand |
| `as.numeric()` on German-formatted text (`"1.234,5"`) | becomes `NA`, with one warning | parse with the locale; count `NA`s before and after |
| Join keys of different types (`"007"` vs `7`) | zero or partial matches, no error | same type on both sides; assert the match rate |
| `na.rm = TRUE` everywhere | hides that data is missing | report how many are missing before dropping them |
| A result typed into code or text (`n_obs <- 4123`, a coefficient in a `.tex` table) | stale the moment the data change | compute it; write it to a file the paper includes |
| A hand-picked exclusion (`filter(id != 17)`) | an undocumented researcher choice | a named rule with a reason, and report how many it drops |
| Magic numbers (`age > 17`) | nobody can tell what 17 is | `min_adult_age <- 18` at the top, with a comment |
| Manual steps (edits in Excel, renaming by hand) | cannot be re-run; nobody knows they happened | script every step from raw data |
| Overwriting raw data | a mistake becomes permanent | raw data is read-only; write to a processed folder |
| `setwd()`, absolute paths | breaks on every other machine | `here::here()` in R; paths relative to the project root |
| Columns by position (`df[, 3]`) | silently wrong when columns move | column names |
| Copy-paste-modify blocks | a fix lands in some copies only | a function, once the logic repeats |
| Commented-out code | unclear what actually runs | delete it; git keeps the history (not the main file's switchable load blocks, which the template keeps on purpose) |
| Objects created in the console | the script fails in a fresh session | everything in the script |

**In-text numbers come from the script.** Write each number the paper quotes to a small `.tex` file
of macros that the paper `\input`s, so a re-run updates the paper:

```r
writeLines(sprintf("\\newcommand{\\nobs}{%s}", format(n_obs, big.mark = ",")),
           here::here("5_tables", "numbers.tex"))
```

## 3. Re-runnable from raw data

**The test:** in a fresh R or Python session, with only the raw data and the scripts, one command
reproduces every table, figure and number. Anything else is a result nobody can re-create.

- **One main file** runs the pipeline in order: `analysis/Data_Analysis_Main_File_OPEN_ME_FIRST.R`
  in the `/newproject` layout (from the template `reference/template_main_file.R`), or its `.py`
  twin. Each script checks that its inputs exist and stops with a clear message if not.
- **Run it fresh**, not in the console session that already holds objects the script no longer
  creates: `Rscript <main file>` from the folder that holds `renv.lock` (`analysis/` in the
  `/newproject` layout; see `windows.md`), and
  `uv run python analysis/Data_Analysis_Main_File_OPEN_ME_FIRST.py` from the project root.
- **Seed every random step** (bootstrap, simulation, sampling, train/test splits): `set.seed()`,
  `numpy.random.default_rng(seed)`.
- **After a refactor, rerun and compare outputs** with the last good run. Reordering
  floating-point arithmetic changes the last digits, so compare with a stated tolerance and say
  which one — never call a numeric change "identical" without having compared.
- **A quick or test mode writes to a different path** than the real run. *Why:* it gets run after
  the expensive run, and a shared path overwrites hours of results with seconds of toy output.

## 4. Inspect data files with code, never by eye

Never judge a CSV, Excel or JSON file by reading it as text, and never hand one to a subagent to
read — wide files with similar column names get misread, and the error enters the analysis as a
wrong number. Load it with code and print its structure:

```r
d <- readr::read_csv2(path)            # ";" and decimal comma (German Excel)
dplyr::glimpse(d); summary(d); table(d$treatment, useNA = "ifany")
```

```python
import pandas as pd
d = pd.read_csv(path, sep=";", decimal=",", encoding="utf-8-sig")
print(d.shape); print(d.dtypes); print(d.isna().sum()); print(d["treatment"].value_counts())
```

- **Look at one record before parsing the whole file.** A wrong guess about the structure (a
  nested JSON key, a header row two lines down) fails as zeros or `NA`s, not as an error.
- **A CSV saved by Excel as "CSV UTF-8" starts with a BOM** (an invisible marker). Python's
  `open()` and `csv` module keep it unless you read with `encoding="utf-8-sig"`; the first column
  name then carries an invisible prefix and lookups by that name fail.
- **IDs with leading zeros** (postcodes, firm IDs) are read as text (`col_types`, `dtype=str`);
  numeric parsing drops the zeros.
- **Count, don't skim:** "how many rows have X", "which values occur" are answered by code
  (`table()`, `value_counts()`), never by scrolling the file or asking a model to read it.
- Writing CSVs for German Excel: `empirical-analysis/r.md` / `python.md` § CSV output.

## 5. Writing the code

- **Exploration vs production.** Exploratory code may be messy. Once a result will appear in a
  paper, be shared, or be re-run months later, rewrite it: functions, assertions, the master
  script.
- **Functions when logic repeats, not before.** Short, one purpose, inputs as arguments, outputs
  returned — no reading or changing global variables. Three similar lines beat a premature helper.
- **Descriptive names** (`avg_income_by_county`, not `x2`); constants named at the top of the
  script.
- **Comments say why, not what.** Open each block of code with one short plain-language comment
  saying what the block is for (`# Drop firms with no employees.`) — it lets a reader who does not
  read code follow the script. RStudio/Positron section banners (`# Load data ----`) make the
  outline navigable.
- **Script header:** what the script does, what it reads, what it writes — a few lines.
- **Every changed line traces to the request.** If removing a line from your diff would still
  satisfy the request, it is a drive-by change; take it out and mention the issue instead.
- **Don't fight a library's internals — post-process its output.** If a table package cannot
  produce a row you need, edit the LaTeX it writes, not its classes. The output format is stable;
  internals change between versions.
- **Write scripts to files and run them.** No long `python -c` one-liners or heredocs: a file can be
  re-run, read and corrected, and long inline code breaks on quotes and backslashes
  (`windows.md`).
- **Overkill at research scale, unless the user asks:** CI pipelines, formal test suites for
  analysis scripts (inline assertions are the right tool), class hierarchies and design patterns,
  Make/Snakemake for a handful of scripts, branches for solo work, R package structure.

## 6. Scripts that change files

- **Dry-run first.** A script that rewrites, renames or edits files that matter (a `.bib`, a
  `.tex`, a data file) first prints what it would change; check the count and the byte sizes
  against expectation, then run for real. Keep a copy until the result is verified.
- **Assert no output came out empty** before the script finishes. One line turns a silent
  destruction into a loud one; the classic cause is Python's `open(p, "w")` inside the expression
  that reads `p` (`empirical-analysis/python.md`).
- **Never create a file with a shell `>` at a path you have not checked.** `>` overwrites
  whatever is there without asking; check the exact path first, or write new files with the Write
  tool.
- **Preserve line endings** when editing an existing file from Python — see `windows.md`.
- **Deleting needs the user's yes** (the kit's rules ask before deletions). A delete that is
  refused is the safeguard working; never switch tools to get around it.

## 7. R and Python traps

**R — data passed through `...` can be captured by an earlier argument.** R matches argument names
partially, so in `optim(par, fn, gr, ...)` a data argument `p = p` lands in `par`. The error names
`fn`, which is not in your code. Build the objective as a closure:

```r
# WRONG — `p = p` partial-matches `par`
optim(th0, negll, a = a, p = p, method = "BFGS")
# RIGHT
make_negll <- function(a, p) function(th) { ... }
optim(th0, make_negll(a, p), method = "BFGS")
```

**R — sort order depends on the machine.** `order()` on character follows the locale (a German
Windows PC sorts differently from a server), and `factor()` takes its default level order the same
way, so row order and factor levels can differ between machines from identical data. Where order
matters, sort with `method = "radix"` (byte order) on `as.character()` values — `order()` on a
factor sorts by its level codes, not its text.

**Python — `float` sums depend on order.** `sum()` from Python 3.12 adds more accurately than a
`total += x` loop, so an exact-equality check between the two fails on correct code; compare with a
stated tolerance.

## 8. After a change

- Run the changed script, then the whole pipeline from the master script if a shared input
  changed; compare outputs with the last good run.
- For non-trivial work, offer `/what-slipped`: a fresh subagent critiques the work just done.
- **When a new trap bites** — a silent failure, a Windows quirk, a misleading error — propose adding
  it, with its fix, to the matching file of this skill. A trap written down once is not hit twice.
