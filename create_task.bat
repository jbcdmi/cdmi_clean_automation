@echo off
:: Path to your VBS launcher
set "scriptPath=C:\Windows\Scripts\run_hidden.vbs"

:: Create scheduled task (runs at logon, hidden)
SCHTASKS /Create /TN "PC_AutoCleanup" /TR "wscript.exe \"%scriptPath%\"" /SC ONLOGON /RL HIGHEST /F

echo Task scheduled successfully!
pause
