---
description: Emergency save when the session is about to end abruptly (limit reached, laptop dying) - write everything to one file and stop.
---

Write one file, `claude/panic_dump.md`, with everything the next session needs, and stop. No
commits, no pushes, no other files: there may not be time for more than one write.

Use the file-writing tool once, with this content (fill each part from the conversation; do not
run commands to find things out):

```
# Panic dump: <project name>
_Written: <date and time>_

## Done this session
<bullets: what was finished>

## In progress
<what was being worked on when this was written, with enough detail to resume:
 which file, which step, what was about to happen next>

## Not saved anywhere else
<results, numbers, decisions or text that exist only in this conversation>

## Uncommitted changes
<files changed this session, from memory>

## Open questions
<anything discussed but not settled>
```

Then tell the user in one line where the file is. The next session's start hook shows it first.
