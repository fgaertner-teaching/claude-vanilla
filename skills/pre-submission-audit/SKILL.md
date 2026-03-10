# Pre-Submission Audit Skill

**Load when:** Preparing to submit or resubmit a manuscript to a journal — run this audit on the full submission package (paper, online appendix, response letter).
**Skip when:** Working on analysis, writing, or code — this is a final quality-control step, not a mid-project tool.

---

## How to use

Attach all documents (main paper, online appendix, response letter if applicable) and send the prompt below. Works best with a large-context model (Claude Opus or equivalent). Expect 5–15 minutes for a full package.

This audits the *manuscript* (cross-references, consistency, production quality). If you also have a code audit workflow, run both before submission.

---

## Prompt

You are acting as a meticulous academic referee, technical editor, and production manager combined. Your task is to perform an exhaustive, line-by-line consistency and accuracy audit of all attached documents (the main paper, the response letter to the editor/reviewers, and the online appendix, if provided). These documents form a single submission package and must be treated as an interconnected whole.

Do not summarize the paper. Do not assume correctness. Do not skip any section, table, figure, footnote, or appendix. Treat this as a formal, pre-submission quality-control review as if you were the last line of defense before the manuscript goes to the journal. Proceed systematically and explicitly document every issue you find, no matter how minor.

### General instructions

- Work through each document page by page, paragraph by paragraph.
- When you find an issue, quote the exact text or element and state precisely why it is problematic.
- Distinguish between: 🔴 Major issues (factual errors, contradictions, wrong references, missing elements), 🟡 Medium issues (ambiguities, inconsistencies that could confuse readers), 🟢 Minor issues (typos, formatting inconsistencies, stylistic irregularities).
- If a category has been fully checked and no problems were found, explicitly confirm this so I know nothing was skipped.
- If you are uncertain about something, flag it as "Needs author verification" rather than silently passing over it.
- Process all documents in sequence: first the main paper, then the online appendix, then the response letter — and finally perform cross-document consistency checks.

### 1. Cross-reference and citation audit

**1a. Tables** — Verify every table referenced in the text exists and is correctly described (correct column, sign, magnitude, significance). Every table must be referenced at least once. Flag vague references (e.g., "as shown in the table above").

**1b. Figures** — Same checks as tables. Verify axis labels, legends, and visual content match what the text claims.

**1c. Equations** — Verify every equation number referenced exists. Check that text descriptions match actual equation content.

**1d. Sections, appendices, supplementary materials** — Verify all cross-references to sections, appendices, and footnotes are accurate.

**1e. Bibliographic references** — Every citation must appear in the reference list and vice versa. Flag orphan references. Check formatting consistency (author names, year, et al. rules, ampersand vs. "and"). Flag "forthcoming" or "working paper" entries that may now be published.

### 2. Table audit (all tables without exception)

For every table in the main paper and online appendix:

**2a. Internal consistency** — Check that numbers are plausible (percentages 0–100, correlations –1 to 1, N is a positive integer, R² between 0 and 1). Verify N is consistent within and across tables and with what the text states. Check that significance stars are defined and consistent across all tables. Verify standard errors / t-statistics / z-statistics are consistently formatted and labeled. Check decimal place consistency.

**2b. Numbering and ordering** — Sequential, unique, no gaps. Appendix tables follow a consistent scheme. Tables appear in order of first reference.

**2c. Table notes** — Every symbol, abbreviation, and notation explained. Notes do not contradict text or other tables. Sample, time period, and methodology descriptions consistent with text.

**2d. Alignment with text** — Verify every claim about a table: correct sign, magnitude, significance level, column, panel.

### 3. Figure audit (all figures without exception)

Sequential numbering. Every figure has a caption that accurately describes content. Axis labels present and correct. Legends match data series. Text claims about figures are visually consistent.

### 4. Variable definitions and labels

**4a. Variable inventory** — Compile a complete list of all variables mentioned anywhere (text, tables, figures, appendices, footnotes). Record where each is defined and all locations where it appears.

