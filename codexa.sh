#!/bin/zsh
# Mac Codexa launcher: mirrors Windows PowerShell codexa.ps1 behavior

set -euo pipefail

GLOBAL_AGENTS_DEFAULT="$HOME/.config/codexa/AGENTS.md"

global_agents="${CODEXA_GLOBAL_AGENTS:-$GLOBAL_AGENTS_DEFAULT}"
local_agents="$PWD/AGENTS.md"

prompt_segments=()

if [[ -f "$global_agents" ]]; then
  prompt_segments+=("$(<"$global_agents")")
else
  prompt_segments+=("[INFO] Global AGENTS.md not found at $global_agents. Running Codex without global agent rules.")
fi

if [[ -f "$local_agents" ]]; then
  prompt_segments+=("$(<"$local_agents")")
fi

if [[ "$#" -gt 0 ]]; then
  prompt_segments+=("$*")
fi

if [[ "${#prompt_segments[@]}" -eq 0 ]]; then
  echo "codexa: no prompt provided" >&2
  exit 1
fi

combined_prompt="$(printf "%s\n" "${prompt_segments[@]}")"
escaped_prompt="${combined_prompt//\"/\"\"}"

if ! command -v codex >/dev/null 2>&1; then
  echo "codexa: 'codex' CLI not found. Install Codex CLI first." >&2
  exit 1
fi

codex "$escaped_prompt"
