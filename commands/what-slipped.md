---
description: Critique the work just done, from outside the context that did it. A fresh subagent reads the diff and your account of the work, and reports what is wrong, missing or overclaimed.
argument-hint: "[what to review; default: the last piece of work]"
---

Critique the work just done, from outside the context that did it.

The context that did the work defends the framing it built, so **you do not write this critique
yourself**: you collect the evidence, hand it to a fresh subagent, and report what it finds. For
a finished artifact (a draft, a pipeline, a setup) use the `auditor` skill instead; to check
only that a task was completed, the `verifier` agent.

## 1. Scope: one line, then carry on

Scope: $ARGUMENTS. If that is empty, take the last coherent piece of work, not the whole session.
State it in one line ("Reviewing: the cleaning script and the merge fix") and continue without
waiting. Ask only if the scope is genuinely ambiguous.

## 2. Collect the evidence

**Primary, the record you cannot edit:**

- `git status --short`, `git diff`, `git diff --cached` and `git log --oneline -10`; if the work
  is already committed, `git diff <commit before the work>..HEAD`.
- The output of any script, test or check run for this work, and the paths of all files touched.
- If there is no diff (a decision, an analysis in chat), say so: the account below is then the
  only input, and the agent must know that.

**Secondary, your account, labelled as biased:** at most 15 lines on what you believe this work
did, what you decided, and what you skipped or were unsure about. Plain, not polished.

Before sending, compare the account with `git diff --stat` and name every changed file it does
not mention. *Why:* an account is written from memory of the reasoning, so it drops the files
edited in passing, which is exactly where unreviewed changes collect.

## 3. Dispatch one fresh subagent

One general-purpose subagent, in the foreground. One, not several: this reviews a unit of work,
and several reviewers are the auditor's job. Give it:

- the scope line;
- the primary evidence, marked as authoritative;
- the account, marked "written by the context under review; may be biased";
- the commit the work started from, so it reads the diff rather than files you may still be
  changing while it works;
- the questions below, and: "Do not edit any file. Return your findings as your final message."

Ask it:

1. **What does the diff contain that the account never mentions, and what does the account claim
   that the diff does not show?** Treat every gap as a finding.
2. Was anything built on a premise (a note, an earlier claim, a guess about the data) that was
   never checked against the data or the code?
3. Is any claim about what code does based on reading it rather than running it? Is any number
   quoted without the script or table it came from?
4. Is anything called done or fixed that was never tested?
5. Was a name, number, path, citation or version written from memory where a source was at hand?
6. Was the scope narrowed without saying so, or partial work reported as complete?
7. Is any result stated more strongly than the evidence supports?

**Its output:** findings only, most severe first. Each carries a `Settles it:` line naming one
concrete check (a command to run, a file to read, a number to recount). A finding that cannot
name its own check is unease, not a finding: drop it. If there is nothing, it says "no findings"
plainly and does not invent some to justify the run.

## 4. Report and route

Show the user the findings as returned. Before acting on one, check it against the file or data
it names: the agent saw a snapshot and can be wrong. Then propose one outcome for each:

- **fix now:** small and in scope;
- **file:** an entry in the project's `claude/OPEN_ISSUES.md`, if it needs its own session;
- **drop:** with one line saying why.

Do not quietly fix everything. The point is that the user sees what the outside view found,
including what you disagree with.

If every finding merely restates your account in other words, say so: the primary evidence was
too thin, and the fix is more of the record (diffs, outputs), not a better prompt.
