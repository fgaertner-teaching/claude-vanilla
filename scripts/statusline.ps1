# Status line: folder, git branch and session name on the first row;
# model and how full the context is on the second.
# Reads:  the status-line JSON Claude Code passes on stdin.
# Writes: two lines of text, shown under the input box, and the context figure to a small
#         file in the temp folder, claude-context-<session id>.txt, which
#         context-in-prompt.ps1 puts into each message (Claude cannot see the status line).
# Keep this file ASCII-only (Windows PowerShell 5.1 misreads non-ASCII in a file without BOM).

$ErrorActionPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# The status-line JSON arrives as UTF-8, so the raw input is decoded as UTF-8: [Console]::In would
# use the console's code page in Windows PowerShell 5.1 and garble a folder name with an umlaut.
$status = $null
try {
    $stdinReader = New-Object System.IO.StreamReader([Console]::OpenStandardInput(), [System.Text.Encoding]::UTF8)
    $status = $stdinReader.ReadToEnd() | ConvertFrom-Json
} catch {}

# First row: the folder's name, the git branch, the session name if the session has one.
$folder = $status.workspace.current_dir
if (-not $folder) { $folder = $status.cwd }
if (-not $folder) { $folder = (Get-Location).Path }
$row1 = Split-Path -Leaf $folder
$branch = git -C $folder branch --show-current 2>$null
if ($LASTEXITCODE -eq 0 -and $branch) { $row1 += " [$branch]" }
if ($status.session_name) { $row1 += " - $($status.session_name)" }

# Second row: model, effort level if set, and the share of the context window in use.
$row2 = $status.model.display_name
if ($status.effort.level) { $row2 += " ($($status.effort.level))" }
$used = $status.context_window.used_percentage
if ($null -ne $used) {
    $usedRounded = [math]::Round([double]$used)
    $row2 += " | context $usedRounded% used"
} else {
    $row2 += " | context --"
}

# Hand the figure to the prompt hook. The session id names the file, so it is checked first:
# letters, digits and dashes only, so it can never point outside the temp folder. With no figure
# (early in a session, right after /compact) the file is emptied, so the prompt hook says the
# figure is unknown instead of repeating an old one.
$sessionId = [string]$status.session_id
if ($sessionId -match '^[A-Za-z0-9-]+$') {
    $contextFile = Join-Path ([IO.Path]::GetTempPath()) "claude-context-$sessionId.txt"
    if ($null -ne $used) { $figure = $usedRounded } else { $figure = '' }
    Set-Content -LiteralPath $contextFile -Value $figure -Encoding ASCII
}

Write-Output $row1
Write-Output $row2
