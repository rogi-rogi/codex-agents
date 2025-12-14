# Codexa

![Windows](https://img.shields.io/badge/Platform-Windows-0078D4?logo=windows)

## 개요
**Codexa**는 `codex` CLI를 감싸는 가벼운 PowerShell 래퍼입니다.  
PowerShell 프로필 디렉터리에 있는 전역 `AGENTS.md`와 현재 프로젝트 디렉터리의 로컬 `AGENTS.md`를 자동으로 결합한 뒤, 사용자가 입력한 프롬프트를 덧붙여 `codex`를 실행합니다.

이를 통해 **모든 Codex 실행이 팀 공통 가이드라인과 프로젝트별 규칙을 항상 포함**하도록 만들 수 있습니다.

<br/>

## 구성 파일

- **`codexa.ps1`**  
  `codexa` 함수를 정의합니다.  
  - 전역 / 로컬 `AGENTS.md` 로드  
  - 사용자 입력 프롬프트 결합  
  - 최종 프롬프트를 `codex` CLI로 전달

- **`Microsoft.PowerShell_profile.ps1`**  
  PowerShell 시작 시 `codexa.ps1`를 dot-source 하여, 어디서든 `codexa` 명령을 사용할 수 있게 합니다.

- **`AGENTS.md`**  
  Codex 동작 규칙, 팀 가이드, 로그 규칙 등을 정의하는 파일입니다.  
  - 프로필 디렉터리: 전역 규칙  
  - 각 저장소 디렉터리: 프로젝트 전용 규칙(선택)

<br/>

## 설치 방법

1. `codex` CLI를 먼저 설치하고 인증을 완료합니다.
2. 이 폴더를 다음 경로에 배치합니다:
   ```
   %USERPROFILE%\Documents\WindowsPowerShell
   ```
   (다른 위치를 쓰고 싶다면 프로필 스크립트 경로를 수정하세요.)
3. 현재 PowerShell 프로필 경로를 확인합니다:
   ```powershell
   $PROFILE
   ```
4. 프로필 파일(`Microsoft.PowerShell_profile.ps1`)에 아래 내용을 추가합니다:
   ```powershell
   $codexaScript = Join-Path (Split-Path $PROFILE) "codexa.ps1"
   if (Test-Path $codexaScript) {
      . $codexaScript
   } else {
      Write-Warning "codexa.ps1 not found in $($codexaScript | Split-Path). Codexa commands will be unavailable."
   }
   ```
5. 새 PowerShell 창을 열고 다음 명령으로 정상 동작을 확인합니다:
   ```powershell
   codexa -Verbose "hello"
   ```

<br/>

## 사용 방법

```powershell
codexa "이슈 요약과 다음 조치 정리"
```

동작 방식:
- 전역 `AGENTS.md`가 항상 가장 먼저 포함됩니다.
- 현재 디렉터리에 `AGENTS.md`가 있다면 그 다음에 추가됩니다.
- 추가 인자는 공백으로 연결되어 프롬프트로 전달됩니다.
- 실제 실행은 `codex` CLI에 위임되므로, 인증·출력·응답 방식은 동일합니다.

<br/>

## AGENTS 적용 우선순위

1. 전역 `AGENTS.md`  
   (`%USERPROFILE%\Documents\WindowsPowerShell\AGENTS.md`)
2. 현재 작업 디렉터리의 로컬 `AGENTS.md`
3. `codexa` 실행 시 전달한 사용자 프롬프트

이 구조를 통해 **조직 공통 규칙 + 저장소별 규칙**을 자연스럽게 병합할 수 있습니다.

<br/>

## 검증 방법

- `codexa -Verbose "hello"` 실행 시, 감지된 AGENTS 경로가 출력되는지 확인합니다.
- `codex`가 정상적으로 응답하면 `codexa`는 프롬프트 결합 기능만 추가된 상태로 동일하게 동작합니다.


## 라이선스

자유롭게 사용, 수정, 배포할 수 있습니다.  
단, `AGENTS.md`에 포함된 내용은 내부 규칙이나 민감 정보가 있을 수 있으므로 공개 저장소에 업로드하기 전 반드시 검토하세요.
