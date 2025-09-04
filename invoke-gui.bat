@echo off
echo Starting Windows Setup with GUI...
powershell -ExecutionPolicy Bypass -File "%~dp0invoke.ps1" -UseGUI
pause