Emergency session dump. Write everything to a single file and stop — no commits, no pushes, no multi-file writes.

## Instructions

1. Build the dump content as plain markdown containing all of the following sections:

   ```
   # Panic Dump — [project name]
   _Date: YYYY-MM-DD_

   ## What was done this session
   [Bullet list of completed work]

   ## In progress (not finished)
   [What was being worked on when interrupted — include enough detail to resume]

   ## Uncommitted changes
   [List files modified but not yet committed — from memory, do NOT run git commands]

   ## Open threads
   [Anything discussed but not resolved, decisions pending, questions raised]
   ```

2. Write the file:

   ```bash
   python -c "
   import sys
   content = sys.stdin.read()
   with open('claude/panic_dump.md', 'w') as f:
       f.write(content)
   " << 'EOF'
   [paste the markdown content here]
   EOF
   ```

3. **That's it.** Do not commit. Do not push. Do not update `next_steps.md`, `OPEN_ISSUES.md`, or any other file. One Bash call, then stop.
