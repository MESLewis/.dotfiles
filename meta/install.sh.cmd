: # This script is compatible with sh and cmd
:<<"::CMDLITERAL"
@echo off
GOTO :CMDSCRIPT
::CMDLITERAL

: # TODO ensure we are being run from .dotfiles and not meta

: # BEGIN BASH SCRIPT
echo "This will be run if we are in ${SHELL}"

#set -e
set -x

CONFIG="meta/install.conf.yaml"
DOTBOT_DIR="meta/dotbot"

DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASEDIR}"
: # git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
git submodule sync --quiet --recursive
git submodule update --init --recursive "${DOTBOT_DIR}"

"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"
exit $?

: # BEGIN CMD SCRIPT
:CMDSCRIPT

set WORKING_DIR=%CD:~-9,9%
REM If we are not in .dotfiles directory assume we are in .dotfiles/meta and cd
IF NOT "%WORKING_DIR%" == ".dotfiles" cd ..

set NEED_CHOCO=0
set NEED_GIT=0

WHERE /q git
IF ERRORLEVEL == 1 (
echo Git will be installed
set NEED_CHOCO=1
set NEED_GIT=1
)

REM Jump to post environment setup
IF "%NEED_CHOCO%" == "0" IF "%NEED_GIT%" == "0" GOTO ENVIRONMENT_GOOD

echo Setting up required environment...
REM Ensure we are running as admin
REM BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

REM Install chocolatey if doesn't exist.
REM TODO check for this like checking for git at the beginning
IF NOT EXIST %ALLUSERSPROFILE%\chocolatey\bin\choco.exe (
echo "Installing chocolatey"
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command " [System.Net.ServicePointManager]REMSecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
refreshenv
)

REM Install git
IF %NEED_GIT% == 1 (
echo "Installing git with chocolatey"
choco install git --limit-output --yes --params "/GitAndUnixToolsOnPath"
refreshenv
set NEED_GIT=0
)
REM END NEED_GIT

REM TODO install python


REM END ENVIRONMENT SETUP

echo Environment setup finished
:ENVIRONMENT_GOOD

echo Running

SET CONFIG=meta\install.conf.yaml
SET DOTBOT_DIR=meta\dotbot
SET DOTBOT_BIN=bin\dotbot.py
SET BASEDIR=%cd%

cd %cd%
REM TODO I don't need to run this every time
git submodule sync --quiet --recursive
git submodule update --init --recursive "%DOTBOT_DIR%"

@echo on

python "%BASEDIR%\%DOTBOT_DIR%\%DOTBOT_BIN%" -d "%BASEDIR%" -c "%CONFIG%"  %*
