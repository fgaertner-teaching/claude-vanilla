# The kit, file by file

**Load when:** the user asks what a file in this setup does, how its parts work together, or
where something they saw on screen comes from.
**Skip when:** project work with no question about the setup itself.

This setup is a ready-made `~/.claude` folder: the files Claude Code reads before and during every
session. This guide goes through each of them, grouped by how Claude Code meets them. When a file
is added, renamed or removed, change its entry here in the same step (`skill_catalog.md` says the
same).

Claude Code meets these files in three ways. Some are read at the start of every session and stay
in view for the whole session. Some are opened only when a task needs them. And some are small
programs that Claude Code runs by itself at fixed moments. How a file is read decides what it
costs. Everything that is always loaded takes up room in the context window (the model's working
memory for the session) in every single turn, which is why the always-loaded files are kept short.

## Read in every session

- **`CLAUDE.md`**: standing instructions on how Claude works with you, in every project. Claude
  answers a question instead of changing a file, explains each technical term the first time it
  uses it, says what "done" looks like before a bigger task, and copies names, numbers and
  references from a source it opened. Claude also suggests `/session-end` and a fresh session once
  the context is about half full, and a fresh start when you have corrected the same point twice.
  The file pulls in your profile as well.
- **`about-me.md`** (made from `about-me.md.template`): your profile, with your name, position,
  field, tools, and the language you want answers in. The template only holds placeholders.
  Claude fills it in by interviewing you, and you read the result and correct it. It is read in
  every session, so it stays short.
- **`rules/rules.md`**: conventions for files, data, git and code. Raw data is never changed, and
  the project works on a copy. Numbers come from scripts and are never typed in by hand. CSV files
  are written so German Excel opens them correctly. Personal data, licensed data and secrets never
  go into git. No git repository sits inside a cloud-synced folder. Python runs through `uv` and R
  through `renv`, and Claude commits after each working step with the message stated first. Each
  rule carries a one-line reason, so Claude can apply it to cases the rule does not list.

## Settings, and the programs Claude Code runs by itself

A **hook** is a small program that Claude Code runs automatically at a fixed moment, such as the
start of a session or each message you send, without Claude deciding to. Every program here comes
twice: a `.ps1` file for Windows PowerShell and an `.sh` twin for a Mac, and the install points
`settings.json` at the right one.

- **`settings.json`**: Claude Code's configuration. Its permission rules come in three kinds.
  Claude may read files, run everyday git commands, `uv` and `Rscript`, and search the web without
  asking. Claude must ask you first before deleting a file and before every push, in every mode,
  Auto included. And Claude may never force-push, run `git reset --hard` or `git clean`, read
  `.env` files, `~/.ssh` or a launcher file that holds an access key (`claude-jlu.bat`,
  `claude-jlu.command`), or edit anything in a `1_raw_data/` folder. The file also switches on the
  status line and the two hooks below.
- **`scripts/session-start.ps1`**, **`scripts/session-start.sh`**: the start hook. When a session
  starts, it puts the folder's `claude/next_steps.md` in front of Claude, along with a panic dump
  if there is one, and the git state. It looks only in the folder the session started in, so to
  pick up where you left off, start Claude in your project's folder.
- **`scripts/context-in-prompt.ps1`**, **`scripts/context-in-prompt.sh`**: adds one line to each
  message you send, "Context: N% used", so Claude can see how full the session is and suggest
  wrapping up in time.
- **`scripts/statusline.ps1`**, **`scripts/statusline.sh`**: the two lines under the input box.
  The first shows the folder, git branch and session name, the second the model and how full the
  session is. Claude cannot see the status line, so the script also saves that figure to a small
  file, which the context hook reads.

## Commands you type

- **`commands/startup.md`** (`/startup`): where the project stands. Claude reads `next_steps.md`,
  checks git and whether the remote has commits your copy lacks, and reports in a few lines.
- **`commands/session-end.md`** (`/session-end`): closes a session so the next one can start
  without you explaining anything. Claude overwrites `next_steps.md`, updates the open issues and
  the session log, writes a decision file for each decision a later session will need the reason
  for, and proposes a line for each correction you made, which goes in only if you agree. Then
  Claude commits, lists what git tracks and leaves out, and pushes after asking you.
