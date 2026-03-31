@echo off
setlocal

set "CODEXA_HOME=%LOCALAPPDATA%\codexa"
set "CODEXA_PS1=%CODEXA_HOME%\bin\codexa.ps1"

if not exist "%CODEXA_PS1%" (
  echo codexa: not installed. Run setup-windows.ps1 first.
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "& { . '%CODEXA_PS1%'; codexa @args }" %*
set "EXIT_CODE=%ERRORLEVEL%"

exit /b %EXIT_CODE%
