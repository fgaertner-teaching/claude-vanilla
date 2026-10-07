# Debugging: find the cause before fixing

**Load when:** an error, a crash, a failing check, or a result that looks wrong — or suspiciously
good.
**Skip when:** writing new code that has not failed yet.

**The rule: no fix before a cause.** A change made without knowing why the code failed does
nothing, hides the bug, or adds a second one. Work in four steps — observe, hypothesise, test,
fix — changing one thing at a time.

## The method

1. **Read the actual error.** The answer is usually in the last lines of the traceback; copy the
   exact message. For a wrong result without an error, write down what you expected and what you
   got, with numbers.
2. **Reproduce it on demand,** with the smallest input that still fails. If you cannot trigger it,
   you cannot show that a fix worked.
3. **Write the failing check first:** a `stopifnot()` or `assert` that fails now and will pass once
   the bug is fixed. Keep it afterwards; it catches the bug if it comes back.
4. **Find where right turns into wrong.** Print intermediate values and halve the search: the first
   half of the script or the second, this input or that one. The bug sits at the boundary, often
   far upstream of the line that crashed. **Bisect, don't theorise:** reading code for something
   that "looks wrong" produces plausible stories that are often wrong; a few halving runs settle
   it.
5. **Change one thing at a time,** and re-run after each. After three changes at once you do not
   know which one worked, or what the other two broke.
6. **Check your assumptions.** The most common cause is something taken for granted:
   - Is the data what you think? Print dimensions, types, the first rows, the count of missing
     values.
   - Is it the file you think? Print the path being read.
   - Is the code you edited the code that runs? Print a line at the top of the function.
   - Are the interpreter and packages the ones you think? `sys.executable`, `R.version.string`,
     `packageVersion("fixest")`.
7. **Explain the cause to the user in plain words before fixing:** what was wrong, why, what the
   fix changes, and how you will show that it is fixed.

## Rules for Claude

- **Never re-run a failed command unchanged, hoping.** Find out why it failed first.
- **After two failed fixes for the same problem, stop.** Report what is known and what was tried,
  and propose a different approach instead of a third variation.
- **Never fix the symptom.** Suppressing the warning, wrapping the call in `tryCatch` or `try`,
  dropping the rows that error, loosening a tolerance, or deleting the failing assertion all hide
  the bug while it keeps producing wrong numbers. If a workaround is genuinely needed to unblock
  work, say so, and record the real problem in `claude/OPEN_ISSUES.md`.
- **"The package is broken" is the last hypothesis.** Check your usage against the documentation of
  the installed version first.
- **An error naming something that is not in your code** (`could not find function "fn"` from
  `optim`) usually means arguments landed in the wrong place — SKILL.md § 7.
- **A "known limitation" in code you just changed is probably your regression.** Before writing
  "edge case, left as is" into a comment, run the previous version on the same input
  (`git show HEAD:analysis/clean.R > old_clean.R`, then run both). If it worked before, you broke
  it.
- **If a fix made things worse,** `/rewind` returns Claude's file edits to an earlier point in the
  conversation. It covers edits made with Claude's editing tools, not changes made by shell
  commands or deleted files.

## When the instrument is the bug

Sometimes the code is fine and the check is broken — and a broken check usually reports the
flattering answer.

- **A check that prints 0 may be a check that cannot match.** A grep or filter with a broken
  pattern, a condition on a misspelt column name, a test filter that selects no test: all report
  "nothing found". Before believing "no problems", show that the same check finds a known case.
- **A fix that makes an error disappear has not yet been shown to work.** Confirm the output is
  right, not just quiet: the error may have moved into the numbers.
- **Claude Code's Grep tool hides matching lines longer than 500 characters,** showing
  `[Omitted long matching line]` instead (Last verified: 2026-10-07). In wide CSVs, JSON lines or
  one-paragraph-per-line text, search with a script.
- **Web fetches are summarised by a small model.** Fine for "what does this page say"; unreliable
  for an exact value, a count, or "which of these 20 IDs are listed" — it can report a number the
  page does not contain, or miss items, with no warning. For exact facts, download the raw data (a
  CSV, a JSON API response) and parse it with code.
- **A multi-word search over prose misses text that wraps across lines.** Search for one
  distinctive word first, then narrow.
- **Exit codes read through a pipe or from a background job can lie** — `long_runs.md`.

## Anti-patterns

| Anti-pattern | Why it fails | Instead |
|---|---|---|
| Shotgun debugging | random changes, hoping one works | a hypothesis, then one change |
| Retrying unchanged | same input, same failure | find out why it failed |
| Fixing the symptom | the bug keeps producing wrong numbers, quietly | fix the cause |
| Pasting a fix from the web unread | works by accident, or breaks something else | understand what it does first |
| Printing everything | the signal drowns in output | halve the search, print at the boundary |
