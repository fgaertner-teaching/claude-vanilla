# Auditor

**Load when:** reviewing any artifact — a file, system, pipeline, convention setup, or project structure — for quality and coherence.
**Skip when:** making a single targeted change or doing a quick lookup.

## Purpose

General-purpose review skill for evaluating artifacts of any size: a single CLAUDE.md, a code pipeline, a convention setup, an agent design, a project structure. Uses a three-agent protocol to produce a rigorous, bias-resistant audit report.

## Review dimensions

Every audit works through these 7 dimensions. Write "N/A — [reason]" for dimensions that genuinely do not apply. Never skip a dimension without stating why.

1. **Hidden assumptions** — what does this artifact take for granted about its inputs, environment, or users? What could go wrong if those assumptions break?

2. **Missing pieces** — what is absent that should be present? Are there gaps in documentation, error handling, edge cases, or user guidance?

3. **Redundancies** — is the same thing done in two places? Do components duplicate each other's work? Could anything be consolidated without loss?

4. **Interface problems** — does information flow correctly between components? Is anything lost, ambiguous, or misformatted in handoffs? Are dependencies explicit?

5. **Inconsistencies** — do components agree on terminology, structure, naming, and shared knowledge? Are there contradictions between files?

6. **Over-engineering** — is any of this unnecessary? Would a simpler version work equally well? Is the complexity justified by a concrete benefit, or is it speculative/defensive?

7. **Scope creep** — has the artifact grown beyond what was actually needed? Are there features, options, or abstractions that serve no current use case?

## Severity scale

Each finding gets one of these ratings:

- **Must fix** — correctness error, contradiction, will cause wrong behavior
- **Should fix** — meaningful improvement, clear benefit, low cost
- **Consider** — genuine trade-off, reasonable people could disagree
- **Note** — observation, no concrete harm if left as-is

The test: state the concrete harm if left as-is. If you can't articulate harm, downgrade severity.

## Protocol

Three agents, launched by the main session. The main session defines the scope and orchestrates; it does not review the artifact itself.

### Phase 1: Two independent reviewers (parallel)

Launch two Opus agents in parallel, each with identical instructions. Each reviewer works independently — they do not know about each other.

**Reviewer instructions:**

> You are an independent auditor. Review the artifact(s) specified in the scope below for quality and coherence.
>
> **Process:**
>
> 1. Read all in-scope material first. Then read the surrounding environment — other files in the same directory, files referenced by the artifact, and any conventions/rules that apply. Understand the broader context before judging anything.
> 2. Work through all 7 review dimensions sequentially (listed below). For each dimension, write "N/A — [reason]" if it genuinely does not apply.
> 3. For each finding:
>    - Describe the issue concretely — what specifically is wrong or suboptimal, with file/line reference where applicable
>    - Assess severity: **must fix**, **should fix**, **consider**, or **note** (see scale below)
>    - State the concrete harm if left as-is — if you can't articulate harm, downgrade severity
>    - Propose solution(s) — one if the fix is obvious, multiple if genuinely distinct approaches exist with different trade-offs. Do not manufacture alternatives to fill a quota.
> 4. After completing all dimensions, step back: "What did I miss? What would someone with a completely different perspective flag?" Add any additional findings.
>
> **Review dimensions:**
> [Include all 7 dimensions from this skill file]
>
> **Severity scale:**
> [Include the severity scale from this skill file]
>
> **Honesty guards:**
> - Report exactly what you find. Do not pad to a round number, do not truncate to fit one.
> - If a dimension is clean, say so. "No issues found" is a valid result.
> - Severity reflects actual impact, not effort of discovery.
> - Do not soften findings to be diplomatic.
> - Something that looks odd in isolation may make sense in broader context. If you checked the context and it's justified, don't flag it. If you couldn't find justification, flag it but note the uncertainty.
>
> **Output:** Write findings to `[path provided by caller]`.

### Phase 2: Consolidator (after both reviewers complete)

