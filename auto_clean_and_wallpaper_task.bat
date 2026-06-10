@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: =====================================================
::  Master Script - Cleanup, Unlock, Copy, Run
:: =====================================================

echo ======================================
echo  STARTING MASTER AUTOMATION SCRIPT
echo ======================================

:: ----------------------------
:: Step 1 - Remove old task
:: ----------------------------
echo [INFO] Removing scheduled task: PC_AutoCleanup ...
schtasks /Delete /TN "PC_AutoCleanup" /F >nul 2>&1
if %ERRORLEVEL%==0 (
    echo [INFO] Task "PC_AutoCleanup" removed successfully.
) else (
    echo [WARN] Task "PC_AutoCleanup" not found or could not be removed.
)

:: ----------------------------
:: Step 2 - Unlock Wallpaper
:: ----------------------------
set "SCRIPT_DIR=%~dp0."
set "TASKNAME=ForceDesktopWallpaper"
set "VBSFILE=%SCRIPT_DIR%wallpaper.vbs"
set "STARTUP=%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\wallpaper.lnk"

echo [INFO] Unlocking Desktop Wallpaper Settings...

reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoChangingWallPaper /f >nul 2>&1
echo [INFO] Wallpaper change unlocked!

schtasks /Delete /TN "%TASKNAME%" /F >nul 2>&1
echo [INFO] Scheduled task "%TASKNAME%" removed!

if exist "%STARTUP%" (
    del /f /q "%STARTUP%" >nul 2>&1
    echo [INFO] Old startup shortcut removed!
)

if exist "%VBSFILE%" (
    attrib -h "%VBSFILE%" >nul 2>&1
    del /f /q "%VBSFILE%" >nul 2>&1
    echo [INFO] VBS launcher deleted!
)

echo [INFO] Wallpaper unlocked successfully.

:: ----------------------------
:: Step 3 - Copy files
:: ----------------------------
set "SOURCE=%~dp0."
set "DEST=C:\Windows\Scripts"

set "TASKBAT=create_task.bat"
set "WALLBAT=wallpaper.bat"
set "WALLIMG=wallpaper.png"

echo [INFO] Copying from "%SOURCE%" to "%DEST%"...

if not exist "%DEST%" (
    mkdir "%DEST%"
)

robocopy "%SOURCE%" "%DEST%" *.* /E /Z /NP /R:3 /W:5 >nul
echo [INFO] Copy complete.

:: ----------------------------
:: Debug verification
:: ----------------------------
echo [DEBUG] Files in %DEST%:
dir "%DEST%"

:: ----------------------------
:: Step 4 - Run create_task.bat
:: ----------------------------
if exist "%DEST%\%TASKBAT%" (
    echo [INFO] Running %TASKBAT% as administrator...
    powershell -NoProfile -Command ^
        "Start-Process cmd.exe -ArgumentList '/c \"%DEST%\%TASKBAT%\"' -Verb RunAs"
) else (
    echo [ERROR] %TASKBAT% not found in %DEST%
)

:: ----------------------------
:: Step 5 - Run wallpaper.bat
:: ----------------------------
if exist "%DEST%\%WALLBAT%" (
    echo [INFO] Running %WALLBAT% as administrator...
    powershell -NoProfile -Command ^
        "Start-Process cmd.exe -ArgumentList '/c \"%DEST%\%WALLBAT%\"' -Verb RunAs"
) else (
    echo [ERROR] %WALLBAT% not found in %DEST%
)

:: ----------------------------
:: Step 6 - Clean Run dialog history
:: ----------------------------
echo [INFO] Cleaning Run dialog history...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul 2>&1

echo ======================================
echo  ALL TASKS COMPLETED
echo ======================================
pause
exit /b