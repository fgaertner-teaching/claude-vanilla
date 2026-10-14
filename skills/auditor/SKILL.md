---
name: auditor
description: "Independent quality review of an artifact (a paper or proposal draft, an analysis plan or pre-registration, a script pipeline, a project setup, a skill or CLAUDE.md) by fresh subagents that did not write it, with every finding ranked by severity and checked against the source before anything changes. ALWAYS use this skill when the user asks to audit, review, critique or quality-check an artifact, and offer it before a draft, an analysis or a setup goes to co-authors, a journal or a funder. Do not review such an artifact yourself in the session without offering it first. Not for critiquing the work just done in this session (that is the /what-slipped command), for confirming that a task was completed (the verifier agent), for a finished empirical analysis whose numbers should be re-run from its code (the referee2 agent), for the final check of a submission package (pre-submission-audit), or for a single targeted fix."
---

# Skill: Auditor

**Purpose:** Review an artifact with reviewers that did not write it, so its blind spots surface as findings instead of as agreement.
**Load when:** reviewing a finished or near-finished artifact for quality, coherence or errors: a draft, an analysis plan, code, a project setup, a skill.
**Skip when:** critiquing the work just done in this session (`/what-slipped`), checking that a task is complete (`verifier`), or making one targeted change.
**Modifies behavior:** the review runs in fresh subagents on named dimensions; each finding carries a severity, a harm and a check; each is verified against the source before it is acted on, and ends as fix, file or drop.

## Why reviewers that did not write it

The context that wrote an artifact reads what it meant, not what it wrote, and defends the framing
it built. A fresh subagent sees only the artifact and its surroundings, so it finds the
assumptions the author never noticed making. **So you do not review the artifact yourself: you
set the scope, brief the reviewers, and act on what they find.**

Asking for an audit is asking for its subagents. Never swap in a single pass of your own without
saying so.

## 1. Scope and size

State in one line what is under review (files, a folder, the rendered PDF) and the question the
audit answers ("does the analysis code match the pre-registration?", "general quality"). Then
size it:

| Artifact | Reviewers | Then |
|---|---|---|
| Small: one file, one question, cheap to get wrong | 1 | you verify its findings (step 6) |
| Big: several files or a pipeline; or it goes to co-authors, a journal or a funder; or it changes data | 2, in parallel | a consolidator merges them (step 5) |
| A paper or proposal where one kind of reader decides | 2 + a persona reviewer | consolidator; persona quotes spot-checked |

*Why two:* reviewers that cannot see each other's reports routinely find different defects.
Agreement between them is strong evidence; a finding only one of them made is not a sign of a
false alarm, since one may simply have looked where the other did not.

**If subagents are genuinely unavailable,** work through the dimensions yourself and call the
result a "single-session audit". Its findings are real, but its silences are weak evidence: one
perspective cannot disagree with itself.

## 2. Choose the dimensions

Reviewers work through named dimensions so that nothing is skipped because it seemed fine. For
general quality use all eight; for a narrow question use 2–4 that fit it, and say which and why.

**The general eight:**

1. **Hidden assumptions:** what does it take for granted about its inputs, environment or
   reader, and what breaks if that is false?
2. **Missing pieces:** what should be there and is not (a definition, a robustness check, an
   error case, a step)?
3. **Redundancies:** the same thing done or said in two places, which will drift apart.
4. **Interface problems:** does information pass correctly between parts (script to script,
   table to text, section to section)?
5. **Inconsistencies:** terms, numbers, names or claims that disagree between places.
6. **Over-engineering:** complexity without a concrete benefit. Would a simpler version do?
7. **Scope creep:** parts that serve no current purpose.
8. **Silent failure:** how does it behave when it is wrong? Can an empty result be told apart
   from a clean run (a filter that matched nothing, a merge that dropped rows)? Can a missing
   value mean two different things? Who would notice first, and when?

**Narrower sets for common research artifacts:**

- **Paper or proposal draft:** claims vs evidence (does each claim follow from the result it
  cites?); numbers in the text vs the tables and figures; argument (does each section deliver
  what the introduction promises?); reader (where would a referee get lost or object?).
