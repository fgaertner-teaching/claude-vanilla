# Running scripts and long jobs

**Load when:** starting a script that may run longer than ~2 minutes, in the background,
unattended or overnight; waiting on a running job; or stopping one.
**Skip when:** quick commands that return in seconds.

A long run costs the session's time, not only the computer's: while it runs, the work waits. And a
long run that fails, or reports success it did not have, usually has to be run again in full. Most
of this page is about not paying for a run twice.

## Before the first run

- **Estimate the time from a measurement.** Time one unit (one file, one bootstrap draw, one
  model) and multiply; tell the user the estimate before starting. If the work will take longer
  than they expect, say so and offer a smaller or cheaper version first.
- **Finish every edit before starting.** Never edit a script, or a file it reads, while it runs.
  Bash reads a script as it goes, so an edit mid-run garbles it; a sweep that re-reads files would
  test a mix of old and new code and print a normal-looking verdict that means nothing.
- **Order:** all edits → a quick run on a small subset → one full run. A full run is not the way to
  find out whether a change works.
- **Parallel workers: at most the number of cores minus one** (`parallel::detectCores()`,
  `os.cpu_count()`). More makes the whole computer unusable, including the user's other work.

## Claude Code's time limit

- A command in the foreground stops after **2 minutes** by default; one call can raise its limit to
  at most **10 minutes** (Last verified: 2026-10-07). A shell `timeout 900 ...` inside the command
  does not raise it.
- **Longer: run it in the background.** Claude Code is notified when it ends and can then read its
  output. For anything over ~10 minutes, also have the script write its own log file.
- A job that vanishes exactly at the limit was stopped by the limit, not hung.

## Launching in the background

- **Unbuffer Python:** `python -u script.py` (or `PYTHONUNBUFFERED=1`). Otherwise output arrives in
  large chunks, and a working job looks dead for minutes. In R, print progress with `message()`.
- **Never pipe a background run through `| tail`, `| head` or `| grep`.** The pipe holds back all
  output until the end, so you see no progress, and it keeps only the last lines, so the error
  above them is gone. Filter when you read the output, never when you launch.
- **Make the real exit status the last line.** A pipe, or any command after the script, replaces
  the script's exit status with its own, and the completion notice reports that one:

```bash
# WRONG — reports tail's status (0) even when the script failed
Rscript run_all.R 2>&1 | tail -20
# RIGHT — the script's own status, printed last
Rscript run_all.R > run.log 2>&1; rc=$?; tail -20 run.log; echo "REAL_EXIT=$rc"
```

- **A silent log is not a dead job.** Buffering produces long silences. Before concluding that a
  run died, check its process by ID or whether its CPU time is still rising. If you cannot see
  the job's state, say "I cannot tell", never guess a duration or a cause.

## Scripts that run long: readable, resumable, stoppable

Any script expected to run more than a few minutes needs these, written in before the first run:

1. **Progress that says where the run is:** unit *k* of *n* and the elapsed time
   (`model 12/40 · 6.3 min`). A line naming only the current item cannot tell "nearly done" from
   "barely started".
2. **Save as you go.** Append each result as it finishes; never one write after the last unit.
   *Why:* any interruption otherwise loses everything, and the user is trapped into waiting out a
   run they no longer want.
3. **Resume.** On restart, skip the units already in the output, so an interruption costs one unit.
4. **A stop that needs no kill.** Between units, check for a file named `STOP` and exit cleanly if
   it exists. The user can create it from any window.
5. **A limit inside the program** — maximum time, iterations or API budget. Stopping a background
   task in Claude Code ends the shell around it and may leave R or Python running; a limit the
   program applies to itself always works.
6. **A test mode writes elsewhere.** A `--quick` flag that shrinks the run must also change the
   output path (SKILL.md § 3).

```r
# Resume: skip units already done -------------------------------------------
done <- if (file.exists(out_path)) {
  readr::read_csv2(out_path, col_types = readr::cols(.default = "c"))$unit
} else character()
todo <- setdiff(units, done)                 # units: a character vector of IDs
t0 <- Sys.time()

# Estimate unit by unit, saving each result as it lands --------------------
for (i in seq_along(todo)) {
  if (file.exists("STOP")) { message("STOP file found: stopping cleanly"); break }
  result <- estimate_one(todo[i])            # a one-row data frame with a `unit` column
  readr::write_csv2(result, out_path, append = file.exists(out_path))
  message(sprintf("unit %d/%d · %.1f min", i, length(todo),
                  as.numeric(difftime(Sys.time(), t0, units = "mins"))))
}
```

**An unfamiliar heavy job** (a document conversion, a large merge, a first run of new code) also
gets a memory ceiling, not only a time limit: some failures do not hang, they eat all the RAM and
freeze the computer. Watch both, and report which one stopped the run — "too slow" and "too big"
need opposite fixes.

## Jobs that must outlive the session

A job started from Claude Code is a child of the session. When the session ends, Windows ends the
job too, silently: the output just stops, with no error anywhere. For an overnight run, start it
detached, in its own process:

```powershell
Start-Process -FilePath "C:/Program Files/R/R-4.5.1/bin/Rscript.exe" `
  -ArgumentList "run_all.R" -WorkingDirectory "C:/Users/me/projects/my_study" `
  -RedirectStandardOutput "run.log" -RedirectStandardError "run.err"
```

(Paths are examples; use the real ones.) A detached job still dies if Windows Update restarts the
computer overnight; only saving as you go protects against that.

## Stopping and killing

- **Never force-kill a process unless the user asks, and never guess which one.** A process killed
  while writing can leave a corrupted file (a half-written `.rds`, CSV or database). Prefer the
  `STOP` file; if a kill is needed, identify the process by its command line, show it, and let
  the user decide.
- **After any kill or crash, look for half-written outputs.** A resume step that skips existing
  files would skip a broken one forever.
- **"Is it still running?" checks by program name first.** A search over all processes' command
  lines for `run_all.R` also finds the search itself, so it always says yes.

## Local servers

A local app (Shiny, Streamlit, Flask) listens on `127.0.0.1`, never `0.0.0.0`: the second makes it
reachable from the network. Ask the user before exposing one.
