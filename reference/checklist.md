# Pre-Commit Checklist

**Load when:** about to commit (triggered by `rules/rules.md`).
**Skip when:** not committing.

Read this file before committing. Verify all applicable items.

---

### Files & structure
- [ ] If files were added/moved/retired in `~/.claude/`: is `convention_map.md` updated?
- [ ] If new files were created in a deny-all `.gitignore` directory: are whitelist entries added?
- [ ] If file structure changed in an academic project: did I ask about renaming outputs?

### Issue tracking
- [ ] Did any change incidentally resolve an open issue? If so, flag it to the user.
- [ ] Were any new bugs, questions, or to-dos discovered? Add them to `OPEN_ISSUES.md`.

### Documentation
- [ ] If deviating from an analysis plan: is the deviation recorded in `analysis_plan_deviations.md`?
- [ ] If an idea was considered and rejected: is it recorded in `SUPERSEDED_IDEAS.md`?
- [ ] If a skill-relevant insight came up: propose updating the relevant `SKILL.md`.

### Code changes (academic projects)
- [ ] Were code changes staged through `Claude_suggestions.R` and approved before pushing?
- [ ] If LaTeX tables were generated: compile the output document and verify note text renders correctly (no collapsed words from unescaped underscores) and no columns overflow the page. Fix issues in the R source **before** committing.

### Push discipline
- [ ] Have ~5 commits accumulated? If so, mention pushing to the user.
