$codexaScript = Join-Path (Split-Path $PROFILE) "codexa.ps1"
if (Test-Path $codexaScript) {
    . $codexaScript
} else {
    Write-Warning "codexa.ps1 not found in $($codexaScript | Split-Path). Codexa commands will be unavailable."
}
