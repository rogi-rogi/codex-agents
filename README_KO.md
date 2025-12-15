# Codexa

![Windows](https://img.shields.io/badge/Platform-Windows-0078D4?logo=windows) ![macOS](https://img.shields.io/badge/Platform-macOS-000000?logo=apple)

## 개요

**Codexa**는 `codex` CLI를 보조하는 초경량 헬퍼 도구입니다.  
전역(Global) 및 로컬(Local) `AGENTS.md` 규칙을 자동으로 결합하고, 사용자가 입력한 프롬프트를 덧붙인 뒤, 하나의 결합된 프롬프트로 Codex CLI를 실행합니다.

Windows에서는 **PowerShell 스크립트**, macOS에서는 동일한 워크플로를 따르는 **Zsh 스크립트**로 구현되어 있으며, 운영체제와 무관하게 일관된 Codex 실행 환경을 제공합니다.

<br/>

## 레포지토리 구성

- **`codexa.ps1`**  
  PowerShell용 `codexa` 함수 구현  
  (AGENTS 로드 → 프롬프트 병합 → `codex` 호출)

- **`codexa.sh`**  
  macOS(Zsh)용 스크립트  
  PowerShell 버전과 동일한 동작을 수행

- **`Microsoft.PowerShell_profile.ps1`**  
  PowerShell 시작 시 `codexa.ps1`를 자동으로 로드하기 위한 부트스트랩 파일

- **`AGENTS.md`**  
  모든 Codex 실행에 적용될 공통 가이드라인

<br/>

## 설치 방법 (Windows / PowerShell)

1. `codex` CLI를 설치하고 PATH에 등록합니다.
2. 아래 파일들을 PowerShell의 기본 프로필 경로인 `%USERPROFILE%\Documents\WindowsPowerShell`에 복사합니다.
   - `codexa.ps1`
   - `Microsoft.PowerShell_profile.ps1`
   - `AGENTS.md`
3. 이미 `Microsoft.PowerShell_profile.ps1`가 존재한다면 다음 코드를 붙여넣으세요.

   ```powershell
   $codexaScript = Join-Path (Split-Path $PROFILE) "codexa.ps1"
   if (Test-Path $codexaScript) {
      . $codexaScript
   } else {
      Write-Warning "codexa.ps1 not found in $($codexaScript | Split-Path). Codexa commands will be unavailable."
   }
   ```

<br/>

## 설치 방법 (macOS / Zsh)

1. `codexa.sh`를 PATH에 포함된 디렉터리로 복사합니다.
   ```bash
   install -d "$HOME/bin"
   install codexa.sh "$HOME/bin/codexa"
   ```
2. 셸 설정 파일에 PATH를 추가합니다. (Zsh 기준)
   ```bash
   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
   ```
3. 전역으로 사용할 AGENTS.md를 설정한 경로에 복사/이동합니다.  
   예시 명령어는 다음과 같습니다.

   ```bash
   mkdir -p ~/.config/codexa
   cp /Users/[username]/codex-agents/AGENTS.md ~/.config/codexa/AGENTS.md
   ```

   > macOS에서 전역 AGENTS 기본 위치는 `~/.config/codexa/AGENTS.md` 입니다.

4. 터미널을 재시작하거나 다음 명령을 실행합니다.
   ```bash
   source ~/.zshrc
   ```

<br/>

## 사용 방법

```powershell
codexa
codexa "명령"
```

동작 방식:

- 전역 `AGENTS.md`를 먼저 로드합니다.
- 현재 저장소에 `AGENTS.md`가 있으면 추가로 로드합니다.
- 사용자가 입력한 프롬프트를 이어 붙입니다.
- 결합된 프롬프트를 `codex` CLI에 전달합니다.

<br/>

## AGENTS 구성 권장 방식

1. 전역 `AGENTS.md`
   본 저장소에서 제공하는 `AGENTS.md` 또는 전역으로 적용할 파일을 아래의 경로에 존재해야 합니다.

   - Windows: `%USERPROFILE%\Documents\WindowsPowerShell\AGENTS.md`
   - macOS: `~/.config/codexa/AGENTS.md`

2. 저장소별 `AGENTS.md`

   - 각 프로젝트 루트 또는 워크트리 근처에 배치

3. Codexa 역할
   - 전역 규칙 + 프로젝트 규칙 자동 병합
   - 매번 수동 복사 없이 동일한 가드레일 유지

<br/>

## 라이선스

자세한 내용은 [LICENSE](LICENSE)를 참고하세요.

> ⚠️ `AGENTS.md`에는 내부 규칙이나 민감한 지침이 포함될 수 있습니다.