- **`commands/newproject.md`** (`/newproject`): sets up a new project, or brings an existing one up
  to these conventions. Claude first checks that the folder is not cloud-synced, then sets up the
  project's own `CLAUDE.md`, the `claude/` files, numbered folders, a `.gitignore` that leaves
  everything out unless it is listed, a lock on the raw data, and a git repository. Last, Claude
  adds the project to an index of your projects.
- **`commands/what-slipped.md`** (`/what-slipped`): a review of the work just done. A fresh
  Claude, one that did not do the work, reads what changed and your account of it, and reports
  what is wrong, missing or claimed beyond the evidence.
- **`commands/explain.md`** (`/explain`): explains the last thing in plain terms, or the thing you
  name, without doing new work.
- **`commands/panic.md`** (`/panic`): for a session about to end abruptly, when the usage limit is
  reached or the battery is dying. Claude writes one file, `claude/panic_dump.md`, with everything
  the next session needs, and stops. The start hook shows that file first next time.

## Skills Claude opens by itself

A **skill** is a folder of instructions for one kind of task. Until a task matches, Claude sees
only each skill's one-paragraph description. When one matches, Claude opens its `SKILL.md` and says
in one line which skills it loaded. The extra files in a skill's folder are opened only when the
`SKILL.md` sends Claude to them.

- **`skills/empirical-analysis/`**: identification, estimation, standard errors, diagnostics,
  robustness and reporting. Sub-files: `r.md` and `python.md` (set-up and traps), `plotting.md`
  (figures for papers), `marginaleffects.md` (interpreting fitted models), `causal_reasoning.md`
  (drawing the causal graph before reasoning over it), `research_integrity.md` (a number that
  enters a paper must come from a checked script).
- **`skills/analysis-plan/`**: pre-registrations and analysis plans, with hypotheses, estimating
  equations, sample and exclusion rules, power, and success criteria written down before any
  results exist.
- **`skills/research-paper/`**: LaTeX tables and figures written by scripts, the bibliography and
  the manuscript's set-up. `regression_tables.md` is the recipe for regression tables from R or
  Python.
- **`skills/author/`**: prose that readers outside the project will read. `diagnostics.md` is a
  catalogue of the habits that make text read as machine-written, each with its fix. `sections.md`
  lists what each part of a paper, a referee response or a proposal has to do.
- **`skills/pre-submission-audit/`**: the last check before a paper goes to a journal. Claude
  checks that the package agrees with itself (cross-references, table and figure numbers, sample
  sizes, variable names, citations, paper against appendix and response letter), that the upload
  files are complete, and that the paper is anonymised for blind review.
- **`skills/journal-formalia-check/`**: a manuscript against one journal's or conference's author
  guidelines, which you supply (length limits, structure, reference style, figures, declarations,
  blinding). Without the guidelines the check does not run, and Claude never states a journal's
  requirement from memory.
- **`skills/project-organizer/`**: where things belong, with numbered scripts, raw, interim and
  clean data folders, one main file that runs everything, and the paper's file layout.
- **`skills/coder/`**: writing, running and debugging R and Python, with a focus on code that fails
  silently, numbers typed into code, and scripts that cannot be re-run from the raw data.
  Sub-files: `debugging.md` (find the cause before fixing), `long_runs.md` (scripts that run for
  minutes or hours), `windows.md` (shells, encodings, line endings, paths).
- **`skills/auditor/`**: an independent review of a finished piece of work (a draft, an analysis
  plan, a script pipeline, a setup) by fresh agents that did not write it.
- **`skills/skill-builder/`**: for writing your own skills, with where a piece of know-how belongs
  (a skill, a line in `CLAUDE.md`, a command, a setting) and how to word a description so the
  skill loads at the right moment.

## Agents Claude sends out

An **agent** is a separate Claude that your Claude starts for one job. It begins with an empty
context, does the job and reports back, so everything it reads stays out of your session.

- **`agents/literature-scout.md`**: searches OpenAlex and the web for work on a question and
  returns a structured report, with reviews, core papers, adjacent literatures and gaps. Every
  reference is copied from a page the agent opened. It runs on a mid-sized model (Sonnet).
