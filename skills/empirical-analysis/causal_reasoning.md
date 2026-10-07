# Causal Reasoning

**Load when:** the task itself is causal reasoning: auditing an identification strategy, challenging or checking a causal claim, drawing a DAG, separating confounders from mechanisms and mediators, or checking the causal wording of a draft, proposal or referee report.
**Skip when:** descriptive analysis, data cleaning or table formatting; or causation is only mentioned in passing.

Load alongside `SKILL.md`. Why this file exists: language models retrieve causal *knowledge* well
but are weak at novel causal *inference*, and generic "think step by step" does not fix it (Jin et
al. 2024). What helps is writing the causal graph down first and then reasoning over it in fixed
steps (Romanou et al. 2024). A wrong label such as "confounder" for a variable that was randomized
then travels unnoticed from the design into the proposal and the paper.

---

## 1. Six roles: give every variable exactly one

| Role | Definition | Test question |
|---|---|---|
| **Treatment** | the variable whose effect we study | "Is this what we estimate the effect of?" |
| **Outcome** | the variable that responds | "Is this what changes in response?" |
| **Confounder** | common cause of treatment AND outcome | "Does it independently cause both?" |
| **Mechanism (mediator)** | on the path from treatment to outcome | "Does X work *through* this?" |
| **Moderator** | changes the size or sign of X → Y | "Does this change *how much* X affects Y?" |
| **Collider** | caused by both X and Y | "Is this a *consequence* of both?" |

**Confounder vs mechanism, the distinction that matters most:**

- Confounder: X ← C → Y. Threatens identification; must be controlled or designed away.
- Mechanism: X → M → Y. Explains the effect; controlling for it removes part of the effect.
- **When X is randomized, nothing is a confounder of X.** A variable that explains baseline
  behavior is then a mechanism, a moderator or a competing explanation of the outcome level, not
  a source of bias in the treatment effect.

## 2. The causal language ladder

Match the wording to what the design identifies. Stronger language than the design supports is the
most common error in drafts.

| Design | Appropriate wording | Overreach |
|---|---|---|
| RCT, full compliance | "X causes Y", "the effect of X" | — |
| RCT, non-compliance | "assignment to X affects Y" (ITT) | "X causes Y" with no compliance caveat |
| IV / natural experiment | "X affects Y for compliers" (LATE) | generalizing beyond compliers |
| DiD | "X led to a change in Y" | "X causes Y" without parallel-trends evidence |
| RDD | "X affects Y at the threshold" | extrapolating away from the cutoff |
| Panel FE | "X is associated with within-unit changes in Y" | "X causes Y" |
| Observational + controls | "X predicts / is associated with Y" | "the effect of X" |

## 3. Common errors: pattern, then correction

- **E1: confounder label on a randomized variable.** "Prior knowledge is a confounder" when treatment
  was randomly assigned. → Reclassify: mechanism, moderator, competing explanation, or irrelevant.
- **E2: causal language without identification.** "X leads to Y" with no design stated. → Add "We
  identify the effect using [design], exploiting [variation]."
- **E3: bundled mechanisms.** "We test whether A, B or C drives Y" when the design varies only one.
  → State which mechanisms are separately identified and which are bundled.
- **E4: mediator controlled away.** "We control for M" where X → M → Y. → Drop M from the controls;
  analyze mediation separately if needed.
- **E5: collider conditioning.** A control that is caused by both treatment and outcome (or a sample
  selected on one). → Remove it, or name the selection bias it creates.
- **E6: single-cause framing.** "X affects Y through M" when M′ and M″ are not ruled out. → "X
  affects Y. One mechanism is M; alternatives include M′ and M″."
- **E7: temporal order as causation.** "X precedes Y, so X causes Y." → Require identification, not
  only timing.
- **E8: "a behavioral design cannot study mechanisms."** → Wrong. A mechanism is a causal pathway,
  not something you need to see inside a person (or a model). Behavioral designs identify mechanisms
  by varying the inputs that correspond to each candidate mechanism and observing which variation
  moves the outcome; financial literacy is studied as a mechanism of financial education this way.
  Do not write "we make no mechanism claims" if the design does test which input explains the data.
- **E9: partial control read as progress.** "We add controls, so the estimate is less biased."
  → Biases have signs and can cancel; removing one can increase the net bias. Sign them first.

## 4. The DAG check: run before finalizing a design, proposal or review

**Step 1: extract.** List every variable that plays a causal role, and the directed edges:

```
Variables: X (treatment), Y (outcome), M (mechanism), W (moderator), C (confounder)
Edges:     X → Y;  X → M → Y;  C → X, C → Y;  W moderates X → Y
```

**Step 2: classify.** One role per variable from § 1. Flag any variable without a clear role.

**Step 3: check every confounder and control.**
- Is X randomized? Then nothing upstream of X can confound it, and nothing downstream belongs in
  the controls.
- Does the variable independently cause both X and Y? If not, it is not a confounder.
- Is it caused by X (a mediator) or by both X and Y (a collider)? Then conditioning on it biases
  the estimate; remove it.

**Step 4: check the language.** For each causal sentence, find the design in the ladder (§ 2). Is
the wording at or below the level the design supports? For a mechanism claim, can the design
isolate that mechanism?

**Step 5: place the claim at the right depth.**
1. State the strongest claim the design supports.
2. Step back: if the X → M → Y argument fails, does X → Y still stand? (Weaker but defensible.)
3. Step forward: if X → Y holds, which additional design feature (an extra arm, a measured
   mediator, a manipulation of M) would identify X → M → Y?

Claims should sit exactly at the level the design supports. Overreach invites rejection;
understatement leaves the contribution on the table.

## 5. Where to apply it

- **Designing a study:** run steps 1–5 before writing the analysis plan.
- **Writing a proposal or paper:** check that every causal sentence matches the identification
  section, and that the abstract and conclusion do not escalate beyond it.
- **Reviewing someone's work (or a referee report):** extract the graph (step 1), check E1–E9,
  check the ladder.

When a reader or referee catches a causal error this check missed, add the pattern to § 3.
