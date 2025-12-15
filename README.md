# Codexa

![Windows](https://img.shields.io/badge/Platform-Windows-0078D4?logo=windows) ![macOS](https://img.shields.io/badge/Platform-macOS-000000?logo=apple)

## Overview

**Codexa** is an ultra-lightweight helper tool that supplements the `codex` CLI.  
It automatically combines global and local `AGENTS.md` rules, appends the prompt entered by the user, and runs the Codex CLI with a single merged prompt.

On Windows it is implemented as a **PowerShell script**, and on macOS as a **Zsh script** that follows the same workflow, delivering a consistent Codex execution environment regardless of operating system.

![](/overview1.png)
![](/overview2.png)

<br/>

## Repository Layout

- **`codexa.ps1`**  
  `codexa` function implementation for PowerShell  
  (Load AGENTS → merge prompts → invoke `codex`)

- **`codexa.sh`**  
  macOS (Zsh) script  
  Performs the same behavior as the PowerShell version

- **`Microsoft.PowerShell_profile.ps1`**  
  Bootstrap file that autoloads `codexa.ps1` when PowerShell starts

- **`AGENTS.md`**  
  Common guidelines applied to every Codex run

<br/>

## Installation (Windows / PowerShell)

1. Install the `codex` CLI and add it to PATH.
2. Copy the files below to the default PowerShell profile directory `%USERPROFILE%\Documents\WindowsPowerShell`.
   - `codexa.ps1`
   - `Microsoft.PowerShell_profile.ps1`
   - `AGENTS.md`
3. If `Microsoft.PowerShell_profile.ps1` already exists, append the following code block.

   ```powershell
   $codexaScript = Join-Path (Split-Path $PROFILE) "codexa.ps1"
   if (Test-Path $codexaScript) {
      . $codexaScript
   } else {
      Write-Warning "codexa.ps1 not found in $($codexaScript | Split-Path). Codexa commands will be unavailable."
   }
   ```

<br/>

## Installation (macOS / Zsh)

1. Copy `codexa.sh` into a directory included in PATH.
   ```bash
   install -d "$HOME/bin"
   install codexa.sh "$HOME/bin/codexa"
   ```
2. Add that directory to the shell configuration (Zsh example).
   ```bash
   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
   ```
3. Copy or move the AGENTS.md you want to use globally into the configured path.  
   Example commands:

   ```bash
   mkdir -p ~/.config/codexa
   cp ./AGENTS.md ~/.config/codexa/AGENTS.md
   ```

   > The default global AGENTS location on macOS is `~/.config/codexa/AGENTS.md`.

4. Restart the terminal or run the command below.
   ```bash
   source ~/.zshrc
   ```

<br/>

## Usage

```powershell
codexa
codexa "command"
```

How it works:

- Loads the global `AGENTS.md` first.
- If there is an `AGENTS.md` in the current repository, loads it additionally.
- Appends the user-provided prompt.
- Sends the merged prompt to the `codex` CLI.

<br/>

## Recommended AGENTS Structure

1. Global `AGENTS.md`  
   Use the `AGENTS.md` from this repository or another global file located at the paths below.

   - Windows: `%USERPROFILE%\Documents\WindowsPowerShell\AGENTS.md`
   - macOS: `~/.config/codexa/AGENTS.md`

2. Repository-specific `AGENTS.md`

   - Place one near each project root or worktree

3. Role of Codexa
   - Automatically merges global rules and project rules
   - Keeps the same guardrails without manual copying each time

<br/>

## License

See [LICENSE](LICENSE) for details.

> ⚠️ `AGENTS.md` may contain internal policies or sensitive instructions.