Launch one Opus agent after both Phase 1 agents return.

**Consolidator instructions:**

> You are a consolidation reviewer. Two independent auditors have reviewed the same artifact. You receive both their findings reports. Your job is to produce a single, definitive audit report.
>
> **Important: Do not read the original artifact or its surrounding environment.** Your job is to adjudicate the reviewers' findings, not to form your own opinion of the artifact. If you cannot adjudicate a finding without seeing the source material, flag it in your report as "unresolvable without source review" — do not go read it yourself.
>
> **Process:**
>
> 1. Read both review reports fully before writing anything.
> 2. For each finding that appears in both reports (convergent): confirm it. Check whether severity assessments agree; if not, pick the better-justified one. Take the stronger solution from either reviewer, or synthesize an improved one.
> 3. For each finding that appears in only one report (divergent): evaluate based on the evidence the reviewer provided. Is the reasoning concrete and convincing? If yes, include it. If the evidence is thin or the finding is speculative, downgrade or flag as uncertain.
> 4. **Account for every reviewer finding.** Every finding from both reviewers must appear in the consolidated report — either as an included finding (any severity) or in a "Findings excluded" list with a one-line reason per item. Silent drops are not acceptable; the consolidated report must be a complete audit trail.
> 5. Challenge all findings:
>    - Does the finding describe a concrete problem that could actually occur, or is it a theoretical edge case?
>    - Is the severity justified by the stated harm, or inflated?
>    - Are any findings nitpicking — technically correct but not worth acting on?
> 6. Review proposed solutions: are any worse than the problem? Can any be improved? Do the two reviewers' solutions for the same finding suggest a better third option?
>
> **Calibration:**
>
> - Uncertainty is allowed. If you genuinely can't tell whether a finding is valid from the reports alone, say so — don't force a verdict.
> - Do not remove findings just to appear decisive. A "consider" rating is better than a false dismissal.
> - Do not keep findings just because they might matter in some edge case. The test is concrete, plausible harm.
> - Convergence is strong evidence but not proof — two reviewers can share the same bias.
> - Divergence is not evidence of a false positive — one reviewer may simply have seen something the other didn't.
>
> **Honesty guards:**
>
> - No rounding, no padding, no softening.
> - Do not defer to the reviewers' authority. Evaluate their reasoning, not their confidence.
>
> **Output:** Write the final consolidated report to `[path provided by caller]`. Use the output format below. Add a "Reviewer agreement" section noting which findings were convergent, divergent, or unresolvable.

## Output format

All reports (reviewer and consolidated) use this structure:

```
# Audit: [scope description]
_Date: YYYY-MM-DD_

## Scope
[What was reviewed — list of files, systems, or areas]

## Findings

### 1. Hidden assumptions
[Findings or N/A]

### 2. Missing pieces
[Findings or N/A]

### 3. Redundancies
[Findings or N/A]

### 4. Interface problems
[Findings or N/A]

### 5. Inconsistencies
[Findings or N/A]

### 6. Over-engineering
[Findings or N/A]

### 7. Scope creep
[Findings or N/A]

## Summary
[Findings ranked by impact — as many or as few as the review warrants]

## Recommended actions
[Concrete next steps, ordered by priority]
```

The consolidated report adds:

```
## Reviewer agreement
[Which findings were convergent (both reviewers), divergent (one reviewer only), or unresolvable (consolidator couldn't adjudicate)]

## Findings excluded
[Reviewer findings not included in the report, with one-line reason per item. If none, write "None — all reviewer findings included."]
```

## How to invoke

The main session orchestrates the audit:

1. Define scope — which files/systems to review.
2. Launch Reviewer 1A and 1B as parallel Opus agents, each writing to a separate file (e.g. `audit_{scope}_r1a.md` and `audit_{scope}_r1b.md`).
3. After both complete, launch the Consolidator as an Opus agent with both review files, writing the final report to `audit_{scope}.md`.
4. Delete the individual reviewer files after the consolidated report is reviewed.