- **Analysis code or pipeline:** correctness (does it compute what the paper says?); data
  handling (merges, missing values, sample restrictions, row counts at each step);
  reproducibility (does it run from raw data with one command; seeds, paths, package versions?);
  silent failure.
- **Analysis plan or pre-registration:** identification (what would make the estimate wrong?);
  measurement (does each variable measure its construct?); pre-specification (could a reader
  later tell which analyses were planned?); power.

## 3. Severity, harm and check

Every finding gets one severity:

- **Must fix:** a wrong result, a contradiction, or something that will break.
- **Should fix:** a clear improvement at low cost.
- **Consider:** a genuine trade-off; reasonable people could disagree.
- **Note:** an observation with no concrete harm.

And every finding passes two tests, which fail on different findings:

- **Harm:** state what goes wrong if it is left as is. No harm you can name, lower the severity.
- **Check:** a `Settles it:` line naming one concrete check that would show whether the finding
  is true: a command to run, a file to read, a number to recount. Harm is easy to narrate; a
  check is not. A finding that cannot name its own check is unease, not a finding: drop it or
  mark it note.

```
# WRONG
3.1 The robustness section may be incomplete. (should fix)

# RIGHT
3.1 The text says the result holds "in all specifications"; Table A4 col. 3 drops firm fixed
    effects and the coefficient halves. Harm: a referee finds it first.
    Settles it: compare Table A4 col. 3 with the sentence on p. 14. (must fix)
```

## 4. Brief the reviewers

Launch each reviewer as a fresh general-purpose subagent; launch parallel reviewers in one
message. Fill in the brackets:

