# Windows: shells, encodings, line endings, paths

**Load when:** running commands or writing files on Windows — choosing Bash or PowerShell syntax,
non-ASCII text, line endings, file paths, quoting, calling Python or R from a shell.
**Skip when:** on a Mac or Linux, or for a plain command with no paths, non-ASCII text or quoting.

Almost every trap on this page has the same shape: the command runs, exits normally, and the result
is quietly wrong. So after anything here, check the output, not the absence of an error.

## Which shell runs the command

Claude Code on Windows runs its Bash tool in **Git Bash** when Git for Windows is installed;
without it, commands go through a **PowerShell** tool (Last verified: 2026-10-07,
code.claude.com/docs/en/setup). Some setups offer both. They take different syntax — write for the
tool you are calling, never a mix:

| | Git Bash (Bash tool) | PowerShell |
|---|---|---|
| environment variable | `PYTHONIOENCODING=utf-8 python x.py` | `$env:PYTHONIOENCODING = "utf-8"` |
| multi-line text | heredoc `<<'EOF'` | here-string `@'...'@` |
| the C: drive | `/c/Users/...` (bash tools only) | `C:/Users/...` |
| run b only if a worked | `a && b` | 7: `a && b`; 5.1: `a; if ($?) { b }` |

**There are two PowerShells.** Windows ships Windows PowerShell 5.1; PowerShell 7 (`pwsh`) is a
separate install. They differ in file encodings, `&&`, and how they read script files. Check which
one runs (`$PSVersionTable.PSVersion`) before relying on any PowerShell behaviour below.

## Encodings: say UTF-8 every time

- **Python printing non-ASCII** (ä, €, →) can crash with `UnicodeEncodeError: 'charmap' codec`.
  For a one-off command in Git Bash: `PYTHONIOENCODING=utf-8 python x.py`; inside a script, the
  `sys.stdout.reconfigure` line in `empirical-analysis/python.md`.
- **Windows PowerShell 5.1's `>` and `Out-File` write UTF-16**, not UTF-8. R and Python then fail
  on the file ("embedded nul in string") or read garbage. Write data files from R or Python; in
  PowerShell use `Set-Content -Encoding utf8` (5.1 adds a BOM, PowerShell 7 does not).
- **A non-ASCII character inside a quoted string in a `.ps1` file breaks Windows PowerShell 5.1**
  when the file is UTF-8 without a BOM: 5.1 reads it in the old Windows code page, the bytes of an
  em-dash include a curly quote that ends the string, and the parse error appears dozens of lines
  further down. PowerShell 7 reads the same file fine, so testing it with `pwsh` proves nothing.
  Keep strings in `.ps1` files ASCII; non-ASCII in comments is harmless.

```powershell
# WRONG — in Windows PowerShell 5.1 the em-dash ends the string
Write-Host "Merged survey and firm data — check the row count"
# RIGHT
Write-Host "Merged survey and firm data -- check the row count"
```

## Line endings: CRLF and LF

Windows text files end each line with CRLF (`\r\n`); Mac, Linux and most tools use LF (`\n`). The
difference is invisible on screen and loud in git.

- **Python text mode rewrites every line ending.** `Path.write_text()` and `open(p, "w")` write
  CRLF on Windows, and `read_text()` turns CRLF into LF when reading. A script that edits three
  characters of an LF file therefore converts the whole file; git and Overleaf show every line as
  changed, and nobody can find the real edit. When a script edits an existing file, work on bytes:

```python
# WRONG — silently converts every line ending in the file
text = path.read_text(encoding="utf-8")
path.write_text(text.replace(old, new), encoding="utf-8")
# RIGHT — line endings pass through untouched
raw = path.read_bytes()
path.write_bytes(raw.replace(old.encode("utf-8"), new.encode("utf-8")))
```

  (Opening both the read and the write with `newline=""` also preserves them.)
- **The tell:** `git diff --stat` shows the whole file changed after a small edit. Count to be sure:
  `python -c "d=open('f.tex','rb').read(); print(d.count(b'\r\n'), d.count(b'\n'))"`. In Git Bash
  a plain `grep -c` for carriage returns miscounts; use `tr -cd '\r' < f.tex | wc -c`.
- **A text comparison cannot see it.** `read_text() == original` is still true after a line-ending
  flip, because reading normalises both sides. Compare bytes.
- **Byte-level search patterns must match the file's endings.** A pattern containing `\n` finds
  nothing in a CRLF file, so a "replace this block" script silently does nothing — or, searching
  for a blank line `\n\n` as a separator, finds none and deletes to the end of the file. Detect the
  endings first, and dry-run (SKILL.md § 6).
- **`.bat` files need CRLF throughout.** cmd.exe misreads LF lines, and a file with *mixed* endings
  silently skips lines (a `set` that never happens). After writing or editing a `.bat` (the Write
  tool writes LF), convert the whole file to CRLF, and add `*.bat text eol=crlf` to
  `.gitattributes` so git keeps it that way.
- **In a `.bat`, a path containing `)`** (`D:\Data (local)`) inside an `if (...) ( ... )` block ends
  the block early. Use `goto` labels instead of parenthesised blocks around such paths.

