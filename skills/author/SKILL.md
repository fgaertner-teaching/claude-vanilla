---
name: author
description: "Drafting and editing prose that readers outside the project will read: papers and abstracts, research and grant proposals, referee responses and cover letters, memos for colleagues or co-authors. Finds AI-written prose tells (em-dashes, drumbeat colons, 'not X, but Y', 'delve', 'crucial', empty summary closers, stated importance) and checks clarity, structure and claim strength. ALWAYS use this skill before writing or revising such prose, and state the mode (draft or edit) before the first change. Do not draft or rewrite it directly without loading this skill first. Not for chat replies, commit messages, code, skill files, or the project's internal notes and tracking files. For LaTeX tables, figures or the bibliography, also load research-paper."
---

# Skill: Author

**Purpose:** Write and edit academic prose that reads as written by a careful researcher in the
field: clear for a reader outside the subfield, calibrated in its claims, and free of the
patterns that mark text as machine-written.
**Load when:** drafting or editing any text a reader outside the project will see: paper,
abstract, proposal, referee response, cover letter, a memo for a colleague.
**Skip when:** chat, commit messages, code, internal notes whose only reader is the user or
Claude.
**Modifies behavior:** a declared mode before the first edit; drafts are followed by a self-audit;
edits run detect, then confirm with the user, then fix; the user's own prose is touched lightly.

**Sub-files:**

- `diagnostics.md` — the catalogue of AI-prose tells, with fixes. **Read it before every
  self-audit or edit pass.** A pass run from memory covers only the classes you happen to
  recall (usually the punctuation ones) and misses the rest; say so if you skipped it.
- `sections.md` — what each part of a paper must do (introduction, related work, methods,
  results, discussion), plus referee responses, grant proposals, decision memos and co-author
  pitches. Load it when drafting or restructuring one of these.

**Also load** `research-paper` when the text sits in a `.tex` file or touches a table, figure
or citation.

---

## 1. Declare the mode first

Before any change, say which mode applies:

- **Draft** — writing new prose from notes, an outline, results or an empty section.
- **Edit** — revising existing prose. Say whose: **Claude's** (full diagnostic) or **the user's
  or a co-author's** (light diagnostic, § 4). If you cannot tell, ask; when unsure, treat it as
  Claude's.
- **Audit only** — the user wants the list of problems, not a rewrite. Stop after the detect
  step.

*Why:* without a declared mode, finding problems and rewriting happen in the same pass, and the
rewrite reproduces the patterns it was meant to remove. The flat, machine-sounding quality of a
draft cannot be fixed in the generation pass that produced it.

## 2. Drafting

1. **Name the reader** in one line (a referee in the field? a cross-field grant panel? a
   co-author?). Every later choice of term and depth follows from it.
2. **Use the user's own prose as the model where there is some.** If the document already holds
   text the user wrote, read a page of it before drafting, so the draft matches their register.
   Ask which text is theirs; never infer authorship from style, because a document may mix their
   writing, co-authors' and Claude's.
3. **Start from the user's own notes or bullet points** and keep their order and emphasis. Let
   uneven content produce uneven rhythm: if one of two reasons matters more, it gets the longer
   sentence.
4. **Draft, then self-audit at once.** For any new passage of more than a few sentences, read
   `diagnostics.md`, run the detect step of § 3 on your own draft, fix everything it finds, and
   only then hand it over. Report briefly which classes you caught. *Why:* drafts reliably ship
   several AI tells despite good intentions; the immediate audit is what removes them.

Honest limit: no single pass removes everything. The user's own reading is the final check, so
tell them where you are least sure.

## 3. Editing: detect, confirm, fix

**Detect.** Read `diagnostics.md`, then produce a numbered flag list. Do not rewrite yet.

```
[1] p. 3, ¶2 — drumbeat colon — "The answer is simple: X." — fix: state X directly
[2] p. 3, ¶4 — REMOVE — "This highlights the importance of Y." — restates the previous sentence
```

