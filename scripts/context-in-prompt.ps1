# UserPromptSubmit hook: tells Claude how full the context is, with every message.
# Reads:  the hook's JSON on stdin (for the session id), then the figure statusline.ps1 wrote
#         for this session: claude-context-<session id>.txt in the temp folder.
# Writes: one line, "Context: N% used.", which Claude Code adds to the message, or "Context:
#         unknown ..." when the status line has written no figure (normal before the first reply
#         and right after /compact; if it stays, the kit's status line is not running).
# Keep this file ASCII-only: Windows PowerShell 5.1 misreads non-ASCII characters
# in a script saved without a byte-order mark.

$ErrorActionPreference = 'SilentlyContinue'

# The session id names the file, so it is checked first (letters, digits and dashes only).
$sessionId = $null
try { $sessionId = [string]([Console]::In.ReadToEnd() | ConvertFrom-Json).session_id } catch {}
if (-not ($sessionId -match '^[A-Za-z0-9-]+$')) { exit 0 }

# Read the figure; print it only if it is a plain whole number, and say so when there is none,
# so a missing figure cannot be mistaken for a hook that is not installed.
$contextFile = Join-Path ([IO.Path]::GetTempPath()) "claude-context-$sessionId.txt"
$percent = ''
if (Test-Path -LiteralPath $contextFile) {
    $percent = ([string](Get-Content -LiteralPath $contextFile -TotalCount 1)).Trim()
}
if ($percent -match '^\d{1,3}$') {
    Write-Output "Context: $percent% used."
} else {
    Write-Output "Context: unknown (no figure from the kit's status line yet)."
}
