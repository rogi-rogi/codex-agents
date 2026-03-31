# Codexa

![Windows](https://img.shields.io/badge/Platform-Windows-0078D4?logo=windows) ![macOS](https://img.shields.io/badge/Platform-macOS-000000?logo=apple)

## Overview

Codexa is a lightweight wrapper for the `codex` CLI.

It merges the three items below in order and sends them to `codex` as a single prompt.

- Global `AGENTS.md`: shared baseline rules
- Local `AGENTS.md`: project/task-specific rules in the current invocation location
- User input prompt (optional)

This approach keeps a global standard while still allowing project-specific personas and work styles.
It also helps reproduce the same agent behavior standards even across different ChatGPT accounts.

## Structure

You can install/run using OS-specific components.

```
📦codexa-agents
┣ 📂codexa-windows
┃ ┣ 📂codexa
┃ ┗ ⚙️ setup-windows.ps1: Windows installer script (folder copy + PATH registration)
┗ ⚙️codexa.sh: macOS zsh launcher script
```

> Automatic installer script is currently provided for Windows; a macOS installer script may be added later.

## Windows Installation

### Prerequisites

1. Install the `codex` CLI.
2. Ensure the `codex` command is available in terminal.

### Installation Steps

1. Open PowerShell in this repository.
2. Run the command below.

```powershell
.\codexa-windows\setup-windows.ps1
```

3. Open a new terminal.
4. Verify operation.

```powershell
where codexa
codexa "test"
```

### What setup-windows.ps1 does

1. Copies the `codexa-windows/codexa` folder under `%LOCALAPPDATA%`
   - Target: `%LOCALAPPDATA%\codexa`
2. Adds `%LOCALAPPDATA%\codexa\bin` to user `PATH` (only when missing)
3. Does not register a separate environment variable for global AGENTS

### Environment Variable Registration (Windows)

`PATH` (User scope): adds `%LOCALAPPDATA%\codexa\bin`

## Runtime Behavior (Windows)

- Entry point: `codexa` (`%LOCALAPPDATA%\codexa\bin\codexa.cmd`)
- Core logic: `%LOCALAPPDATA%\codexa\bin\codexa.ps1`
- Global AGENTS: `%LOCALAPPDATA%\codexa\AGENTS.md` (`..\AGENTS.md` relative to `bin`)
- Local AGENTS: `./AGENTS.md` in the current folder

## macOS Installation

1. Copy `codexa.sh` to a directory included in PATH.
   ```bash
   install -d "$HOME/bin"
   install codexa.sh "$HOME/bin/codexa"
   ```
2. Add PATH in your shell config file. (Zsh example)
   ```bash
   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
   ```
3. Copy/move the AGENTS.md to be used globally into the configured path.  
   Example commands:

   ```bash
   mkdir -p ~/.config/codexa
   cp ./AGENTS.md ~/.config/codexa/AGENTS.md
   ```

   > Default global AGENTS location on macOS is `~/.config/codexa/AGENTS.md`.

4. Restart terminal or run:
   ```bash
   source ~/.zshrc
   ```

## License

See [LICENSE](LICENSE).