Run four passes, each a separate lens:

1. **Necessity (cut beats rewrite).** For each sentence: does it add anything not already said
   in the paragraph, and would the argument stand without it? If it adds nothing, flag it for
   removal. Many tells (empty closers, stated importance, restatements) are fixed by deleting
   the sentence, not by polishing it.
2. **Skim test.** Read only the first sentence of each paragraph, in order. Together they should
   carry the argument, and each should state its paragraph's claim, not its setup. Flag weak
   openers and gaps in the chain.
3. **Jargon gloss.** Read as the target reader. Every term from another field (machine learning,
   psychology, software) is either replaced with the field's own word or defined in a clause at
   first use. Do not explain the reader's own discipline back to them.
4. **Catalogue.** Scan for the patterns in `diagnostics.md`, one family at a time, and record a
   line per family even when it finds nothing ("negate-then-assert: 0").

**Confirm.** Show the list and let the user choose (`fix 1, 3, 5` or "fix all em-dash flags").
Sort it by how decidable each item is: objective defects (a missing word, agreement, a name spelt
two ways) can be approved as a batch; judgment calls (a claim's strength, a term, whether to cut a
sentence) go one at a time, each as a **before / after** pair. *Why:* batching typos saves a
round, and burying a judgment call among typos gets it waved through unread.

**Fix.** Rewrite only what was confirmed. Then **re-check the rewrite**: a fix often reproduces
the same pattern in denser form (two parallel sentences become one sentence with two parallel
halves) or brings in a new one. Check at least the class you fixed, the punctuation classes, and
every pronoun or "the two" in the new text, which can silently point at a different noun after a
cut. Re-read the seam after every deletion.

## 4. Whose prose it is

- **Claude's prose gets the full catalogue.** Its typical failure is the AI register itself.
- **The user's and co-authors' prose gets a light pass** (`diagnostics.md` § 6): their
  macro-structure is usually sound, and imposing Claude's register on it is the failure to avoid.
  Do not restructure it or swap in fancier words unasked. Two exceptions apply to everyone:
  objective errors, and the patterns whose defect *is* excess length (restating, stating a rule
  and then its instance), which may be flagged in anyone's prose.
- **In a co-authored document, a register flag on a co-author's paragraph costs a conversation
  with that co-author.** Present factual defects first and separately; put style flags in a
  second, clearly optional group, and accept a "leave it" without argument.
- **Mark Claude-drafted paragraphs** if the user agrees, so they can rework them one at a time
  and see what is still machine-written:

  ```latex
  \providecommand{\claude}[1]{\textcolor{violet}{#1}}   % needs xcolor
  \claude{A paragraph Claude drafted.}
  ```

  Wrap whole paragraphs (or just the changed term, for a one-word swap); keep headings and tables
  outside. Remove every wrapper **and** the macro definition before submission.

## 5. Principles for the prose itself

**Clarity first.** Write for a first-year PhD student in the field: trained, but not in this
subfield. Prefer concrete nouns and active verbs. Three technical terms in a row without a plain
anchor means rewrite. *Why:* the writer cannot imagine not knowing what they know; the imagined
reader corrects for it.

**Structure**

- **Bottom line first.** The reader who stops after the first paragraph has the main point.
- **Every paragraph opens with its claim**; the rest elaborates, supports or qualifies.
- **Paragraphs of 3–7 sentences, with varied length.** Split walls at a real turn in the
  argument; one-sentence paragraphs only for deliberate emphasis. Uniform length is itself a tell.
- **Context, then the problem, then the response** (And, But, Therefore). A list of facts with no
  "but" has no reason to be read. Every section needs its own "but".
- **One demanding idea per sentence**, the important word at the end.
- **The same thing keeps the same name.** Swapping synonyms makes the reader wonder whether
  something new is meant.
- **The action goes in the verb.** "The implementation of the policy led to a reduction in X"
  becomes "the policy reduced X".

