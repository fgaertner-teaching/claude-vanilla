# Sections and document types

**Load when:** drafting or restructuring a specific part of a paper (introduction, related work,
methods, results, discussion), a referee response or cover letter, a grant proposal, a decision
memo, or a pitch to a potential co-author.
**Skip when:** line-editing prose whose structure is already settled (use `diagnostics.md`), or
formatting tables and figures (`research-paper`).

Each part lists the moves it must make, in their usual order, and the failures reviewers flag.
The order is a default; the moves are not optional.

---

## Introduction (5–8 paragraphs)

1. **Hook:** a concrete fact, puzzle or open question. One paragraph.
2. **Gap:** what the three to five closest papers do and what they leave open. Name them.
3. **Contribution:** what this paper finds, stated as an answer, by paragraph 2 or 3.
4. **Design:** data, design and identification in one paragraph, enough to judge credibility.
5. **Results:** the main numbers with magnitudes ("a 14 percentage-point increase").
6. **Scope:** what the paper does not claim.
7. Roadmap: one sentence or none.

Failures: facts piled up with no "but"; contribution buried; half the introduction spent on
method detail; a generic gap ("the literature has not explored X"); "significant effects" with
no number.

## Related work or theory framing (3–6 paragraphs)

Open with the closest paper, not "a large literature". One paragraph per closest paper: what it
does, what it finds, what remains open. Then the distinguishing claim: "X showed Y; we show Z
because W". Name the theoretical lens if one organises the results, and make sure the results
section uses it again.

Failures: a survey ("many studies have examined"); citation piles with no paper discussed;
paragraphs that end without saying what is missing; a theory introduced and never used.

## Methods, design and data (4–8 paragraphs)

Sample and data source (who, where, when, how many, why that many); design and assignment;
procedures in the order participants met them; outcome variables with units, primary versus
secondary, pre-registered versus exploratory; the identifying assumption, stated outright;
estimation (the equation, standard errors, clustering, fixed effects, the package); power;
pre-registration link and any deviations.

Failures: "as pre-registered" without the detail; no equation; standard errors whose type is not
stated; "ample power"; the primary outcome named late.

## Results (2–3 paragraphs per main test)

Per subsection: what is tested and why, the specification, the main number in real units,
significance next to the magnitude, what survives the robustness checks, then what it means.
Order across subsections: descriptive, primary tests, secondary, robustness. Comparisons across
outcomes get their own subsection at the end. Every table and figure has a paragraph that states
its claim. Nulls are reported as findings. Benchmarks are derived, not asserted.

## Discussion and conclusion (4–7 paragraphs)

A plain-language summary; what the result implies (for theory, for practice); when it holds and
when it may not; the strongest alternative explanation, named and engaged; limitations, ranked;
concrete next questions with the design that would answer them; a calibrated close.

Failures: a first paragraph that only repeats the results; "other interpretations are possible"
without naming one; "future research could explore other contexts"; implications scaled beyond
the evidence.

## Referee responses and the cover letter

**The package:** a cover letter to the editor, a point-by-point response, the revised manuscript
(clean, plus a marked-up version if the journal wants one).

**Cover letter (one page):** thanks, the two or three most important changes in plain words,
disagreements with referees (the editor reads this; referees usually do not), and how
contradictory requests were resolved.

**Point-by-point response,** after a short opening that thanks the referees and lists the main
changes:

```
**Comment 1.1**
> The referee's words, verbatim.

Direct answer first. Then what changed, where, and why.

> *Revised text (p. 12, Section 4.2):* "The quoted new text, so the referee does not have
> to search the manuscript."
```

**Tone:** grateful, not grovelling ("Thank you for this point", not "We are deeply indebted",
thirty times); direct, not defensive (a misunderstanding usually means the text was unclear, so
fix the text); specific ("we added Table A3"), never just "Done"; honest about what could not be
done and why. Every promised change must exist in the manuscript; check each one before sending.

## Grant and research proposals

Reviewers often come from neighbouring fields, so the jargon pass matters most here: every term
outside the panel's discipline is glossed at first use. Follow the funder's structure and
conventions exactly (section order, page limits, person: a single applicant usually writes "the
applicant", not "we"). Claim assertively but not grandly ("a new contribution", not
"groundbreaking").

**Over the page limit:** new material competes with the weakest content already in the document,
not with the space left over. Cut in this order: layout waste and template decoration, then
redundant citations and restatements, then prose, and only then content. Page cost is lumpy (a
few added lines can push several bibliography entries onto the next page), so build the PDF and
look instead of estimating whether a change fits.

## Decision memo (for the researcher's own go / no-go)

First write one paragraph a smart non-specialist would find compelling: the question, why it
matters, how to answer it, what you expect. **If that paragraph cannot be written, the idea is
not ready; say so** rather than polishing it. Then, in one or two pages: summary; what is new in
one sentence; how it works (identification in plain language, assumptions stated); what the main
result would look like (a sketch of the figure or table); what could go wrong, ranked and
specific; what it takes (data, money, time, people); a verdict and the single uncertainty a
pilot would resolve. Direct and analytical; weaknesses as visible as strengths.

## Pitch to a potential co-author (one page)

Hook from the co-author's field, not yours; the gap against the closest papers; the idea and the
expected result; what the result would look like; **why together** (what exactly they would
bring); feasibility (data, timeline, cost); one concrete next step ("Could we talk for 30
minutes about whether …?"). Adapt the lead: an economist wants the identification, a
psychologist the mechanism, a data scientist the technical problem, a practitioner the
real-world stakes.
