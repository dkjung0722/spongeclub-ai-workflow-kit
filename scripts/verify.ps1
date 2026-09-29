[CmdletBinding()]
param(
    [string]$HomePath = [Environment]::GetFolderPath('UserProfile')
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageDir = Split-Path -Parent $scriptDir
$filesDir = Join-Path $packageDir 'files'

$checks = @(
    @{ Name = 'Codex entrypoint'; Source = (Join-Path $filesDir 'AGENTS.md'); Target = (Join-Path $HomePath '.codex\AGENTS.md') },
    @{ Name = 'Codex teamwork policy'; Source = (Join-Path $filesDir 'TEAMWORK.md'); Target = (Join-Path $HomePath '.codex\TEAMWORK.md') },
    @{ Name = 'Claude entrypoint'; Source = (Join-Path $filesDir 'CLAUDE.md'); Target = (Join-Path $HomePath '.claude\CLAUDE.md') },
    @{ Name = 'Claude teamwork policy'; Source = (Join-Path $filesDir 'TEAMWORK.md'); Target = (Join-Path $HomePath '.claude\TEAMWORK.md') }
)

$failed = $false

foreach ($check in $checks) {
    if (-not (Test-Path -LiteralPath $check.Source -PathType Leaf)) {
        Write-Host "FAIL: package source missing - $($check.Source)"
        $failed = $true
        continue
    }
    if (-not (Test-Path -LiteralPath $check.Target -PathType Leaf)) {
        Write-Host "FAIL: installed file missing - $($check.Target)"
        $failed = $true
        continue
    }

    $sourceHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $check.Source).Hash
    $targetHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $check.Target).Hash
    if ($sourceHash -ne $targetHash) {
        Write-Host "FAIL: content mismatch - $($check.Name)"
        $failed = $true
    } else {
        Write-Host "PASS: $($check.Name)"
    }
}

$codexEntry = Join-Path $HomePath '.codex\AGENTS.md'
$claudeEntry = Join-Path $HomePath '.claude\CLAUDE.md'
$codexPolicy = Join-Path $HomePath '.codex\TEAMWORK.md'

if ((Test-Path -LiteralPath $codexEntry) -and -not (Select-String -Quiet -SimpleMatch '.codex/TEAMWORK.md' -LiteralPath $codexEntry)) {
    Write-Host 'FAIL: Codex entrypoint does not reference the global TEAMWORK path.'
    $failed = $true
}
if ((Test-Path -LiteralPath $claudeEntry) -and -not (Select-String -Quiet -SimpleMatch '.claude/TEAMWORK.md' -LiteralPath $claudeEntry)) {
    Write-Host 'FAIL: Claude entrypoint does not reference the global TEAMWORK path.'
    $failed = $true
}
if ((Test-Path -LiteralPath $codexPolicy) -and -not (Select-String -Quiet -SimpleMatch 'policy-id: codex-account-auto-switch-v1' -LiteralPath $codexPolicy)) {
    Write-Host 'FAIL: automatic Codex account switching policy is missing.'
    $failed = $true
}

if ($failed) {
    Write-Host 'Verification failed.'
    exit 1
}

Write-Host 'File installation verification passed.'
Write-Host 'Check the official orchestration, orca-cli, and computer-use skills in the active Orca environment.'
Write-Host 'Open new Claude and Codex sessions to load the rules.'
