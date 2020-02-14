@echo off
REM this assumes choco is installed and on path.
choco upgrade -yes --limit-output %*
refreshenv