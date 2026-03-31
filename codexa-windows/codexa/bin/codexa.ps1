[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Prompt
)

function codexa {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Prompt
    )

    # Global AGENTS lives one level above this script: ..\AGENTS.md
    $globalAgentsPath = Join-Path $PSScriptRoot "..\AGENTS.md"

    $localAgentsPath = Join-Path (Get-Location) "AGENTS.md"

    Write-Verbose "Global AGENTS.md path: $globalAgentsPath"
    Write-Verbose "Local  AGENTS.md path: $localAgentsPath"

    $promptSegments = @()

    if (Test-Path $globalAgentsPath) {
        $promptSegments += Get-Content $globalAgentsPath -Raw
    } else {
        $promptSegments += "[INFO] Global AGENTS.md not found at $globalAgentsPath. Running Codex without global agent rules."
    }

    if (Test-Path $localAgentsPath) {
        $promptSegments += Get-Content $localAgentsPath -Raw
    }

    $extraPrompt = ($Prompt -join " ").Trim()
    if (-not [string]::IsNullOrWhiteSpace($extraPrompt)) {
        $promptSegments += $extraPrompt
    }

    $combinedPrompt = $promptSegments -join "`n"
    $escapedPrompt = $combinedPrompt -replace '"', '""'

    codex $escapedPrompt
}

# If this file is executed directly (not dot-sourced), run codexa immediately.
if ($MyInvocation.InvocationName -ne ".") {
    codexa @Prompt
}
