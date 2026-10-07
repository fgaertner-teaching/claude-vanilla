---
name: pre-submission-audit
description: "Final quality-control audit of a complete submission package before it goes to a journal: cross-references, table and figure numbers, sample sizes, variable names, citations, paper versus appendix versus response letter, a last language pass, the files to upload, and anonymisation for blind review; plus a check against a named journal's author guidelines when the user supplies them. ALWAYS use this skill when the user is about to submit or resubmit a manuscript, or is closing the last items before a submission deadline; do not call a package ready to submit without offering it. Not for a draft still being written (use auditor for structure, author for prose) and not a judgment of the science."
effort: high
---

# Skill: Pre-Submission Audit

**Purpose:** Be the last line of defence before a manuscript leaves: find every inconsistency,
dangling reference, missing file and identity leak while it can still be fixed.
**Load when:** a paper, appendix and (for a revision) response letter are about to be submitted.
**Skip when:** the text is still being drafted or restructured; this is a final step.
**Modifies behavior:** exhaustive, section-by-section checking with every category explicitly
confirmed; nothing passes silently.

**What this checks, and what it does not.** It checks the package **against itself**:
consistency, completeness, production quality. It needs no outside input. It does not judge
whether the science is good (use `auditor` or a colleague), it does not rewrite prose (findings
about wording go to `author`), and it does not know a journal's rules unless the user supplies
them (§ 3).

---

## How to run it

1. **Collect the package:** main paper, online appendix, response letter and cover letter (for a
   revision), and the analysis code if available. Prefer the source files (`.tex`, `.bib`) plus
   the compiled PDFs: the PDF shows what reviewers see, the source shows what the PDF hides.
2. **Run the consistency audit (§ 1)**, ideally in a fresh subagent given only the package and
   the prompt below. *Why:* a context that helped write the paper reads what it meant, not what
   is on the page. Expect it to take a while for a full package; that is the point.
3. **Run the language pass (§ 2).**
4. **If a target journal is named, run the guidelines check (§ 3).**
5. **Assemble the upload (§ 4)**, including the anonymisation check for blind review.
6. **Report** one list sorted by severity, and let the user decide what to fix. Re-check every
   fix in the compiled PDF.

## § 1 The consistency audit (prompt)

