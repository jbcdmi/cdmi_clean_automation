@echo off
setlocal

set "SELECTED_SCRIPT=%~1"

if "%SELECTED_SCRIPT%"=="" (
    echo No cleanup script specified.
    pause
    exit /b 1
)

echo Creating hidden launcher...

(
echo CreateObject("Wscript.Shell"^).Run """C:\Windows\Scripts\%SELECTED_SCRIPT%""", 0, False
) > "C:\Windows\Scripts\run_hidden.vbs"

echo Creating scheduled task...

SCHTASKS /Create ^
 /TN "PC_AutoCleanup" ^
 /TR "wscript.exe \"C:\Windows\Scripts\run_hidden.vbs\"" ^
 /SC ONLOGON ^
 /RL HIGHEST ^
 /F

echo.
echo Task created successfully.
echo Script selected:
echo %SELECTED_SCRIPT%
echo.

pause