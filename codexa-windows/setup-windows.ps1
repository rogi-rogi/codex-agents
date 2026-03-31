[CmdletBinding()]
param(
    [string]$InstallRoot = (Join-Path $env:LOCALAPPDATA "codexa")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[STEP] $Message" -ForegroundColor Cyan
}

try {
    $scriptRoot = $PSScriptRoot
    if ([string]::IsNullOrWhiteSpace($scriptRoot)) {
        $scriptRoot = Split-Path -Parent $PSCommandPath
    }

    $sourceCodexaDir = Join-Path $scriptRoot "codexa"
    $installParent = Split-Path -Parent $InstallRoot
    $binDir = Join-Path $InstallRoot "bin"

    Write-Host "Codexa Windows setup started." -ForegroundColor Green
    Write-Host "Source codexa dir : $sourceCodexaDir"
    Write-Host "Install root      : $InstallRoot"
    Write-Host ""

    Write-Step "Checking source folder"
    if (-not (Test-Path $sourceCodexaDir)) {
        throw "Source folder not found: $sourceCodexaDir"
    }
    if (-not (Test-Path (Join-Path $sourceCodexaDir "bin\codexa.ps1"))) {
        throw "Required file not found: $(Join-Path $sourceCodexaDir 'bin\codexa.ps1')"
    }
    if (-not (Test-Path (Join-Path $sourceCodexaDir "bin\codexa.cmd"))) {
        throw "Required file not found: $(Join-Path $sourceCodexaDir 'bin\codexa.cmd')"
    }
    if (-not (Test-Path (Join-Path $sourceCodexaDir "AGENTS.md"))) {
        throw "Required file not found: $(Join-Path $sourceCodexaDir 'AGENTS.md')"
    }
    Write-Host "  OK  $sourceCodexaDir"

    Write-Step "Preparing target folder"
    New-Item -ItemType Directory -Force -Path $installParent | Out-Null
    if (Test-Path $InstallRoot) {
        Remove-Item -Recurse -Force $InstallRoot
        Write-Host "  OK  Removed existing: $InstallRoot"
    }

    Write-Step "Copying codexa folder"
    Copy-Item -Recurse -Force $sourceCodexaDir $installParent
    Write-Host "  OK  Copied to: $InstallRoot"

    Write-Step "Registering user PATH"

    $currentUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ([string]::IsNullOrWhiteSpace($currentUserPath)) {
        $currentUserPath = ""
    }

    $pathParts = @($currentUserPath -split ";" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    $normalizedTarget = $binDir.TrimEnd("\\").ToLowerInvariant()
    $alreadyExists = $false

    foreach ($part in $pathParts) {
        if ($part.TrimEnd("\\").ToLowerInvariant() -eq $normalizedTarget) {
            $alreadyExists = $true
            break
        }
    }

    if (-not $alreadyExists) {
        $newPath = if ([string]::IsNullOrWhiteSpace($currentUserPath)) { $binDir } else { "$currentUserPath;$binDir" }
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        Write-Host "  OK  Added to user PATH: $binDir"
    } else {
        Write-Host "  OK  PATH already contains: $binDir"
    }

    if (-not $alreadyExists) {
        $env:Path = "$env:Path;$binDir"
    }

    Write-Host ""
    Write-Host "Codexa installation completed." -ForegroundColor Green
    Write-Host "Executable launcher  : $(Join-Path $binDir 'codexa.cmd')"
    Write-Host "Global AGENTS.md     : $(Join-Path $InstallRoot 'AGENTS.md')"
    Write-Host ""
    Write-Host "Next: open a new terminal and run: codexa 'test'"
}
catch {
    Write-Host ""
    Write-Host "Setup failed." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
finally {
    Write-Host ""
    Read-Host "Press Enter to close"
}