> You are a meticulous referee, technical editor and production manager combined. Audit all
> attached documents (main paper, online appendix, response letter, if provided) line by line
> as one interconnected submission package.
>
> Do not summarise the paper. Do not assume correctness. Do not skip any section, table,
> figure, footnote or appendix. Work page by page. For each issue, quote the exact text or
> element, give its location (page, section, table, column, row) and say precisely why it is a
> problem. Mark severity: 🔴 Major (factual errors, contradictions, wrong references, missing
> elements), 🟡 Medium (ambiguities, inconsistencies that could confuse), 🟢 Minor (typos,
> formatting). Where you are unsure, write "Needs author verification" instead of passing over
> it. When a category is fully checked and clean, write "Checked — no issues detected", so
> nothing is silently skipped. Process the main paper, then the appendix, then the response
> letter, then check across documents.
>
> **1. Cross-references and citations.** Every table, figure, equation, section and appendix
> referenced in the text exists and is described correctly (column, sign, magnitude,
> significance). Every table and figure is referenced at least once. Flag vague references ("the
> table above"). Every citation is in the reference list and every listed reference is cited;
> formatting is consistent (et al., "and" versus "&"); flag "forthcoming" or working-paper
> entries that may now be published.
>
> **2. Tables (all of them).** Plausible values (shares 0–100, correlations −1 to 1, R² 0 to 1,
> N a positive integer). N consistent within and across tables and with the text. Stars defined
> and identical across tables. Standard errors or t-statistics labelled consistently. Consistent
> decimals. Sequential numbering, consistent appendix scheme, tables in order of first
> reference. Notes explain every symbol and abbreviation and do not contradict the text.
>
> **3. Figures (all of them).** Sequential numbering; captions match content; axis labels and
> legends present and correct; text claims about figures match what they show.
>
> **4. Variables.** List every variable mentioned anywhere, where it is defined and where it is
> used. Flag undefined or unused variables, renaming between sections, notation drift ("ROA"
> versus "Roa"), and an abbreviation used before it is introduced. If there is a variable
> definitions table, check it covers every variable in the regression tables.
>
> **5. Sample and data.** Sample period, sample size, subsamples (do they add up?), data sources
> and filters described the same way everywhere.
>
> **6. Methods.** The model in the text matches the equation; controls, fixed effects ("Firm FE:
> Yes") and clustering in the text match the tables and their notes; every robustness test
> described in the text appears in a table, and vice versa.
>
> **7. Structure and formatting.** Section numbering sequential; the roadmap paragraph matches
> the actual sections; footnotes sequential and not contradicting the text, with no critical
> information hidden in a footnote; consistent number formats, abbreviations ("e.g.," versus
> "for example"), fonts; all brackets and quotation marks closed.
>
> **8. Across documents.** Paper ↔ appendix: every reference points to an existing element,
> every appendix element is referenced, definitions and results agree. Paper ↔ response letter:
> every promised change is actually in the paper, with correct table, figure and section
> numbers; new analyses are numbered, referenced and explained. Appendix ↔ response letter:
> every new appendix item mentioned exists.
>
> **9. Code ↔ output (if code is attached).** Reported coefficients, standard errors and
> significance match what the code produces; variable names and sample construction (filters,
> exclusions, dates) match the paper; flag any number in the paper that no code output produces.
>
> **10. Common slips.** Table references off by one after reordering; a paragraph describing
> Table 3 copied from Table 2's and not updated; stars in the text that differ from the table;
> rounding that differs between text and table; an unstated dependent variable; "Table A3" in the
> text but "Table A.3" in the appendix.
>
> **Output:** findings grouped under the ten headings above, then a summary table (Issue #,
> Location, Category, Severity, Description) sorted by severity. Work slowly; completeness matters
> more than speed. When in doubt, flag it.

*(Adapted from a prompt shared publicly by a researcher, 2026.)*

## § 2 The language pass

Walk the whole text once more for language, as one would for a purely human-written manuscript:
load `author`, read its `diagnostics.md`, and run the full catalogue over the complete document
(this is the one time the whole document, not only the changed parts, gets read). Report the
findings as a separate group: wording is the authors' call, and a flagged pattern can be
legitimate (see the false alarms in `diagnostics.md` § 7). Also check: no `\claude{}` wrappers,
`\todo` notes, comments-as-notes or draft markers left in the rendered PDF.

## § 3 Checking against a journal's author guidelines

Only with the guidelines in hand. **Never state a journal's requirement from memory**: limits and
styles change, differ between journals of one publisher and between article types, and a
plausible half-remembered rule ("abstracts are capped at 250 words") reads exactly like a
checked one.

- **Inputs:** the guidelines text (pasted, saved, a PDF, or a page Claude can actually fetch),
  the article type (research article, short paper, registered report), and the stage (first
  submission or revision; many journals accept any format at first submission).
- **Every rule checked is quoted from the guidelines** next to the finding.
- **Silence is reported as silence:** if the guidelines say nothing about, say, a funding
  statement, report `not specified`, not a violation.
- If the guidelines cannot be obtained, do not run this part; say what is needed.
- Conformance predicts nothing about acceptance; never imply it does.

```
# WRONG — sounds checked, is not
Abstract is 261 words; most journals cap abstracts at 250.
# RIGHT — quoted and traceable
Abstract is 261 words; limit is 200: "The abstract should not exceed 200 words." (Guide for Authors, 2.3)
```

## § 4 Assembling the upload

**Bibliography.** If the journal takes LaTeX source, upload the `.bib` **and** the `.bbl` from
the same compile that produced the submitted PDF. The `.bbl` is the reference list as rendered
and proofread; the `.bib` lets the publisher's system recompile. A `.bbl` older than its `.tex`
is stale and must not ship. Check that the name in `\bibliography{}` / `\addbibresource{}`
matches the uploaded file name. Strip private fields (`abstract`, `keywords`, `comment`, file
paths) from the shipped `.bib`; uncited entries are harmless.

**Blind review: check every file that ships, not only the PDF.**

- **The `.tex` source:** authors often keep the author block, affiliations, e-mails and the
  funding acknowledgement **commented out** for later. Comments do not render, so a check of the
  PDF says nothing about them, and source uploads carry them to the reviewers. Remove them from
  the **shipping copy only**; the working file needs them back at acceptance.
- **The PDF's metadata** (author and title fields set by `hyperref`'s `pdfauthor`, or by the
  editor that produced it) and file names.
- **The text:** self-citations written in the first person ("as we show in Smith 2024"),
  acknowledgements, funder and grant numbers, pre-registration links that name the authors,
  institution names.
- **The `.bib`:** entries for the authors' own pre-registration or working papers that identify
  them.
- Search every shipped file for each author's surname, given name, institution, e-mail domain
  and funder, in plain and accented spellings (`Müller`, `M{\"u}ller`, `Mueller`).

**Last checks.** Journal name, editor name and manuscript number are right in the letters; the
files are named as the journal asks; the uploaded PDF is the one just compiled.

## Improving this skill

When something slips through to the journal or a referee report, add the check that would have
caught it to the right section here.