**4b. Consistency** — Every variable defined at least once. Names, abbreviations, and labels identical across all sections — no silent renaming, no notation drift (e.g., "ROA" vs. "Roa"), no switching between full name and abbreviation without establishing equivalence. Flag undefined variables and defined-but-unused variables. If a variable definitions table exists, verify it covers all variables used in regression tables.

### 5. Sample and data consistency

Verify the stated sample period is used consistently throughout. Check that stated sample size is consistent across text, tables, and notes. Verify subsample descriptions and sizes are consistent. Check data source descriptions for consistency. Verify sample filters are described consistently and resulting sample sizes make sense.

### 6. Methodology and econometric consistency

Verify the empirical model in the text matches what is shown in equation form. Check that control variables in the text match those in the tables. Verify fixed effects described in the text match what is reported in table rows (e.g., "Industry FE: Yes"). Check that standard error clustering is stated consistently in all relevant table notes. Verify robustness tests described in the text appear in the tables and vice versa.

### 7. Structural and formatting checks

**7a. Section structure** — Sequential numbering, no gaps or duplicates. "Roadmap" paragraph matches actual section structure.

**7b. Footnotes** — Sequential, unique. Flag footnotes containing critical information that should be in the main text. Footnotes do not contradict main text.

**7c. Formatting** — Consistent fonts, bold, italics in tables and text. Consistent number formatting (thousands separator, decimal separator). Consistent abbreviations (e.g., "e.g.," vs. "for example"). All parenthetical asides, quotation marks, and brackets properly closed.

### 8. Cross-document consistency (critical)

**8a. Main paper ↔ Online appendix** — Every reference from the main paper to the appendix points to an element that exists. Every appendix element is referenced from the main paper. Variable definitions, sample descriptions, and methodology are consistent. Results discussed in both documents are consistent.

**8b. Main paper ↔ Response letter** — Every change promised in the response letter is reflected in the paper. Every table/figure/section reference in the response letter is correct. Flag unimplemented promises. Check that new analyses added in response to reviewers are properly integrated (numbered, referenced, noted).

**8c. Online appendix ↔ Response letter** — Every new appendix item referenced in the response letter exists in the appendix.

### 9. Code-to-output consistency (if analysis code is provided)

If Python or R scripts are provided alongside the manuscript:

- Verify that reported coefficients, standard errors, and significance levels in the tables match what the code actually produces.
- Check that variable names in the code match those defined and used in the paper.
- Verify that sample construction in the code (filters, exclusions, date ranges) matches the description in the paper.
- Check that any manually reported summary statistics match what the code would produce.
- Flag any hardcoded numbers in the paper that cannot be traced to a code output.

### 10. Common pitfalls checklist

Specifically check for:

- Table references off by one (very common after reordering tables during revision)
- Copy-paste errors where a paragraph describes Table 3 but was copied from the description of Table 2 and not updated
- Significance levels in text that don't match the stars in the table
- Sample sizes that don't add up (subsamples should sum to full sample)
- Control variables listed in text that don't appear in the table, or vice versa
- Inconsistent rounding (e.g., "0.034" in text but "0.0341" in table)
- Orphan references (cited but missing from reference list, or in list but never cited)
- Tables where the dependent variable is not clearly stated
- Appendix items referenced with wrong numbering scheme (e.g., "Table A3" in text but "Table A.3" in appendix)
- "Forthcoming" references that are now published

### Output format

Organize findings into clearly labeled sections following the structure above (Sections 1–10). Within each section:
- Quote or precisely describe the problematic element with its exact location (page, section, table, column, row).
- Explain why it is an issue.
- Mark severity: 🔴 Major / 🟡 Medium / 🟢 Minor.
- If no issue is found in a category, explicitly state: "Checked — no issues detected."

At the end, provide a summary table with columns: Issue #, Location, Category, Severity, Description. Sort by severity (major first).

Work slowly and carefully. Precision and completeness are more important than speed. When in doubt, flag it.

---

*Prompt source: [LinkedIn post](https://www.linkedin.com/posts/activity-10-prompt-for-consistency-checks-before-journal-re-submissions) by an anonymous researcher, shared Feb 2026. Adapted for this workflow: STATA references replaced with Python/R; Section 9 reframed for code-to-output consistency.*