**Patterns worth using** (standard in economics and often under-used by Claude):
"First, … Second, …" for ordered points; a sentence with a count ("Two reasons follow") followed
by an actual enumeration; "By contrast" for a real contrast; "§3.1 shows" as a cross-reference;
**a worked example right after a general statement** ("As an example, consider …"), then the
other cases as a short list; **the regularity first, then each named exception in its own
sentence**, never "mostly X, with some exceptions" in one; rival interpretations each in their
own paragraph, then one on how they bear on each other.

**Framing and claims**

- **Position against the closest papers**, not "the literature": "X showed Y; we show Z".
- **Do not oversell**, and do not undersell: lead with what you can claim, then qualify once.
- **The abstract never shrinks the finding's reach** ("only", "a narrow subgroup", "may not
  generalise"). Precision is the safe move: name the population ("young German retail
  investors") instead of hedging.
- **Match the diction to the size of the claim.** An ordinary result in the voice of a discovery
  ("drives", "fundamentally reshapes") reads as machine-written and as overclaiming.
- **Dry and clear is correct academic register.** Do not add drama to fix dullness; fix
  unclarity instead.
- **Say what the design shows**, not "we cannot identify X". Do not list dimensions you
  considered and dropped, and do not commit to positions the argument does not need.
- **Name limitations yourself**, specifically; reviewers find them anyway.

**Results**

- Background and specification before the number; magnitude in real units before significance.
- Derive every benchmark in the text (or an appendix) instead of asserting it.
- A null result is a finding; report it as one.
- Never restate a number as its own interpretation ("0.27, meaning the effect is 0.27").

## 6. The reader was not in the room

Every sentence passes one test: **what does the reader do with it?** Delete sentences that only
document how the text was written:

- editorial decisions ("for completeness", "in the interest of brevity", "the order follows §1");
- references to things the reader cannot see (internal notes, earlier drafts, "as discussed",
  the reply to a referee);
- version history ("in this revision", "previously we treated X as Y");
- empty announcements ("In what follows, we …") and filler ("It is worth noting that");
- a rejected alternative nobody asked about ("handled once here rather than per section").

Orient forward ("§4 treats these three threats together") where a long document needs
navigation; never defend the choice.

**For readers outside the project entirely** (a colleague's feedback, a memo, a summary): no
internal vocabulary at all, no file names, IDs or tool names; locations in the reader's terms
("Section 3, second paragraph", "Table 2"). Test: could the reader resolve every reference with
only this text and the document it discusses? If not, add the missing piece or cut the
reference.

## Traps

This list grows. When Claude gets a drafting or editing task wrong, Claude proposes adding the
mistake and the rule that prevents it here, and adds it once the user agrees. A new prose tell
goes to `diagnostics.md` instead (see below).

- **An approved plan is not an approved wording.** Claude once edited four paragraphs of the
  user's own text after the user had approved a plan, then showed all four at once as a diff. The
  user could only veto, not choose. On the user's prose, Claude shows each change as a before /
  after pair and waits, even when the plan is already agreed.

  ```
  # WRONG: the plan is approved. Claude rewrites four paragraphs, then shows the diff.
  # RIGHT: the plan is approved. Claude shows paragraph 1 before / after, waits, then paragraph 2.
  ```

- **Claude talks itself out of a flag.** A self-audit saw three goals that each opened "The
  project will establish ... The result is ..." and dismissed the sameness as deliberate list
  parallelism. The user then caught it. When Claude finds a reason why a flagged pattern is fine
  here, Claude still runs that pattern's test from `diagnostics.md` and reports the result.
- **A style fix quietly changes the claim.** "Values no input produces" was rewritten as "values
  that an input does not produce". The new version reads more naturally but drops the "no", which
  was the point. After each fix, Claude checks that the sentence still claims exactly what it did
  before. A fix that loosens the logic is worse than the tell it removes.

## Improving this skill

When the user rejects a fix ("that is worse") or catches a tell the catalogue missed, propose
adding the case to `diagnostics.md`: the pattern, an example, the fix, and when it is a false
alarm.
