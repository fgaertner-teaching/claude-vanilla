# Rules

Conventions for files, data, git, project tracking and code. Every project, every session.

## Files and data

- **Raw data is never changed.** Every cleaning or coding step reads the raw files and writes a
  new file. *Why:* a mistake in a step can then always be undone by re-running it.
- **Numbers come from scripts, never typed in by hand.** A number in a table, a paper or a
  slide must be produced by a script that runs from the raw data. *Why:* otherwise next year's
  update, or a referee's question, cannot be answered by re-running it.
- **Ask before deleting anything.** The permission settings make Claude Code ask for every
  delete command. Beyond that, never delete through a script or a roundabout command, and never
  empty a file to get rid of it. *Why:* `/rewind` undoes Claude's file edits, not a deleted file, and
  outside git nothing brings it back.
- **No git repository inside a cloud-synced folder** (OneDrive, Dropbox, Google Drive,
  Nextcloud). On Windows, `Documents` and `Desktop` are often synced to OneDrive. *Why:* the sync
  client and git fight over the same files and corrupt the repository. Check the path before
  `git init`; keep projects in something like `C:\Users\<name>\projects\`.
- **Personal data, licensed data and secrets** (passwords, API keys) are never committed, never
  pasted into a public place, and only sent to a service I have approved. When unsure whether a
  file counts, ask.
- **CSV files for German Excel:** semicolon as separator, comma as decimal sign, UTF-8 with a
  byte-order mark (`readr::write_excel_csv2()` in R; in pandas
  `df.to_csv(path, sep=";", decimal=",", encoding="utf-8-sig")`). *Why:* Excel with German
  settings then opens them with a double-click, umlauts intact; without the byte-order mark it
  garbles them. Reading someone else's CSV, use their format.
- **Write text files as UTF-8** and say so explicitly in code (`encoding="utf-8"`). Windows
  otherwise picks an older encoding and umlauts break.

## Project tracking (`claude/` in each project)

- **`claude/next_steps.md` is the handover:** where the project stands, what was done last, what
  comes next. It is overwritten at every session end: a snapshot, not a diary.
- **`claude/OPEN_ISSUES.md` holds only what is still open:** bugs, questions, to-dos, each with
  what would close it. A resolved item is deleted, not ticked off. It is resolved when it has been
  checked, not when a fix was attempted.
- **Decisions get a short discussion file** in `claude/` (`decision_<topic>.md`): the question,
  the options, what we chose and why, and what we rejected. *Why:* a year later the reason is
  what you need, and nobody remembers it.
- **Keep them current as we go,** not reconstructed at the end of the session.
- **The project's `CLAUDE.md` says what you need to know about the project** in every session:
  its goal, its data, its folder layout, its rules. Keep it short, with details in files it
  points to.

## Git

- **The main branch is `main`.** New repositories: `git init -b main`.
- **Commit after each working step,** with a message that says what changed and why. State the
  message before committing, so I can stop it. Stage only the files this step touched.
- **Never commit data, generated outputs (tables, figures, PDFs) or secrets.** The project's
  `.gitignore` keeps them out; a new kind of file gets a line there first.
- **Push at the end of a session** if the repository has a remote. *Why:* a commit only on this
  laptop dies with it.
- **Explain each git command in plain words** the first time it comes up.
- Force-pushing, `git reset --hard` and `git clean` are blocked in the settings. If one seems
  necessary, explain why and let me run it.

## Code (you write it, I check what it produces)

- **Python through `uv`,** one environment per project (`uv init`, `uv add <package>`,
  `uv run script.py`). **R packages through `renv`;** run R scripts as `Rscript x.R` from the
  project folder, so renv switches on the project's packages (`--vanilla` would skip that).
- **Every script starts with a short header:** what it does, what it reads, what it writes.
- **Check after every data step:** row counts after a merge, missing values in key columns,
  value ranges. Stop with a clear error rather than continue with a wrong result.
- **Show me results I can check against the source:** a few rows next to the page or cell they
  came from, a count I can compare. Do not ask me to read code to trust a number.
- **Long runs:** estimate the time first (time one unit), run them in the background, and do not
  edit a script while it runs.
- **Inspect data files with code** (R, Python), never by reading them as text: wide tables are
  easy to misread by eye.
- Load the `coder` skill before writing or debugging code; it has the details.

## Writing

LaTeX tables, figures and the Overleaf project: the `research-paper` skill. Prose that other
people will read (papers, proposals, replies to referees): the `author` skill.

## Quality

- **When something goes wrong, find out why before trying again.** A second attempt at the same
  thing without a reason is guessing.
- **When you fix one instance of a problem, check the others.** The same mistake usually sits
  in the sibling files too.
- **A claim like "nothing else uses this" or "all files are updated" needs the command that
  shows it,** with its output.
- **Facts that change over time** (versions, prices, deadlines, rules) carry the date you checked
  them. Older than about three months: say "as of <date>, check again".
- **Re-read anything substantial before presenting it,** looking for contradictions and broken
  references.

## Reading efficiently

- One known file: read it directly. A long file: search it first, then read the part you need.
- Three or more files, or a question across a whole folder: use a subagent and report its
  conclusion.
- PDFs: read only the pages you need.
