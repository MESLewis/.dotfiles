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

CONFIG="meta/base.conf.yaml"
DOTBOT_DIR="meta/dotbot"

DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASEDIR}"
git submodule sync --quiet --recursive
git submodule update --init --recursive "${DOTBOT_DIR}"

"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"
exit $?

: # BEGIN CMD SCRIPT
:CMDSCRIPT
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
    echo UAC.ShellExecute "cmd.exe", "/k %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
echo WINDOWS INSTALL RUNNING
echo %CD%
set WORKING_DIR=%CD:~-9,9%
REM If we are not in .dotfiles directory assume we are in .dotfiles/meta and cd
IF NOT "%WORKING_DIR%" == ".dotfiles" cd ..

echo %CD%
echo Setting up required environment...

REM install chocolatey
call meta\init\WINDOWS_NT\00_install_chocolatey.bat

REM Install git
WHERE /q git
IF ERRORLEVEL == 1 (
echo "Installing git"
call bin\windows\install-app.bat git --limit-output --yes --params "/GitAndUnixToolsOnPath"
refreshenv
)

REM Install python
REM TODO Windows lies to you and tells you python is installed, but then it just launches the store
WHERE /q python
IF ERRORLEVEL == 1 (
echo "Installing python"
call bin\windows\install-app.bat python --yes --limit-output
refreshenv
)
REM END ENVIRONMENT SETUP

echo Environment setup finished

SET CONFIG=meta\base.conf.yaml
SET DOTBOT_DIR=meta\dotbot
SET DOTBOT_BIN=bin\dotbot.py
SET BASEDIR=%cd%

git rev-parse --is-inside-work-tree
IF ERRORLEVEL == 1 (
echo "Initializing git repository"
git clone https://github.com/meslewis/.dotfiles
cd .dotfiles
call meta\install.sh.cmd
exit
)

echo Updating meta/dotbot
REM TODO I don't need to run this every time
git -C "%DOTBOT_DIR%" submodule sync --quiet --recursive
git submodule update --init --recursive "%DOTBOT_DIR%"

echo Running...
python "%BASEDIR%\%DOTBOT_DIR%\%DOTBOT_BIN%" -d "%BASEDIR%" -c "%BASEDIR%\%CONFIG%" --no-color %*
