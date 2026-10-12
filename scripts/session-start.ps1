# SessionStart hook: shows Claude where the project stands.
# Reads:  the hook's JSON on stdin (for the working directory), then the project's
#         claude/panic_dump.md and claude/next_steps.md. Not claude/OPEN_ISSUES.md: Claude
#         reads that when the user asks what is open (the project CLAUDE.md's pointer).
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

# Show at most this many lines per file, and keep the whole output short: Claude Code passes a
# start hook's output whole only up to 10,000 characters (beyond that, Claude gets a short
# preview). The files found share the character budget equally.
$maxLines = 80
$totalCharBudget = 8500

# Prints a file's first lines under a heading, within its share of the budget. It returns
# nothing on purpose: in PowerShell everything a function outputs becomes its return value, so
# a "return $true" here would swallow the printed lines into the caller's variable.
function Show-ProjectFile([string]$relativePath, [string]$heading, [int]$charBudget) {
    $path = Join-Path $projectDir $relativePath
    $lines = @(Get-Content -LiteralPath $path -Encoding UTF8)
    Write-Output "=== $heading ($relativePath) ==="
    $shown = 0
    $charsLeft = $charBudget
    foreach ($line in ($lines | Select-Object -First $maxLines)) {
        if ($charsLeft - ($line.Length + 1) -lt 0) { break }
        Write-Output $line
        $charsLeft -= ($line.Length + 1)
        $shown++
    }
    if ($shown -lt $lines.Count) {
        Write-Output "[... $($lines.Count - $shown) more lines: read the file for the rest]"
    }
    Write-Output ""
}

Write-Output "Session start: $(Get-Date -Format 'yyyy-MM-dd HH:mm (dddd)'), folder: $projectDir"
Write-Output ""

# The files to show, in order. A panic dump means the last session ended abruptly, so it comes
# first; then next_steps.md, or one per co-author (next_steps_<initials>.md,
# reference/collaboration.md).
$filesToShow = @()
if (Test-Path -LiteralPath (Join-Path $projectDir 'claude\panic_dump.md')) {
    $filesToShow += ,@('claude\panic_dump.md', 'PANIC DUMP from an interrupted session - surface this to the user first')
}
$nextStepsFiles = @(Get-ChildItem -LiteralPath (Join-Path $projectDir 'claude') -Filter 'next_steps*.md' -File)
foreach ($nextStepsFile in $nextStepsFiles) {
    $filesToShow += ,@(('claude\' + $nextStepsFile.Name), 'Where the project stands')
}

if ($filesToShow.Count -gt 0) {
    $charsPerFile = [math]::Floor($totalCharBudget / $filesToShow.Count)
    foreach ($fileToShow in $filesToShow) {
        Show-ProjectFile $fileToShow[0] $fileToShow[1] $charsPerFile
    }
}
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
