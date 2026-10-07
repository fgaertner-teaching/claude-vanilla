---
name: skill-builder
description: "Writing and revising skills for this Claude Code setup: where know-how belongs (skill, CLAUDE.md line, command, agent or settings), the SKILL.md frontmatter, descriptions that make a skill load at the right moment, sub-files, and testing that a skill fires. ALWAYS use this skill when creating a new skill, rewriting a skill's description, splitting a skill into sub-files, or deciding whether some know-how should be a skill, a CLAUDE.md line, a command or an agent. Do not create or restructure a SKILL.md without loading it first. Not for small content edits that leave a skill's description and structure unchanged."
---

# Skill: Skill Builder

**Purpose:** Write skills that load when they should, stay out of the way when they should not, and actually change what Claude does.
**Load when:** creating a skill, rewriting its description, splitting it into sub-files, or deciding where some know-how belongs.
**Skip when:** using an existing skill, or editing its content without touching its description or structure.
**Modifies behavior:** placement is decided first; frontmatter and the four-line header are required; descriptions are written as directives with an exclusion; every rule carries its reason; a new skill is tested in a fresh session.

## 1. Is it a skill at all?

Know-how can live in six places, and each costs something different.

| It is… | Put it in | Because |
|---|---|---|
| A rule for every session, 1–3 lines | `CLAUDE.md` or `rules/rules.md` | always loaded, so paid for in every turn of every session |
| A fact about one project | that project's `CLAUDE.md` | loads only in that project |
| Know-how for one kind of task, longer than a few lines | a skill: `skills/<name>/SKILL.md` | only its description is always visible; the body loads when a task matches |
| A procedure the user starts by name | a command: `commands/<name>.md`, run as `/<name>` | runs when asked, never on its own |
| Work best done in a separate context (a review, a search, a check) | an agent: `agents/<name>.md` | its reading stays out of the conversation; only its report comes back |
| Something that must happen every time, without exception | a permission rule or a hook in `settings.json` | an instruction can be forgotten; the program cannot forget |

**The test for a skill: what will Claude do differently with it than without it?** If the answer
is "not much", it is a line in a rules file, or nothing. A skill under ~50 lines is usually a
rule in disguise.

**Check for overlap first.** Read the descriptions of the skills already in `skills/`. If an
existing skill covers more than about half of the new one, extend it instead. *Why:* two skills
that half-overlap either both load or neither does, and their rules drift apart.

Skills in `~/.claude/skills/` work in every project; a skill in a project's `.claude/skills/`
works only there. Commands and skills have been merged: a skill can also be started as
`/<name>`, and `commands/` files keep working (`Last verified: 2026-10-07`).

## 2. The anatomy

```
skills/<name>/
  SKILL.md        # required: frontmatter, header, body
  <sub_file>.md   # optional: loaded only for one use case (§ 5)
```

`SKILL.md` in this order:

1. **YAML frontmatter** between `---` lines, with `name` (the folder name, lowercase with
   hyphens) and `description` (§ 3). Both are required in this setup: the description is the
   only part Claude sees before the skill loads.
2. **Title:** `# Skill: <Name>`.
3. **The four-line header**, which Claude reads once the skill is loaded:

   ```
   **Purpose:** one sentence: what the skill is for.
   **Load when:** the task types it serves.
   **Skip when:** the near misses, and which skill or command takes them.
   **Modifies behavior:** what Claude does differently with it loaded.
   ```

4. **The body:** the most important instructions first, then examples, then a checklist at the
   end. *Why:* models attend most to the beginning and end of a long text; the middle is where
   instructions get lost.

## 3. The description decides whether the skill ever loads

Before a skill loads, Claude sees one line per skill: its name and description. A skill with a
vague description is a skill that never runs.

- **Trigger words first:** the task types and the words the user would actually say ("regression",
  "robustness table", "referee report"). Name task types, not only tools: "creating or changing a
  figure" catches more than "ggplot2".
- **Directive, not passive:** "ALWAYS use this skill when …" plus "Do not … without loading it
  first." A passive "Use when …" is skipped far more often.
- **An exclusion clause:** "Not for …", naming the neighbouring skill or command that takes the
  near misses. Without it, directive descriptions start firing on everything nearby.
- **Third person, and short.** Keep it under 1,024 characters. Claude Code's listing truncates
  `description` plus the optional `when_to_use` at 1,536 characters together, so anything that
  decides loading must come early (`Last verified: 2026-10-07`).
- **Every clause that decides loading goes in the description.** The header lines are read
  only after the skill has loaded, so they cannot make it load; they must not contradict the
  description either.

```
# WRONG: passive, no trigger words, no exclusion
description: Helps with figures.

# RIGHT
description: "Figures and plots for papers: ggplot2, matplotlib, colour, export size,
  fonts. ALWAYS use this skill when creating or changing a figure for a paper or
  slides. Do not write plotting code without loading it first. Not for tables
  (research-paper)."
```

