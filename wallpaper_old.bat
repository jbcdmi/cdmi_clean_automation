@echo off
setlocal EnableExtensions

:: =====================================================
:: Force Wallpaper + Lock Screen + Auto Reapply
:: Windows 10
:: =====================================================

:: Check for Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
echo Please run this script as Administrator.
pause
exit /b
)

:: Paths
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
set "WALLPAPER=%SCRIPT_DIR%\wallpaper.jpg"
set "LOCKSCREEN=%SCRIPT_DIR%\lockscreen.jpg"
set "BATCHFILE=%~f0"
set "VBSFILE=%SCRIPT_DIR%\wallpaper.vbs"
set "TASKNAME=ForceWallpaperLock"

echo =====================================
echo Applying Wallpaper and Lock Screen...
echo =====================================

:: -------------------------------------------------
:: Desktop Wallpaper
:: -------------------------------------------------

reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%WALLPAPER%" /f >nul
reg add "HKCU\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d 10 /f >nul
reg add "HKCU\Control Panel\Desktop" /v TileWallpaper /t REG_SZ /d 0 /f >nul

:: Lock wallpaper changes
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" ^
/v NoChangingWallPaper /t REG_DWORD /d 1 /f >nul

:: Refresh wallpaper
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

:: -------------------------------------------------
:: Lock Screen (Windows Pro recommended)
:: -------------------------------------------------

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f >nul

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" ^
/v LockScreenImage /t REG_SZ /d "%LOCKSCREEN%" /f >nul

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" ^
/v NoChangingLockScreen /t REG_DWORD /d 1 /f >nul

:: -------------------------------------------------
:: Create Hidden VBS Launcher
:: -------------------------------------------------

(
echo Set WshShell = CreateObject("WScript.Shell"^)
echo WshShell.Run Chr(34^) ^& "%BATCHFILE%" ^& Chr(34^), 0, False
) > "%VBSFILE%"

attrib +h "%VBSFILE%" >nul

:: -------------------------------------------------
:: Recreate Scheduled Task
:: -------------------------------------------------

schtasks /Delete /TN "%TASKNAME%" /F >nul 2>&1

schtasks /Create ^
/TN "%TASKNAME%" ^
/TR "wscript.exe "%VBSFILE%"" ^
/SC ONLOGON ^
/RL HIGHEST ^
/F >nul

gpupdate /force >nul 2>&1

echo.
echo =====================================
echo Completed Successfully
echo =====================================
echo Wallpaper locked.
echo Lock screen configured.
echo Auto-reapply task installed.
echo.

pause
exit