> You are an independent reviewer. You did not write the artifact below and owe it nothing.
> **Scope:** [files / folder / PDF]. **Question:** [what the audit answers].
> 1. Read everything in scope, then its surroundings: files it references, the project's
>    `CLAUDE.md`, the other files in its folder. Something odd in isolation may be justified by
>    context; check that before flagging it, and say so if you could not.
> 2. Work through these dimensions in order: [the chosen list, with one-line definitions]. For a
>    dimension with nothing to report, write "No issues found" or "N/A: [reason]".
> 3. For each finding give: an ID `<dimension>.<n>` (e.g. `4.2`); what exactly is wrong, with
>    file and line, page, or table and column; a severity (must fix / should fix / consider /
>    note); the concrete harm if left as is; a `Settles it:` line naming one check; and a fix.
>    [Paste § 3's severity scale and two tests.]
> 4. Then step back: what would someone with a different background flag? Add those findings
>    under the dimension they fit best.
> 5. Report exactly what you find. No padding to a round number, no softening, no truncating.
>    "No issues found" is a valid result. Say where you are unsure.
> 6. Do not edit any file. [Write your report to `<path>` / Return your report as your final
>    message.]

**Brief hygiene:**

- **Keep the brief to what the artifact is and what the audit asks.** Leave out your own numbers,
  suspicions and descriptions of known defects: a reviewer repeats them, and they come back
  looking like independent findings. If you suspect something, see whether a reviewer finds it
  unprompted.
- **Give each reviewer its own report path and scratch-file prefix** (`r1_`, `r2_`), so parallel
  reviewers do not overwrite each other's working files.
- **Once a reviewer has reported, never send it a correction.** If its work must change, launch a
  fresh reviewer. A report revised after the merge has started makes the merge wrong without
  anyone noticing.
- **In plan mode, subagents cannot write files.** Have them return their reports as their final
  messages instead.

**Persona reviewer (papers, proposals, slides).** Alongside the dimension reviewers, never
instead of them, one subagent reads the rendered artifact (the PDF, not the `.tex`) as a named
reader ("a referee at [journal] who works in [neighbouring field]", "a panel member from outside
the discipline") and notes, as it reads, where it gets confused, irritated, loses the thread or
stops believing. It catches what dimensions cannot: the fifth restatement of an argument passes
every check and is still where a reader's attention dies. A persona paraphrases, so check each
passage it quotes against the source before acting on it. A stumble at a place a dimension
reviewer also flagged is strong evidence.

## 5. Consolidate (two or more reviewers)

Launch one more fresh subagent and give it the reviewer reports only:

> You merge independent review reports into one. **Do not read the artifact itself.** Judge the
> reviewers' evidence, not your own impression; a finding you cannot judge without the source is
> marked "unresolvable without source".
> 1. Read all reports before writing anything.
> 2. A finding in several reports: keep it, with the better-argued severity and the better fix.
>    A finding in one report: keep it if its evidence is concrete; mark it uncertain or lower its
>    severity if the evidence is thin.
> 3. **Account for every finding.** Each one appears in the merged report (cited as `r1-4.2`) or
>    under "Findings excluded" with a one-line reason. Nothing is dropped silently.
> 4. Challenge each: is the harm concrete and plausible, or a theoretical edge case? Is the
>    severity justified by the harm? Would its `Settles it:` check actually tell true from
>    false? A check that would not discriminate makes an unverified finding look verified:
>    lower it to note and say so.
> 5. Add a "Reviewer agreement" section: found by several, found by one, unresolvable.
> 6. Do not edit any other file. [Write to `<path>` / Return as your final message.]

With a single reviewer, skip this step: its report goes straight to step 6.

## 6. Verify, then decide each finding

**Before acting on a finding, open the file and line it names and confirm the problem is there
as described.** Reviewers misquote and misread, and the consolidator never saw the source at
all. A finding the source refutes is dropped, with the refutation in one line.

Every finding then ends in exactly one of three outcomes:

- **Fix now:** small, in scope, the fix is clear. Must-fix and should-fix findings default here.
- **File:** worth doing but needs its own session or a decision. One entry in the project's
  `claude/OPEN_ISSUES.md`, naming the finding and its `Settles it:` check.
- **Drop:** with one line saying why: refuted by the source, a fix that costs more than the harm,
  or something nobody would ever choose to work on.

Judge consider and note findings by "is this a concrete improvement worth its cost?", not by
urgency. A consider is not automatically "later".

**The user sees the outcome of every finding, including the ones you disagree with.** A fix that
changes what a paper claims, or the design of a study, is always the user's decision: list it
under "needs your decision" with your recommendation instead of applying it.

```
Audit of [scope]: [N] reviewers, dimensions: [set]
Fixed:     [ID: one line each]
Filed:     [ID: where]
Dropped:   [ID: reason]
Needs your decision: [ID: the choice, with my recommendation]
```

## Report format and where it goes

```
# Audit: [scope]
_Date: YYYY-MM-DD. [N reviewers / single-session]. Dimensions: [set]_

## Scope
## Findings
### 1. [dimension]        (one section per dimension; "No issues found" allowed)
## Summary                (findings ranked by impact)
## Recommended actions
## Reviewer agreement     (merged report only)
## Findings excluded      (merged report only; "None" if none)
```

Save the reports in the project's `claude/` folder: `claude/audit_<scope>_r1.md`, `_r2.md` and the
merged `claude/audit_<scope>.md`. Keep the reviewer reports after the merge; they hold evidence
the merged report only summarises.

## Traps

This list grows. When Claude gets an audit wrong, Claude proposes adding the mistake and the rule
that prevents it here, and adds it once the user agrees.

- **Context Claude puts in a brief comes back as a finding.** Claude once gave the consolidator a
  file size "for context". The merged report then used that number in a verdict, as if a reviewer
  had established it. Neither reviewer had written it. Every brief, the consolidator's included,
  holds only what the artifact is and what the audit asks (§ 4, brief hygiene).
- **A persona's quote is not the source.** A persona reported a "garbled sentence" that was clean
  in the draft. The persona had paraphrased it. Claude checks each quoted passage against the
  source. A finding whose quote fails the check is dropped or downgraded. Claude never edits the
  source to match a paraphrase.
- **The fixes are a change no reviewer saw.** Fixes applied after an audit can carry defects of
  their own. A separate review of only the fixes has found several real defects that no audit
  finding had named. After applying the fixes, Claude offers `/what-slipped` on them before the
  user treats the artifact as done.

## Improving this skill

If an audit's findings were mostly wrong when verified (step 6), tighten the brief, not the
severity scale: the usual cause is a reviewer that lacked context or was handed a suspicion. If
an important defect surfaced later that no reviewer flagged, add the dimension that would have
caught it to the matching narrower set in § 2.