- **`agents/verifier.md`**: checks that a finished task was done. The expected files exist and
  match what was asked, nothing else changed, and no obvious error remains. It only reads, and
  runs on the small, fast model (Haiku).
- **`agents/referee2.md`**: an adversarial referee for a finished empirical analysis and its code.
  It runs five audits (the code, a replication in the other language, the folders, the outputs,
  the econometrics) and writes a referee report with a verdict, which your session saves in
  `claude/referee2/`. It never runs or changes your files and installs nothing. Its replication
  scripts go into `claude/referee2/replication/` only.

## Reference files, opened when a task reaches them

Background that skills and commands point to. Claude reads one when the task needs it, and you will
rarely open them yourself.

- **`reference/kit_guide.md`**: this file.
- **`reference/new_project.md`**: the full recipe `/newproject` walks through, with its templates
  and the reason for each step.
- **`reference/templates/`**, **`reference/template_main_file.R`**: a working skeleton pipeline,
  in R and in Python, with a setup file, five stage scripts (load, clean, analyse, tables, plots)
  and a main file that runs them in order. `/newproject` copies them into a new project, and Claude
  adapts them to your data.
- **`reference/gitignore_policy.md`**: the `.gitignore` template, and why it lists what to let in
  instead of what to keep out, so that a data file saved in an unexpected place stays out of git.
- **`reference/checklist.md`**: what Claude checks before each commit. Only this step's files are
  staged, and no data, generated outputs or secrets are among them.
- **`reference/academic_conventions.md`**: starting defaults for a research project, covering how
  analysis plans, deviations from them, output specifications and rejected ideas are tracked.
- **`reference/collaboration.md`**: several authors in one project, with where files live and what
  Claude does when asked to change code a co-author owns.
- **`reference/overleaf_conventions.md`**: how files travel between your computer and Overleaf.
  Claude works on your computer and cannot see Overleaf, so something has to carry files across,
  and which route works depends on your Overleaf plan.
- **`reference/claude_code_settings.md`**: what the kit sets, where Claude Code keeps its settings,
  and how to change them.
- **`reference/skill_catalog.md`**: the index of the kit, with every skill, command and agent, and
  which file owns which convention.
- **`reference/deadlines.md`**: an empty table for your deadlines. When you mention a new one,
  Claude offers to add it.

## The kit repository's own files

- **`README.md`**: what the kit is, how to install it, what differs on a Mac and how to update.
  Written for people. Claude does not load it in a session.
- **`.gitignore`**: keeps the kit's repository to the kit's own files. It matters only if you put
  your own `~/.claude` under git.

One part of the kit is not a file. The install connects **OpenAlex**, the open database of
scholarly papers, as an MCP server: a connector that gives Claude extra tools, here searching
papers, citations and authors.

## What ends up in each project

These are not in the kit. Claude writes them inside each project, through `/newproject` and
`/session-end`, and you read them and decide.

| File | Holds |
|---|---|
| `CLAUDE.md` (the project's) | what is true for this project only; read after the kit's own files |
| `claude/next_steps.md` | where the project stands; overwritten at each `/session-end` |
| `claude/OPEN_ISSUES.md` | what is open, each item with what would close it |
| `claude/long_term_open_issues.md` | what is open but can wait for months |
| `claude/session_log.md` | one entry per session |
| `claude/decision_<topic>.md` | a decision, its options and its reason |
| `claude/referee2/` | `referee2`'s reports and replication scripts, once it has run |
| `.claude/settings.json` | the project's own settings, among them the raw-data lock |

## One session, start to end

1. You start Claude in a project folder. Claude Code reads the kit's `CLAUDE.md`, your profile,
   `rules/rules.md` and the project's own `CLAUDE.md`. The start hook adds the folder's
   `next_steps.md` and the git state.
2. Each message you send carries the line saying how full the context is.
3. When a task matches a skill's description, Claude opens that skill and tells you which one it
   loaded.
4. Before deleting a file or pushing, Claude Code asks you, in every mode.
5. Bigger checks go to an agent or to `/what-slipped`, which start without the session's context.
6. `/session-end` writes the project's files and commits. The next session started in the same
   folder begins from them.
