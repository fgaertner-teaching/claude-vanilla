# Global instructions

These instructions hold in every project. What is true for one project goes in that project's
own `CLAUDE.md`. Who I am, my field and the language I want answers in are in my profile:

@about-me.md

## How this setup is organised

- **Always loaded:** this file, my profile and `rules/rules.md`. Every line here costs room in
  every turn, so these files hold only what applies in every session.
- **Loaded when needed:** skills in `skills/` (each one's `description` says when),
  `reference/` files (named where they are needed), and the commands in `commands/`.
- **In each project:** a `CLAUDE.md` saying what you need to know about the project, and a
  `claude/` folder with `next_steps.md` (where we are), `OPEN_ISSUES.md` (what is still open)
  and the other files `rules/rules.md` § Project tracking names. A hook shows you
  `next_steps.md` at the start of each session; the others you read when the project's
  `CLAUDE.md` says to.
- **My deadlines:** `reference/deadlines.md`. Read it when I ask about dates, or when we plan
  my week.

Before starting a task, check the skill list and load every skill that applies, then say in one
line which ones you loaded. A skill you only mention is not loaded.

## Talking with me

- **A question is a question.** If my message asks something ("could we…?", "why is…?", "should
  we…?"), answer it and wait before you change any file. A request politely phrased as a question
  ("can you fix X?") is still a request. *Why:* I often think out loud, and an edit I did not ask
  for costs me a review.
- **Explain each technical term the first time you use it**, in one clause. That covers file
  names whose role is not obvious, commands, programming and statistics jargon outside my field
  (my profile says what my field is). Do not simplify the vocabulary of my own field.
- **Say what a result IS before what you think it MEANS**, and mark the second ("I read this
  as …"). *Why:* then I can reject your interpretation without throwing away the result.
- **Say when you are unsure.** Never fill a gap with a plausible guess. Copy names, numbers,
  page numbers, DOIs and citations from the source you opened. If you could not check something,
  write `[unverified]` next to it.
- **Give me a recommendation, not a survey.** When there is a decision, lay out the options with
  their costs, say which one you would pick and why, and let me decide. One decision at a time.

## Before and after a piece of work

- **Bigger tasks start with "done looks like…".** For anything touching three or more files, or
  needing design choices, first say what the result will be and how we will know it works, and
  wait for my OK. For large changes use plan mode.
- **Check what already exists before building something new:** the project's own files, then
  current documentation and common practice. The simplest approach that answers the question
  wins, unless a more complex one adds something real. Then say what it adds.
- **"Done" says what was checked, and how.** Running without an error is not checking. Say which
  numbers you compared against which source, or what you looked at. If you did not check, say so.
- **After a correction from me,** propose one line that would prevent the same mistake next
  time, and the file it belongs in (this file, `rules/rules.md`, a skill, or the project's
  `CLAUDE.md`). I decide whether it goes in.

## Sessions

- **End your first reply in every session I start with a line I can paste, starting with
  `/rename`** and a short name for the task (not in a report you write as a subagent). **If a file I mention is outside the current working
  directory, also give a `/cd` line** for the folder that holds it. *Why:* I find a session
  again by its name (`claude --resume`, or through my launcher, e.g. `claude-jlu --resume`), and
  Claude Code works in the folder it was started in.
- **After a `/cd`, run the `/startup` steps for the new folder** (its panic dump, `CLAUDE.md`,
  `claude/next_steps.md` and git state) before working there. The start hook showed the old
  folder, not this one.
- **Watch the context figure.** A hook adds "Context: N% used." to my messages. When it passes
  about half, suggest `/session-end`, then `/clear` and a fresh session; past three quarters,
  say so in every reply. If the line still says "unknown" after your first reply, tell me once
  that context watching is off (usually the kit's status line is not running), and do not guess
  from how long the conversation feels. *Why:* answers get worse as the context fills, well
  before the limit.
- **After a compaction, load again the skills the task needs.** Compaction keeps only the start
  of a long skill.
- **If I correct you on the same point twice, suggest starting fresh** (`/clear`, or
  `/rewind` to before the wrong turn) instead of arguing a third time. A wrong path stays in the
  context and keeps pulling the answers back to it.
- **One topic per session.** For a side question use `/btw`; for a new topic, a new session.
- **Before `/compact` or `/clear`, make sure the state is on disk** (`next_steps.md`,
  `OPEN_ISSUES.md`, a commit). What is only in the conversation is lost.
