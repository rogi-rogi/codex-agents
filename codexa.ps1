function codexa {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Prompt
    )

    # Global AGENTS.md: PowerShell profile directory
    $globalAgentsPath = Join-Path (Split-Path $PROFILE) "AGENTS.md"
    $localAgentsPath  = Join-Path (Get-Location) "AGENTS.md"

    Write-Verbose "Global AGENTS.md path: $globalAgentsPath"
    Write-Verbose "Local  AGENTS.md path: $localAgentsPath"

    $promptSegments = @()

    # Global AGENTS.md
    if (Test-Path $globalAgentsPath) {
        $promptSegments += Get-Content $globalAgentsPath -Raw
    } else {
        # 안내: 글로벌 지침 파일이 없으면 정보 메시지 삽입
        $promptSegments += "[INFO] Global AGENTS.md not found. Running Codex without global agent rules."
    }

    # Local AGENTS.md (optional)
    if (Test-Path $localAgentsPath) {
        $promptSegments += Get-Content $localAgentsPath -Raw
    }

    # User prompt
    $extraPrompt = ($Prompt -join ' ').Trim()
    if (-not [string]::IsNullOrWhiteSpace($extraPrompt)) {
        $promptSegments += $extraPrompt
    }

    # Combine prompt
    $combinedPrompt = $promptSegments -join "`n"

    # Escape embedded double quotes so Codex receives one argument
    $escapedPrompt = $combinedPrompt -replace '"', '""'

    # Execute Codex
    codex $escapedPrompt
}
