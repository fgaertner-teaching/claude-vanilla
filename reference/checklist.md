# Pre-commit checklist

**Load when:** about to commit in a project (named in `rules/rules.md` and `/session-end`).
**Skip when:** not committing.

Check what applies; say in one line which items mattered for this commit.

### What goes in

- [ ] Only files this step changed are staged, named one by one (`git status` before and after).
- [ ] No data, generated outputs (tables, figures, PDFs, model objects) or secrets are staged.
      A new kind of file that belongs in git gets a `!` line in `.gitignore` first; without one
      it stays out without a warning (`git status --ignored --short` lists what stays out).
- [ ] No personal or licensed data, in any file, even inside a script or a comment.
- [ ] The repository is not inside a cloud-synced folder (OneDrive, Dropbox, Google Drive,
      Nextcloud).

### Does it still work

- [ ] Code changed: the script was run, and its output checked against the source or against
      the previous output (say which).
- [ ] LaTeX changed: the document compiles, and the changed table or figure was looked at in
      the PDF (no overflowing columns, no swallowed underscores).

### Records

- [ ] Did this change resolve an item in `claude/OPEN_ISSUES.md`? Then delete it in the same
      commit, and tell the user.
- [ ] Did it raise a new problem or question? Add it to `claude/OPEN_ISSUES.md`.
- [ ] Was a decision made whose reason a later session needs? A `claude/decision_<topic>.md`.
- [ ] A deviation from a pre-registration or analysis plan: recorded where the plan says.

### The message

- [ ] Says what changed and why, in a sentence a co-author would understand. Stated to the
      user before committing.
