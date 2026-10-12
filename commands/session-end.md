---
description: Close the session - update the project's handover, open issues and log, record decisions, commit and push, then suggest /clear.
---

Close this session so the next one can pick up without you. Do the steps in order and report
each one in a line. Do not skip a step silently: if it does not apply, say why.

## 1. Update the project's files

- **`claude/next_steps.md`: overwrite it** (it is a snapshot, not a diary). Three short parts:
  where the project stands now; what this session did (results, not a file list); what comes
  next, in order, each item concrete enough to start on. Check every item carried over from the
  old version against what happened today; drop what is done. The test of a good entry: a new
  session could start on it with nothing but this file.

  ```
  # Bad:  Continue with the robustness checks.
  # Good: Next: run 3_3_Robustness.R with firm-clustered SEs (Table 3 used robust ones);
  #       the clustering choice is in decision_standard_errors.md.
  ```
- **`claude/OPEN_ISSUES.md`:** add what came up and is not solved, each with what would close
  it. Delete items that were solved AND checked this session. An item that was worked on but not
  checked stays, with a note on its state. An item that can wait for months moves to
  `claude/long_term_open_issues.md`.
- **`claude/session_log.md`: add one entry at the end** (create the file if it is missing): the
  date, what we did, and which decision files we wrote. Change nothing above it.
- **Decisions:** for each decision made today that a future session needs the reason for, write
  or update a `claude/decision_<topic>.md` (question, options, what we chose and why).
- **Corrections:** if the user corrected you today, propose a line for the file that would
  prevent it (`~/.claude/CLAUDE.md`, `~/.claude/rules/rules.md`, a skill, or the project's
  `CLAUDE.md`). Write it only after the user agrees.
- **A panic dump** (`claude/panic_dump.md`) whose content is now in these files: ask the user
  whether to remove it.

## 2. Commit and push (if this is a git repository)

1. `git status`, and check that no data, outputs or secrets are about to be committed
   (`~/.claude/reference/checklist.md`).
2. Stage the files this session changed, by name. State the commit message, then commit.
   Several unrelated changes: one commit each. The message says what changed and why:

   ```
   # Bad:  Update scripts
   # Good: Cluster SEs by firm in the main models (referee 2, point 4)
   ```
3. If the repository has a remote: list what git tracks and what it leaves out
   (`git ls-files`; `git status --ignored --short`), point at anything that looks misplaced,
   then push. Claude Code asks the user before the push: say what goes up. Say if the push
   failed; do not force it.

## 3. Hand over

Tell the user in two or three lines what was saved where, and anything still uncommitted or
unpushed. Then suggest `/clear` for a fresh start next time (everything needed is now on disk).
If the session should continue on the same task instead, suggest `/compact`.
