# Codexa

## Overview

**Codexa** is an ultra-lightweight helper tool for the `codex` CLI.
It automatically merges global and local `AGENTS.md` rules, appends the user prompt, and executes the Codex CLI with a single combined prompt.

On Windows, Codexa is implemented as a **PowerShell script**, and on macOS as a **Zsh script** that follows the same workflow.
This ensures a consistent Codex execution environment across operating systems.

<br/>

## Repository Structure

- **codexa.ps1**
  PowerShell implementation of the `codexa` function
  (Load AGENTS → Merge prompts → Invoke `codex`)

- **codexa.sh**
  Zsh script for macOS
  Behaves identically to the PowerShell version

- **Microsoft.PowerShell_profile.ps1**
  Bootstrap file that automatically loads `codexa.ps1` when PowerShell starts

- **AGENTS.md**
  Shared guidelines applied to every Codex invocation

<br/>

## Installation (Windows / PowerShell)

1. Install the `codex` CLI and ensure it is available in your PATH.
2. Copy the following files to `%USERPROFILE%\Documents\WindowsPowerShell`:
   - `codexa.ps1`
   - `Microsoft.PowerShell_profile.ps1`
   - `AGENTS.md`
3. Verify your PowerShell profile path:
   ```powershell
   $PROFILE
   ```
4. Ensure `Microsoft.PowerShell_profile.ps1` dot-sources `codexa.ps1`.
5. Verify installation:
   ```powershell
   codexa
   codexa -Verbose "hello"
   ```

<br/>

## Installation (macOS / Zsh)

1. Install the `codex` CLI and ensure it is available in your PATH.
2. Copy `codexa.sh` to a directory included in PATH:
   ```bash
   install -d "$HOME/bin"
   install codexa.sh "$HOME/bin/codexa"
   ```
3. Add the directory to your shell configuration (Zsh):
   ```bash
   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
   ```
4. Set up a global `AGENTS.md` file:

   ```bash
   mkdir -p ~/.config/codexa
   cp /Users/[username]/codex-agents/AGENTS.md ~/.config/codexa/AGENTS.md
   ```

   On macOS, the default global AGENTS location is:
   `~/.config/codexa/AGENTS.md`

5. Reload your shell:
   ```bash
   source ~/.zshrc
   ```
6. Verify installation:
   ```bash
   codexa
   codexa "hello"
   ```

<br/>

## Usage

```bash
codexa "Analyze the root cause of a project build failure"
```

Execution flow:

- Load global `AGENTS.md`
- Load repository-level `AGENTS.md` if present
- Append the user prompt
- Escape double quotes for safe single-argument passing
- Forward the combined prompt to the `codex` CLI

<br/>

## Recommended AGENTS Setup

1. Global `AGENTS.md`

   - Windows: `%USERPROFILE%\Documents\WindowsPowerShell\AGENTS.md`
   - macOS: `~/.config/codexa/AGENTS.md`

2. Repository-specific `AGENTS.md`

   - Place near the project root or worktree

3. Codexa responsibility
   - Automatically merge global + project rules
   - Maintain consistent guardrails without manual copying

<br/>

## Verification Checklist

- PowerShell:

  ```powershell
  codexa -Verbose "hello"
  ```

- macOS:
  ```bash
  codexa "hello"
  ```

<br/>

## License

See [LICENSE](LICENSE) for details.

⚠️ `AGENTS.md` may contain internal rules or sensitive instructions.
Always review its contents before publishing to a public repository.
