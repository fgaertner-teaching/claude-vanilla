# Diagnostics: the catalogue of AI-prose tells

**Load when:** before any self-audit of a draft, before any edit or audit pass on outside-facing
prose (the detect step of `SKILL.md` § 3).
**Skip when:** in the confirm or fix step (the flag list is the input there), or for chat.

Each entry: the pattern, a short example, the fix. Scan one family at a time and record a line
per family, even "0 found". A hit is a candidate, not a verdict: § 7 lists when a pattern is
legitimate.

---

## § 1 Vocabulary

**Never use (reviewers read these as machine-written):** delve, tapestry, realm, landscape and
navigate (as metaphors), pivotal, seamless, intricate, nuanced, holistic, multifaceted, myriad,
plethora, prowess, treasure trove, utilise/utilize, leverage (as a verb). *robust* only in
"robust standard errors" and "robustness check". Phrases: "complex and multifaceted", "intricate
interplay", "plays a crucial role".

**At most once per document, never two in one paragraph:** crucial, underscore, showcase,
foster, bolster, harness, garner, align with, invaluable, meticulous, transformative,
groundbreaking, akin to, amidst, avenue (as "direction"), interplay. Plain replacements: show,
strengthen, use, matches, like, during, interaction.

**Academese → plain:** demonstrate → show; methodology → method; in light of → given;
elucidate → explain; endeavour → try; notwithstanding → despite; comprised of → consists of.

**Colloquial → formal:** a bit, pretty good, kind of, sort of, stuff, things, okay-ish → a
quantified description; sentence-initial So, Plus, Anyway, And so → drop. "headline result" →
main result. Intensifiers **genuinely, really, truly, actually** → delete (keep *actually* only
for a contrast with a stated expectation).

**Other fields' jargon in an economics text:** probe (verb) → test, measure; pipeline (for
anything that is not one) → process; scaffolding, hooks, blast radius, moat → plain words; deep
dive → study; cells (of a design) → treatments, conditions; runs → trials. Keep a technical
term only when the text is about that method, and define it at first use.

**Claude's default verbs, flagged by density across the document:**
- *supplies / provides* for every contribution ("the game supplies a benchmark") → gives, is;
- *serves as, stands as, marks, features, boasts* for plain *is / has* → restore *is / has*;
- *pins down* outside its identification sense → specifies, predicts, determines;
- *sweeps* (a parameter) → varies; *reads* (behaviour) → measures, records;
- *drives, underpins, powers, fuels, enables, plays a key role in* → these assert causation;
  write the relation the evidence supports (*is associated with, predicts, contributes to*);
- *sits in, lands, resides in* ("the gain sits in energy firms") → is concentrated in, accrues to.

**Invented academic-sounding phrases:** "behavioural mass", "carries weight", "carries the
load", "load-bearing", "in the same currency", "earns its place" (more than once per section),
"a candidate mechanism" outside biology. Fix: name the actual variable, mechanism or claim.

