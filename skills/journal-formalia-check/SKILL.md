---
name: journal-formalia-check
description: "Check a manuscript against a SPECIFIC journal's or conference's author guidelines: length limits, structure, reference style, figures, declarations, blinding. Rules in, violations out. Never state a journal's requirement from memory, even without this skill: with no guidelines supplied, the check does not run. ALWAYS use this skill when the user asks whether a paper meets a named journal's or conference's formal requirements or author guidelines (a Formaliaprüfung); do not answer that question without loading it first. Not for whether the paper agrees with itself or is ready to upload (pre-submission-audit), not a judgment of the science, and not a prediction of acceptance."
---

# Skill: Journal Formalia Check

**Purpose:** Verify a manuscript against a specific venue's author guidelines.
**Load when:** the user asks whether a paper meets a named venue's rules; without the guidelines
in hand, ask for them (§0).
**Skip when:** no target venue yet; whether the paper agrees with itself, or the upload and
anonymisation (`pre-submission-audit`); whether the science holds (`auditor`, `referee2`).
**Modifies behavior:** rules-in/violations-out detection; no scoring, no acceptance prediction.

**Scope, and what this is NOT.** This checks conformance to **one named venue's stated
rules** and nothing else. Three neighbouring jobs it does not do, each of which needs a
different instrument or pass:

- **Internal consistency of the manuscript:** cross-references, table and figure
  numbering, sample sizes that must add up, agreement between paper, appendix and response
  letter. That is the `pre-submission-audit` skill: it needs no external input, and this check
  will not catch it.
- **Whether the science is any good:** contribution, identification, whether the claims
  are supported. Not in scope at any point (the `auditor` skill, the `referee2` agent, a
  colleague).
- **Whether the paper will be accepted.** Explicitly not. Conforming perfectly to the
  guidelines predicts nothing about the editor's decision, and saying otherwise is the one
  thing a formalia check must never imply.

---

## §0 ⛔ THE ONE RULE THAT MAKES THIS SAFE

**Never assert a journal's requirements from memory. Not one. Not even the obvious ones.**

Author guidelines change without announcement, differ between a publisher's journals, and
differ between article types within one journal. A plausible-sounding requirement you
half-remember ("abstracts are capped at 250 words", "this publisher uses APA") is the
single most likely way this check does damage: it reads as authoritative, the author acts
on it, and the real limit was 200, or the journal moved to a numbered style two years ago.

The failure mode is specific and worth naming, because it does not feel like guessing: **a
rule you cannot ground gets stated with the same confidence as one you can.** Nothing in
the output distinguishes them unless you make it.

Therefore:

- Every rule you check against **must be traceable to supplied guideline text**, and you
  quote that text in the rule set (§1).
- If you cannot obtain the guidelines, **you do not run this check.** Say so, say what you
  need, stop. A partial check silently framed as a full one is worse than no check.
- Where the guidelines are *silent* on something, that is a finding of its own kind
  (`not-specified`), never an invitation to substitute a general convention.

```
# WRONG: plausible, unsourced, and indistinguishable from a real finding
J.04  violates   Abstract is 261 words; most journals cap abstracts at 250.

# WRONG: the guidelines were silent, and a general convention got promoted to a rule
J.09  violates   Funding statement is missing.

# RIGHT: grounded, quoted, traceable
J.04  violates   Abstract is 261 words; this venue caps it at 200.
      expected:  "The abstract should not exceed 200 words." (Guide for Authors, §2.3)

# RIGHT: silence reported as silence
J.09  not-specified   The guidelines say nothing about a funding statement. Common
                      desk-reject cause elsewhere; NOT a requirement of this venue.
```

---

## Inputs

| Input | Required | Notes |
|---|---|---|
| The manuscript | yes | Source file (`.tex`/`.docx`) preferred over PDF: a PDF hides word counts, styles, and field structure |
| The venue's author guidelines | **yes** | Pasted text, a saved page, the "Guide for Authors" PDF, or a URL you can actually retrieve |
| Article type | yes | Research article / review / short paper / registered report: limits differ per type, and this is the most common source of a wrong rule set |
| Submission stage | yes | First submission vs revision: many venues relax formatting at first submission ("format-free submission") and enforce it only on acceptance |
| Blinding | yes | Double-blind / single-blind / open: decides whether §2.7 applies at all |

**If the article type or stage is unknown, ask before running.** Checking a research
article against a review's word limit produces a confidently wrong violation list.

---

## §1 Phase 1: build the rule set FIRST, and show it

Do this as a separate, visible step before looking at the manuscript. Extracting the rules
and judging the manuscript are two different jobs; fusing them lets a misread requirement
silently corrupt every finding downstream, with nothing to inspect afterwards.

Read the guidelines in full and emit a table. Give every rule an id (`J.01`, `J.02`, …):

| id | Requirement | Verbatim guideline text | Scope | Checkable here? |
|---|---|---|---|---|
| J.01 | Abstract ≤ 200 words, unstructured | "The abstract should not exceed 200 words…" | research article | yes |
| J.02 | References: numbered, Vancouver | "References must be numbered consecutively…" | all | yes |
| J.03 | Figures ≥ 300 dpi, TIFF or EPS | "Figures should be supplied at a minimum of 300 dpi…" | all | **no: needs the source files** |

Rules that are conditional on article type or stage carry that in `Scope`. Rules you cannot
verify from what you were given are marked `no` with the reason; they go into the report as
*needs author verification*, never as passes.