## Paths

- **Git Bash shows `/c/Users/...`; Windows programs need `C:/Users/...`.** Python, R and every
  `.exe` are Windows programs. A `/c/...` path written into a Python or R script fails — or
  resolves to `C:\c\...`, so a search quietly finds nothing. A drive letter with forward slashes
  (`C:/Users/me/project`) works in every tool; use that form in scripts.
- **Git Bash rewrites arguments that start with `/`** when it calls a Windows program: `/flag`
  arrives as `C:/Program Files/Git/flag`. If an argument must start with `/`, prefix the command
  with `MSYS_NO_PATHCONV=1`.
- **The command carries its own target.** Use absolute paths and `git -C "<repo>" ...`, not
  `cd <repo> && ...`. *Why:* the working directory can be reset between calls, so a later command
  may run in another folder than you think; and `cd ... &&` compounds make Claude Code ask for
  permission each time. (One exception: R in an renv project, below.)
- **Quote every path.** Spaces and parentheses are common (`C:/Users/Jane Doe/...`).
- **PowerShell's .NET calls ignore `Set-Location`:** `[IO.File]::ReadAllText("data.csv")` resolves
  against the folder the process started in, not the one you moved to. Pass absolute paths.
- **Never list or search the root of a cloud drive** (Google Drive, OneDrive, Dropbox online-only
  files): each entry is a network call, and a recursive listing can hang past the time limit. Go
  to the exact folder by its full path.

## Python and R from a shell

Setup and toolkits: `empirical-analysis/python.md` and `r.md`. What they do not cover:

- **`python` may be the Microsoft Store stub.** On a fresh Windows install the name points to a
  placeholder that installs nothing and, run non-interactively, can exit with no output — so a
  script "runs" and does nothing. Test: `python -c "print(1)"` must print `1`. Run project code
  with `uv run python ...`; to free the name, switch the stub off under Settings → Apps → Advanced
  app settings → App execution aliases (`python.exe`, `python3.exe`).
- **Finding `Rscript`:** it is in `C:/Program Files/R/R-<version>/bin/`, or under
  `%LOCALAPPDATA%/Programs/R/` for an install without admin rights. List the folder rather than
  guessing the version; several versions can sit side by side.
- **`Rscript --vanilla` skips the project's `.Rprofile`** — and in an renv project, `.Rprofile` is
  what switches renv on. A `--vanilla` run then uses whatever packages are installed system-wide,
  not the project's recorded versions. R reads `.Rprofile` only from the folder it starts in, so in
  an renv project run `Rscript script.R` from the folder that holds `renv.lock` (`analysis/` in
  the `/newproject` layout). This is the one exception to "the command carries its own target":
  change into that folder first and approve the prompt it may bring. Check once that
  `Rscript -e ".libPaths()"` run from there lists the project library first.
- **R's `system2()` quotes the command itself.** Quote only the arguments (`shQuote()`); quoting
  the command too fails with doubled quotes.
- **Write code into a script file and run it** — no long `python -c "..."`, `Rscript -e '...'` or
  heredocs. Quotes, `|` and backslashes in inline code break on Windows in ways that look like
  errors in your code.

## Quoting traps

- **In Git Bash, double quotes run backticks and expand `$`.** ``git commit -m "fix `n_obs` count"``
  executes `n_obs` as a command and commits the message with the word missing; the only sign is a
  "command not found" line. Write the message to a file and use `git commit -F <file>`; check with
  `git log -1 --format=%B`.
- **PowerShell here-strings (`@'...'@`) are not bash.** In the Bash tool they leave a stray `@` in
  the text.
- **Never build LaTeX through shell or inline strings.** `printf`, `echo -e`, heredocs and
  `python -c` can turn `\b`, `\f`, `\n`, `\t` into control characters, so `\begin`, `\footnote`,
  `\newcommand`, `\textbf` arrive corrupted, often invisibly. Write LaTeX with the Write tool, or
  from a script file with raw strings (`r"\textbf{x}"` in Python), then search the result for
  control characters.
- **A grep with escaped backslashes can silently match nothing.** On one LaTeX log,
  `grep -c "Overfull \\\\hbox" main.log` returned 0 and `grep -cF 'Overfull \hbox' main.log`
  returned 11. Use `-F` (fixed string) or `.` in place of the backslash, and first show that the
  pattern finds something you know is there.
- **PowerShell calling a program (`.exe`):** quote any argument that contains a variable
  (`"-r$dpi"`, not `-r$dpi`); discard output with `$null = & $exe ...`, not `| Out-Null` (which can
  make the program fail); check `$LASTEXITCODE` afterwards.
- **`-ErrorAction SilentlyContinue` hides the message, not the failure.** On a command that finds
  nothing it still sets `$?` to false, and Claude Code then reports exit 1 for a script that did its
  job. Test first (`if (Test-Path $f) { ... }`), and before believing an exit code, look for the
  script's own success line.
- **"Running scripts is disabled on this system":** run that one script with
  `powershell -ExecutionPolicy Bypass -File script.ps1` rather than changing the policy for the
  whole machine.
