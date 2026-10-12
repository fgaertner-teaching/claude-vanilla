# UserPromptSubmit hook: tells Claude how full the context is, with every message.
# Reads:  the hook's JSON on stdin (for the session id), then the figure statusline.ps1 wrote
#         for this session: claude-context-<session id>.txt in the temp folder.
# Writes: one line, "Context: N% used.", which Claude Code adds to the message. Nothing when
#         there is no figure yet: the status line runs after Claude's first answer.
# Keep this file ASCII-only: Windows PowerShell 5.1 misreads non-ASCII characters
# in a script saved without a byte-order mark.

$ErrorActionPreference = 'SilentlyContinue'

# The session id names the file, so it is checked first (letters, digits and dashes only).
$sessionId = $null
try { $sessionId = [string]([Console]::In.ReadToEnd() | ConvertFrom-Json).session_id } catch {}
if (-not ($sessionId -match '^[A-Za-z0-9-]+$')) { exit 0 }

# Read the figure; print it only if it is a plain whole number.
$contextFile = Join-Path ([IO.Path]::GetTempPath()) "claude-context-$sessionId.txt"
if (-not (Test-Path -LiteralPath $contextFile)) { exit 0 }
$percent = [string](Get-Content -LiteralPath $contextFile -TotalCount 1)
$percent = $percent.Trim()
if ($percent -match '^\d{1,3}$') { Write-Output "Context: $percent% used." }