**Then state the rule set's own limits before proceeding:** which sections of the guidelines
you had, which you did not, and anything ambiguous enough that two readers would disagree.
If the guidelines were retrieved from the web rather than supplied, say so and give the URL
and retrieval date: a fetched page is evidence, but weaker evidence than a document the
author handed you, and the reader is entitled to know which they are getting.

---

## §2 Phase 2: check the manuscript, rule by rule

Walk the rule set in order. For each rule, one of four verdicts:

- **`conforms`**, with the evidence that shows it
- **`violates`**, with `evidence` (what the manuscript does), `expected` (what the rule
  requires, in the guideline's own terms), and the rule id
- **`needs-verification`**: the rule is real but not checkable from what you have
- **`not-specified`**: the guidelines say nothing; flag only if it is a common desk-reject
  cause, and label it plainly as *not a requirement of this venue*

Cover at least these areas, **to the extent the guidelines address them**. This list is a
prompt for reading the guidelines, never a substitute rule set:

1. **Length:** total (words/pages), and per-section caps (abstract, intro, summary). Say
   how you counted and what you excluded (references? tables? captions?), because the
   journal's counting convention is itself a rule and is often stated.
2. **Structure:** required sections, their order, permitted heading depth, whether a
   structured abstract with named headings is required.
3. **Title and front matter:** title length, running head, keyword count and whether they
   must come from a controlled vocabulary, JEL/MSC/ACM codes, author/affiliation format,
   ORCID, corresponding-author details.
4. **References:** citation style in text, reference-list style, ordering, DOI
   requirements, preprint citation policy, maximum reference count.
5. **Tables and figures:** count limits, placement (embedded vs end vs separate files),
   caption position and format, numbering scheme, colour policy, resolution and file
   format, permission for reproduced material.
6. **Declarations:** funding, conflict of interest, data availability, code availability,
   ethics/IRB, informed consent, author contributions (CRediT), generative-AI use. These
   are cheap to check and a very common desk-reject cause.
7. **Blinding** *(only if the venue is double-blind)*: author names, affiliations,
   acknowledgements, funding statements naming the grant holder, self-citation phrased as
   "our previous work", identifying links to repositories or data, and **document metadata**
   in the source file. Report each hit with its location. (The search of every file that
   ships, with every name, is `pre-submission-audit` § 4; here, what the venue's rules require.)
8. **Supplementary material:** what is allowed, how it must be labelled and referenced.
9. **Mechanics:** line numbering, line spacing, font, margins, page numbering, file format
   and naming, cover letter, highlights, graphical abstract.

**Detection, not coaching.** Report what is wrong against which rule. `expected` states what
the venue requires; that is quoting the rule, not writing the fix. Do not redraft the
author's text.

---

## §3 What you cannot see: say so, do not estimate

Be explicit rather than silently approximate. Common cases:

- **Word counts from a PDF** are unreliable; from `.tex` they depend on whether you counted
  macros, captions, footnotes and the bibliography. State your method or mark it
  `needs-verification`.
- **Figure resolution, colour mode, embedded fonts** need the actual image files.
- **Metadata blinding** needs the source file, not a PDF rendering.
- **Whether a declaration is *accurate*** is not yours to judge, only whether it is present
  and in the required form.

A `needs-verification` line that names the exact check the author must run is a useful
finding. A guessed number presented as measured is a defect.

---

## Output format

```
## Rule set
(the §1 table, plus the limits statement: always included, even when nothing violates)

## Violations
J.07  violates   Abstract is 261 words; the guidelines cap it at 200.
      evidence:  "…" (first and last words, so the author can locate it)
      expected:  "The abstract should not exceed 200 words." (Guide for Authors, §2.3)

## Needs author verification
J.03  Figure resolution: supply the source images or confirm ≥300 dpi.

## Not specified by this venue
(only entries that are genuine desk-reject risks elsewhere; labelled as not required here)

## Conforms
(one line per rule, so the author can see nothing was skipped)
```

Close with a count by verdict. **No score, no acceptance judgment, no "this looks ready".**
Whether the paper is any good, and whether it will be accepted, are different questions and
this instrument answers neither.

---

## Traps

This list grows. When Claude gets a guidelines check wrong, Claude proposes adding the mistake
and the rule that prevents it here, and adds it once the user agrees.

- **A consistency check answers the wrong question.** The user asked whether a paper met a
  journal's rules, and Claude ran `pre-submission-audit`'s consistency audit instead; the
  mix-up survived a later check. Both are "formalia" in everyday speech, so they read as one
  job. The test that tells them apart: does the check need the journal's guidelines as an input?
  If yes, it is this skill. If the user has not supplied the guidelines, Claude asks for them.

## Improving this skill

This file deliberately contains **no journal facts**, so it does not go stale the way a
rule catalogue would: the guidelines are supplied per run. What can degrade is the
process. Watch for these and amend here:

- **An ungrounded rule reached the output.** The most serious failure. If a violation was
  reported without a quote traceable to the supplied guidelines, §0 was not obeyed;
  strengthen the §1 rule-set table rather than adding a warning.
- **The rule set was built for the wrong article type or stage**, producing a confidently
  wrong violation list. If this happens, make those inputs blocking rather than merely
  requested.
- **A `needs-verification` was quietly upgraded to a pass** because a number looked
  plausible. Add the specific measurement to §3.
- **Recurring gaps between what venues specify and what §2's areas anticipate:** if
  several runs surface a requirement class the §2 list never prompted (data-citation
  policy, reporting checklists such as CONSORT or PRISMA, registered-report stage rules),
  add the class as a numbered area.

Record what a run found that the previous version would have missed; that is the signal
worth keeping. Do not accumulate journal-specific rules here: they belong in the
guidelines document, which is an input, not part of this file.
