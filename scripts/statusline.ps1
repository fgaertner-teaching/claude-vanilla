# Status line: folder, git branch and session name on the first row;
# model and how full the context is on the second.
# Reads:  the status-line JSON Claude Code passes on stdin.
# Writes: two lines of text, shown under the input box.
# Keep this file ASCII-only (Windows PowerShell 5.1 misreads non-ASCII in a file without BOM).

$ErrorActionPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$status = $null
try { $status = [Console]::In.ReadToEnd() | ConvertFrom-Json } catch {}

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
    $row2 += " | context $([math]::Round([double]$used))% used"
} else {
    $row2 += " | context --"
}

Write-Output $row1
Write-Output $row2