**A skill that starts expensive work** (subagents, long runs) still loads on its trigger, because
loading costs little; its body then says to offer the work and wait for a yes before starting it.

**Optional frontmatter keys** (`Last verified: 2026-10-07`, from the Claude Code skills docs):

| Key | Use it when |
|---|---|
| `when_to_use` | you want example requests or trigger phrases kept apart from the description (appended to it) |
| `argument-hint` | the skill takes arguments when started as `/<name>`; the body reads them as `$ARGUMENTS` |
| `disable-model-invocation: true` | the skill has side effects and only the user should start it |
| `effort` | the skill needs deeper (or less) reasoning than the session default: `low` … `max`. Higher effort uses more of the plan's usage; on a smaller plan prefer `high`, and keep `max` for rare, high-stakes checks |
| `context: fork` (+ `agent`) | the skill reads a lot and only its result should come back to the conversation |
| `paths` | the skill should only activate for matching files (glob patterns) |

## 4. Write the body

- **Write why.** Each rule carries a one-line reason ("Do X. *Why:* Y."). *Why:* with the reason,
  Claude can apply the rule to cases it does not list; without it, it applies it literally or not
  at all.
- **Specific and testable.** "Every table has a title, units in the column headers and a note on
  the sample" beats "make tables clear".
- **A `# WRONG` / `# RIGHT` pair** for any rule that is easy to apply backwards. One good example
  beats a paragraph of adjectives.
- **Say it once.** A rule that lives in `CLAUDE.md` and in a skill, worded slightly differently,
  becomes two rules that disagree.
- **Leave out** what Claude already knows (what a t-test is), style rules a linter or formatter
  enforces, generic encouragement ("be thorough"), and all-caps shouting. *Why:* every line
  competes with every other instruction in the session; past a point, adding rules makes Claude
  follow all of them less well.
- **Time-sensitive facts** (a package's current API, a journal's limits, a tool's behaviour)
  carry a `Last verified: YYYY-MM-DD` line, so a later reader knows when to re-check.

## 5. Size and sub-files

| `SKILL.md` lines | Verdict |
|---|---|
| under ~50 | probably a rule, not a skill |
| 50–250 | the sweet spot |
| 250–400 | look for a use case that could move to a sub-file |
| over 400 | split |

**Split only by use case:** a section goes to a sub-file when it is needed for one kind of task
and not the others (R package setup vs Python setup; drafting vs reviewing). Sections that are
always used together stay together; a section under ~30 lines stays in `SKILL.md`, and so does a
checklist used every time.

Each sub-file starts:

```
# <Title>

**Load when:** <the task that needs it>
**Skip when:** <when it adds nothing>
```

**Name every sub-file in the body of `SKILL.md`, with its load condition** ("For R package
management, read `r.md`"). *Why:* the frontmatter does not reach Claude when the skill loads,
only the body does, so a sub-file listed nowhere in the body is never read.

## 6. Test it in a fresh session

1. **Start a new session.** The session that wrote the skill knows what it is for and will load
   it for that reason, not because of its description, so a test there proves nothing.
2. **Ask for a task the way the user would**, without naming the skill. Check that it loads:
   the transcript shows the skill being invoked, and Claude names it in its one-line list of
   loaded skills. `/skills` lists what is available.
3. **Ask for a near miss** that the exclusion clause should send elsewhere, and check that the
   skill does not load.
4. **Ask for one task the skill governs and check its effect** on the output.

If it does not load, fix the description, not the body: the body is never seen until it loads.
Edits are picked up in the running session, but repeat the test in another fresh one.

Then add the skill to `reference/skill_catalog.md`, so the user can find it too.

## Improving a skill later

Watch for three signals: the skill did not load when it should have (fix the description's
trigger words); it loaded when it should not have (sharpen the "Not for" clause); it loaded but
Claude still got the task wrong (the body is missing a rule, or the rule lacks its reason). Change
one thing at a time and re-test, so you know which change helped. Delete rules that change
nothing; they cost attention and buy nothing.

## Checklist

- [ ] Placement decided (§ 1): a skill, not a rule, command, agent or setting?
- [ ] No existing skill covers more than half of it?
- [ ] Frontmatter between `---` lines, with `name` = folder name and a `description`?
- [ ] Description: trigger words first, directive, "Not for …" clause, under 1,024 characters?
- [ ] Four-line header present and consistent with the description?
- [ ] Most important instructions first; each rule with its reason?
- [ ] A `# WRONG` / `# RIGHT` pair where a rule is easy to apply backwards?
- [ ] Nothing duplicated from `CLAUDE.md`, `rules/rules.md` or another skill?
- [ ] Under ~250 lines, or split by use case, with every sub-file named in the body?
- [ ] Time-sensitive facts carry `Last verified:`?
- [ ] Tested in a fresh session: loads on a real request, stays out of a near miss?
