# Codexa

![Windows](https://img.shields.io/badge/Platform-Windows-0078D4?logo=windows) ![macOS](https://img.shields.io/badge/Platform-macOS-000000?logo=apple)

## Overview
Codexa is a tiny helper around the `codex` CLI. It stitches together global and local `AGENTS.md` rules, appends the user prompt, escapes double quotes, and forwards the single combined prompt to the Codex CLI. The Windows version is implemented in PowerShell, and the macOS version mirrors the same workflow with a small Zsh script.

<br/>

## Repository Contents
- `codexa.ps1` ? PowerShell function that loads AGENTS, merges prompts, and calls `codex`.
- `codexa.sh` ? Zsh script that offers the same behavior on macOS.
- `Microsoft.PowerShell_profile.ps1` ? Bootstraps `codexa.ps1` for every PowerShell session.
- `AGENTS.md` ? Shared guidelines for every invocation (global + per-repo).

<br/>

## Installation (Windows / PowerShell)
1. Install the `codex` CLI and make sure it is available on PATH.
2. Copy `codexa.ps1`, `Microsoft.PowerShell_profile.ps1`, and (optionally) `AGENTS.md` into `%USERPROFILE%\Documents\WindowsPowerShell`.
3. Launch PowerShell and confirm `$PROFILE` points to that directory.
4. Ensure `Microsoft.PowerShell_profile.ps1` dot-sources `codexa.ps1` (the provided file already does this).
5. Run `codexa -Verbose "hello"` to confirm the wiring.

<br/>

## Installation (macOS / Zsh)
1. Install the `codex` CLI and expose it on PATH.
2. Copy `codexa.sh` to a directory on PATH, e.g. `~/bin`:
   ```bash
   install -d "$HOME/bin"
   install codexa.sh "$HOME/bin/codexa"
   ```
3. Ensure the directory is exported in your shell config (Zsh shown):
   ```bash
   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
   ```
4. Restart the terminal or `source ~/.zshrc`.
5. Run `codexa "hello"` to verify everything works.

> Global AGENT location on macOS defaults to `~/.config/codexa/AGENTS.md`

<br/>

## Usage
```powershell
codexa
codexa "hello"
codexa -Verbose "hello"
```
Behavior:
- Loads the global `AGENTS.md`. If not found, prints an informational note.
- Loads the local `AGENTS.md` from the current repository (if it exists).
- Concatenates user-provided prompt text.
- Escapes embedded `"` characters so Codex receives a single argument.
- Calls `codex` CLI with the merged prompt.

<br/>

## AGENTS Layout Suggestions
1. Global `AGENTS.md`: `%USERPROFILE%\Documents\WindowsPowerShell\AGENTS.md` (Windows) or `~/.config/codexa/AGENTS.md` (macOS).
2. Per-repo `AGENTS.md`: Checked into each project near the worktree root.
3. `codexa` merges them automatically to keep shared guardrails and project-specific rules synchronized.

## Verification Checklist
- `codexa -Verbose "hello"` (PowerShell) shows the AGENTS paths it used.
- `codexa "hello"` (macOS) runs without errors and reaches `codex`.

## License
See [LICENSE](LICENSE).
