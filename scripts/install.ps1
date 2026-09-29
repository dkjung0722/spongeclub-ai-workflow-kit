[CmdletBinding()]
param(
    [string]$HomePath = [Environment]::GetFolderPath('UserProfile')
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageDir = Split-Path -Parent $scriptDir
$filesDir = Join-Path $packageDir 'files'
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'

$mappings = @(
    @{ Source = (Join-Path $filesDir 'AGENTS.md'); Target = (Join-Path $HomePath '.codex\AGENTS.md') },
    @{ Source = (Join-Path $filesDir 'TEAMWORK.md'); Target = (Join-Path $HomePath '.codex\TEAMWORK.md') },
    @{ Source = (Join-Path $filesDir 'CLAUDE.md'); Target = (Join-Path $HomePath '.claude\CLAUDE.md') },
    @{ Source = (Join-Path $filesDir 'TEAMWORK.md'); Target = (Join-Path $HomePath '.claude\TEAMWORK.md') }
)

foreach ($mapping in $mappings) {
    if (-not (Test-Path -LiteralPath $mapping.Source -PathType Leaf)) {
        throw "Missing package file: $($mapping.Source)"
    }
}

$installed = @()
$unchanged = @()
$backups = @()

foreach ($mapping in $mappings) {
    $source = $mapping.Source
    $target = $mapping.Target
    $targetDir = Split-Path -Parent $target
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

    $existing = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
    if ($existing -and $existing.PSIsContainer) {
        throw "Install target is a directory, not a file: $target"
    }

    if ($existing) {
        $sourceHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $source).Hash
        $targetHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $target).Hash
        if ($sourceHash -eq $targetHash) {
            $unchanged += $target
            continue
        }

        $backup = "$target.backup-$timestamp"
        if ($existing.LinkType) {
            Move-Item -LiteralPath $target -Destination $backup
        } else {
            Copy-Item -LiteralPath $target -Destination $backup
        }
        $backups += $backup
    }

    Copy-Item -LiteralPath $source -Destination $target -Force
    $installed += $target
}

Write-Host 'AI workflow rules installation completed.'
Write-Host "User home: $HomePath"

if ($installed.Count -gt 0) {
    Write-Host 'Installed files:'
    $installed | ForEach-Object { Write-Host "  $_" }
}

if ($unchanged.Count -gt 0) {
    Write-Host 'Already current:'
    $unchanged | ForEach-Object { Write-Host "  $_" }
}

if ($backups.Count -gt 0) {
    Write-Host 'Backup files:'
    $backups | ForEach-Object { Write-Host "  $_" }
}

Write-Host 'Open new Claude and Codex sessions to load the new rules.'
