# SessionStart hook: shows Claude where the project stands.
# Reads:  the hook's JSON on stdin (for the working directory), then the project's
#         claude/panic_dump.md, claude/next_steps.md and claude/OPEN_ISSUES.md.
# Writes: plain text to stdout, which Claude Code adds to the session's context.
# Keep this file ASCII-only: Windows PowerShell 5.1 misreads non-ASCII characters
# in a script saved without a byte-order mark.

$ErrorActionPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Find the project folder: the hook input names it; fall back to the current folder.
$projectDir = (Get-Location).Path
try {
    $hookInput = [Console]::In.ReadToEnd() | ConvertFrom-Json
    if ($hookInput.cwd) { $projectDir = $hookInput.cwd }
} catch {}

# Show at most this many lines per file, so a long file cannot flood the context.
$maxLines = 80

# Prints a file's first lines under a heading. It returns nothing on purpose: in PowerShell
# everything a function outputs becomes its return value, so a "return $true" here would
# swallow the printed lines into the caller's variable instead of showing them.
function Show-ProjectFile([string]$relativePath, [string]$heading) {
    $path = Join-Path $projectDir $relativePath
    if (-not (Test-Path -LiteralPath $path)) { return }
    $lines = @(Get-Content -LiteralPath $path -Encoding UTF8)
    Write-Output "=== $heading ($relativePath) ==="
    $lines | Select-Object -First $maxLines | ForEach-Object { Write-Output $_ }
    if ($lines.Count -gt $maxLines) {
        Write-Output "[... $($lines.Count - $maxLines) more lines: read the file for the rest]"
    }
    Write-Output ""
}

Write-Output "Session start: $(Get-Date -Format 'yyyy-MM-dd HH:mm (dddd)'), folder: $projectDir"
Write-Output ""

# A panic dump means the last session ended abruptly: show it first.
Show-ProjectFile 'claude\panic_dump.md' 'PANIC DUMP from an interrupted session - surface this to the user first'

# next_steps.md, or one per co-author (next_steps_<initials>.md, reference/collaboration.md).
$nextStepsFiles = @(Get-ChildItem -LiteralPath (Join-Path $projectDir 'claude') -Filter 'next_steps*.md' -File)
foreach ($nextStepsFile in $nextStepsFiles) {
    Show-ProjectFile ('claude\' + $nextStepsFile.Name) 'Where the project stands'
}
Show-ProjectFile 'claude\OPEN_ISSUES.md' 'Open issues'
$hasNextSteps = $nextStepsFiles.Count -gt 0
$hasIssues = Test-Path -LiteralPath (Join-Path $projectDir 'claude\OPEN_ISSUES.md')
if (-not ($hasNextSteps -or $hasIssues)) {
    Write-Output "No claude/next_steps.md or claude/OPEN_ISSUES.md in this folder. If this is a project, /newproject sets them up."
    Write-Output ""
}

# Git: branch and uncommitted changes, from local state only (no network call).
$gitDir = git -C $projectDir rev-parse --show-toplevel 2>$null
if ($LASTEXITCODE -eq 0 -and $gitDir) {
    $branchLine = git -C $projectDir status --short --branch 2>$null | Select-Object -First 1
    $changed = @(git -C $projectDir status --porcelain 2>$null).Count
    Write-Output "Git: $branchLine; $changed file(s) with uncommitted changes."

    # A git repository inside a cloud-synced folder is a known source of corruption.
    if ($gitDir -match '(?i)onedrive|dropbox|google ?drive|nextcloud|icloud') {
        Write-Output "WARNING: this git repository sits inside a cloud-synced folder ($gitDir). Tell the user; see rules/rules.md."
    }
} else {
    Write-Output "Git: this folder is not a git repository."
}