**Mixed register:** a colloquial verb welded to technical apparatus ("energy firms *give these
gains back*" next to "abnormal returns"). Rewrite the outlier in the dominant register.

## § 2 Sentence patterns

- **Drumbeat colon.** Setup, colon, reveal: "The answer is simple: X." / "But with a twist: …".
  Two in a row read as tabloid. Fix: state it plainly; keep colons for real lists, definitions
  and quotes. If the items after a colon could take "such as", use "such as".
- **Punchy pivot.** A very short sentence dropped between long ones for effect: "Nobody has
  checked." / "We do." / "The models disagreed." Fix: cut it or fold it into the neighbour with
  *however / although*.
- **Negate-then-assert.** "This study does not settle that question. It tests a simpler
  premise." Also compressed: "X is plain; Y is not." and "A, not B" appositions. Fix: one
  sentence with *but* or *rather than*, or just the positive claim when the negated half is
  obvious.
- **Semantic symmetry.** Paired sentences on one template: "X describes A. Y prescribes B.", or
  the denser "X is descriptive; Y is prescriptive." Fix: break the template so the halves differ
  in structure: "X reports what people do. The corresponding norm, Y, states what they should
  do."
- **Stated importance.** "X is at the heart of …", "X organises the literature", "X has
  important implications for …", "X marks a turning point". **Swap test:** could a paper on a
  different question paste this sentence unchanged? Then it says nothing about this paper. Fix:
  cut it, or replace it with the specific consequence ("our estimate implies the elasticity used
  in these models is about twice too large"). If the claim is right but not yet supported, flag
  `EARN-OR-CUT` and let the user decide; cutting silently can strip a paper's real ambition.
- **Implicit completeness.** "The key factors are X and Y", "X is relevant here" read as "only
  these, and we checked the others". Fix: claim what the paper does ("we focus on X and Y").
- **Hedge-fronted or emphatic abstraction.** "Whether X holds is itself an open question", "is
  itself a finding", "may or may not". Fix: commit, or hedge once.
- **Idle cleft.** "…, which is what makes them comparable", "What X does is Y", "It is X that …"
  with no rival to contrast against. Fix: "…, which makes them comparable".
- **Participle clauses.** Opening "Building on prior work, this paper …"; trailing
  significance tails "…, highlighting the importance of X" / "…, paving the way for Y"; and
  chains of participles. Fix: finite verbs; cut the tail, or make it its own supported sentence.
- **Nominalisation chains.** "the implementation of the intervention led to a reduction in" →
  "the intervention reduced". Many words ending in -tion, -ment, -ity, -ence in one sentence is
  the signal.
- **Rule of three.** Triplets by default ("clear, rigorous, and reproducible") where the third
  member adds nothing. Fix: keep the members that carry content.
- **False range.** "from prompt design to policy" where the items lie on no scale. Fix: name the
  set.
- **"X does what Y cannot."** Marketing frame, usually redundant. Fix: state X's contribution
  once, positively.
- **Bare negated relative clause.** "values no input produces", "an effect no design
  identifies". Fix: restore *that* and keep the quantifier: "values that no real input
  produces".
- **Verb reprise.** "Models fabricate one, and they fabricate self-servingly." → "Models
  fabricate one self-servingly."
- **Elided words.** "…against an account on which it never did" forces a second reading. Fix:
  write the words out.
- **Demonstrative that needs a setup sentence.** "…so one factor could produce both, and
  comparing them cannot rule that out." Replace "that" with its noun ("cannot rule out a common
  cause") and check whether the setup clause is still needed; usually it is not.
- **Bare abstract subject.** "Transfer separates …" right after transfer was described → "This
  transfer …".

## § 3 Paragraph and document patterns

- **Pre-announcement.** "There are two reasons for this." / "The answer matters in two ways."
  Cut it; the two things will be visible. If a count does help, enumerate the items explicitly
  (First, Second); announcing "two limits" and then running them together is the worst form.
- **Narrating the text.** "Our question is …", "What this means is …", "The theoretical
  implication is similar." Fix: ask the question, state the implication.
- **Restatement bridge.** A sentence between two others that re-states their relation more
  abstractly ("The structure is the same across these accounts."). Usually cut.
- **Rule, then its instance.** A general sentence followed by the example that demonstrates it.
  Delete the general one and read on; if the example still lands, the rule was scaffolding.
  Keep it only when it reaches cases the example does not.
- **Empty summary closer.** "In sum, …", "By doing X, we achieve Y.", "This contributes to …".
  Cut.
- **Vague "This".** "This shows …" with no clear referent in the previous sentence. Name it.
- **Breathless chain.** The opposite failure, often left behind by de-AI editing: a run of
  short declaratives with no connectives. Add *however, therefore, so, by contrast* at real
  turns. Never add *Moreover, Furthermore, Additionally, Notably* as filler.
- **Robotic example.** "The design makes one case concrete." followed by an example in the same
  flat voice as the rules. Fix: "As an example, consider …", and put the example in illustrative
  mood ("the sender might draw …").
- **Defensive chain.** Claim, then a doubt, then a rescue condition ("…though a direction could
  track the number. It is interpretable only once …"). Fix: state the control as a property the
  design has.
- **Reassurance hedge.** "…which, if anything, understates the effect", "at worst this biases
  against us". State the bias direction plainly or drop it.
- **Rationale on every sentence.** Methods sentences that each end in "so that …". Justify the
  non-obvious choices only.
- **Explaining the field to the field.** Deriving omitted-variable bias or collinearity for
  economists. State the design; the reader supplies the reasoning.
- **Cross-section restatement.** A point established in § 1 explained again in full later. Keep
  the first statement; later ones become a cross-reference or go.
- **Outcome ranking.** "X would be the strong finding; Y a precise negative." If every outcome is
  informative, present each as what it identifies. A stated main hypothesis is fine.
- **Insurance drumbeat.** "No outcome is a failure" said in four places. Keep the single
  strongest statement.
- **Promise template.** Goals or contributions each built as "The project will establish X. The
  result is Y." Delete the frame words; if the units collapse, rewrite each from its substance.
- **Sections that add instead of escalate.** After the main result, sections that apply the
  same design to more outcomes. Test: could you reorder them without loss? Then select the ones
  that carry one argument upward and move the rest to an appendix. (Not a fault in a descriptive
  or data paper, where breadth is the product.)

## § 4 Mechanical checks (grep the document)

1. **Em-dashes:** `—`, and `---` in `.tex`. Replace with commas, parentheses or full stops.
2. **Semicolons and non-list colons:** for each one, ask whether a person would split the
   sentence or name the relation with a word (*because, so, which*). Usually yes; do that.
   Keep semicolons only between list items that contain commas.
3. **Italics for emphasis** (`\emph`, `\textit`): flag unless foreign term, title or symbol.
4. **Lists without a final "and/or":** "a teacher, an advisor, an assistant" → "a teacher, an
   advisor, or an assistant".
5. **Assistant phrases:** sentence-initial *Certainly, Absolutely, Great question*.
6. **Leaked internal labels and template text:** "MVP", "lean core", "v2", "draft",
   placeholder titles, a template author's name, also in files whose `\input` is commented out.
7. **Low "but/however" against "and":** a paragraph of *and* with no *but* lists facts without
   tension.

## § 5 Citations

- **Cite the canonical original** for a foundational concept (prospect theory: Kahneman and
  Tversky 1979), not a later paper that discusses it; if the original is missing from the
  `.bib`, add it from a verified source.
- **Signal one example among many:** "(e.g., Chen and Li 2009)", "for instance". A bare cite
  reads as *the* source.
- **In-text** ("Chen and Li (2009) document …") when the paper is canonical or its specifics
  follow; **parenthetical** for general support.
- **The same paper cited for two different claims** in different sections: say which finding
  each time ("beyond the main result discussed in § 2, the same study reports …").
- When trimming a pile of citations to one, write "e.g." before the survivor.

## § 6 Light pass for the user's or a co-author's prose

Only these, and no restructuring:

- **Evaluative words without numbers:** "fairly short", "quite strong", "around X%", "seems
  okay" → the number or a precise description.
- **Filler:** "a natural question to ask is", "in some way", "and so on".
- **Colloquial phrases:** "a huge mountain of evidence", "stays an open question" (→ remains),
  "make sense of" (→ interpret).
- **Syntax carried over from the writer's first language** (for German speakers: "the
  possibility to express" → "the possibility of expressing"; a dangling "the money participants
  decide about" → "the money participants allocate"; "and so on" → "etc.").
- **"We believe" stacks** (three in a paragraph): vary the verb or commit ("we find").
- Spelling and typos: point them out; they belong to the final proofread.

## § 7 When to stop, and false alarms

- **Compression floor.** Stop cutting when the next cut would remove an interpretation ("either
  result is a finding because …") or the first statement of a point. One short recap per major
  section is a service to a skimming reader in a long document; the second and third are not.
  Past that point, save space structurally (a table instead of prose, fewer figures).
- **Density is not decoration.** In a paper whose argument is separating rival explanations,
  "X rather than Y" appears constantly and each instance carries a rival. Read three instances
  before treating a frequent pattern as a problem.
- **Quotations.** A pattern inside a quotation (a referee report, the text being reviewed) is
  not the author's; never reword a quote to clear a flag.
- **Terms of art.** A flagged word can be the field's term ("harness" as a noun in experimental
  setups with AI models, "robust standard errors", "a pivotal voter"). Keep it.
- **Named pairs.** Two parallel definitions of the two members of a typology just introduced
  are fine across two sentences ("First, …; Second, …"); mirrored halves inside one sentence
  still get rewritten.
- **Descriptive sentences are not overclaims.** When checking claims against a caveat, flag the
  sentence that bridges from the pattern to a mechanism, not the one that reports the estimate.
