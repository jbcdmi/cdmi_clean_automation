@echo off
:: =====================================================
::  Force Wallpaper Script - Silent + Auto Reset (Cleaned Up)
:: =====================================================

:: Detect current folder and set wallpaper path
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
set "WALLPAPER=%SCRIPT_DIR%\wallpaper.png"
set "BATCHFILE=%SCRIPT_DIR%\wallpaper.bat"
set "REGKEY=HKCU\Control Panel\Desktop"
set "VBSFILE=%SCRIPT_DIR%\wallpaper.vbs"
set "TASKNAME=ForceDesktopWallpaper"
set "STARTUP=%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\wallpaper.lnk"

echo ======================================
echo  Setting and Locking Desktop Wallpaper
echo ======================================

:: --- STEP 0: Cleanup any old startup shortcut to prevent double run
if exist "%STARTUP%" (
    del /f /q "%STARTUP%" >nul 2>&1
    echo Removed old startup shortcut.
)

:: --- STEP 1: Force background type = Picture
reg add "%REGKEY%" /v WallpaperType /t REG_DWORD /d 0 /f >nul

:: --- STEP 2: Overwrite wallpaper path (always)
reg add "%REGKEY%" /v Wallpaper /t REG_SZ /d "%WALLPAPER%" /f >nul

:: --- STEP 3: Set style (2 = Fill)
reg add "%REGKEY%" /v WallpaperStyle /t REG_SZ /d 2 /f >nul
reg add "%REGKEY%" /v TileWallpaper /t REG_SZ /d 0 /f >nul

:: --- STEP 4: Force apply using PowerShell
powershell -NoProfile -Command "Add-Type -Namespace Win32 -Name NativeMethods -MemberDefinition '[DllImport(\"user32.dll\",SetLastError=true)] public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);'; [Win32.NativeMethods]::SystemParametersInfo(20, 0, '%WALLPAPER%', 3)" 

echo Wallpaper applied successfully!

:: --- STEP 5: Create hidden VBS launcher with full absolute path
(
    echo Set WshShell = CreateObject("WScript.Shell"^)
    echo WshShell.CurrentDirectory = "C:\Windows\System32"
    echo WshShell.Run """%BATCHFILE%""", 0, False
) > "%VBSFILE%"

:: --- STEP 6: Remove old scheduled task (avoid duplicates)
schtasks /Delete /TN "%TASKNAME%" /F >nul 2>&1

:: --- STEP 7: Create new scheduled task (runs silently at login)
schtasks /Create /TN "%TASKNAME%" /TR "wscript.exe \"%VBSFILE%\"" /SC ONLOGON /RL HIGHEST /F >nul

echo Added Scheduled Task "%TASKNAME%" to apply wallpaper at every login!

:: --- STEP 8: Lock wallpaper settings
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoChangingWallPaper /t REG_DWORD /d 1 /f >nul
echo Wallpaper change locked!

:: --- STEP 9: Hide the VBS file (optional)
attrib +h "%VBSFILE%" >nul

echo ======================================
echo  DONE - Clean install complete
echo  (No duplicates, runs silently on every restart)
echo ======================================
pause
exit
