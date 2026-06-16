@echo off
setlocal EnableExtensions EnableDelayedExpansion

echo ======================================
echo  STARTING MASTER AUTOMATION SCRIPT
echo ======================================

:: ----------------------------
:: Step 1 - Remove old task
:: ----------------------------
echo [INFO] Removing scheduled task: PC_AutoCleanup ...
schtasks /Delete /TN "PC_AutoCleanup" /F >nul 2>&1

:: ----------------------------
:: Step 2 - Unlock Wallpaper
:: ----------------------------
set "SCRIPT_DIR=%~dp0."
set "TASKNAME=ForceDesktopWallpaper"
set "VBSFILE=%SCRIPT_DIR%wallpaper.vbs"
set "STARTUP=%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\wallpaper.lnk"

reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoChangingWallPaper /f >nul 2>&1

schtasks /Delete /TN "%TASKNAME%" /F >nul 2>&1

if exist "%STARTUP%" del /f /q "%STARTUP%" >nul 2>&1

if exist "%VBSFILE%" (
    attrib -h "%VBSFILE%" >nul 2>&1
    del /f /q "%VBSFILE%" >nul 2>&1
)

:: ----------------------------
:: Step 3 - Ask Cleanup Type
:: ----------------------------
echo.
echo ======================================
echo        SELECT CLEANUP TYPE
echo ======================================
echo.
echo 1. Full Cleanup
echo 2. Temp Files Only
echo.

choice /C 12 /N /M "Select option (1-2): "

if errorlevel 2 (
    set "CLEANUP_SCRIPT=cleanup_only_temp.bat"
) else (
    set "CLEANUP_SCRIPT=cleanup.bat"
)

echo.
echo Selected: %CLEANUP_SCRIPT%
echo.

:: ----------------------------
:: Step 4 - Copy Files
:: ----------------------------
set "SOURCE=%~dp0."
set "DEST=C:\Windows\Scripts"

if not exist "%DEST%" mkdir "%DEST%"

robocopy "%SOURCE%" "%DEST%" *.* /E /Z /NP /R:3 /W:5 >nul

echo [INFO] Files copied.

:: ----------------------------
:: Step 5 - Create Scheduled Task
:: ----------------------------
if exist "%DEST%\create_task.bat" (
    powershell -NoProfile -Command ^
    "Start-Process cmd.exe -ArgumentList '/c ""%DEST%\create_task.bat"" ""%CLEANUP_SCRIPT%""' -Verb RunAs"
) else (
    echo [ERROR] create_task.bat not found.
)

:: ----------------------------
:: Step 6 - Run Wallpaper Setup
:: ----------------------------
if exist "%DEST%\wallpaper.bat" (
    powershell -NoProfile -Command ^
    "Start-Process cmd.exe -ArgumentList '/c ""%DEST%\wallpaper.bat""' -Verb RunAs"
)

:: ----------------------------
:: Step 7 - Clean Run History
:: ----------------------------
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul 2>&1

echo.
echo ======================================
echo  ALL TASKS COMPLETED
echo ======================================
pause
exit