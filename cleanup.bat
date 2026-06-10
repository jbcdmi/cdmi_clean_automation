@echo off
echo Cleaning Temp folders...

:: Delete Temp
del /s /f /q "%temp%\*.*"
for /d %%i in ("%temp%\*") do rd /s /q "%%i"

:: Delete Windows Temp
del /s /f /q "C:\Windows\Temp\*.*"
for /d %%i in ("C:\Windows\Temp\*") do rd /s /q "%%i"

:: Delete Prefetch
del /s /f /q "C:\Windows\Prefetch\*.*"
for /d %%i in ("C:\Windows\Prefetch\*") do rd /s /q "%%i"

:: Delete Recent Items
del /s /f /q "%AppData%\Microsoft\Windows\Recent\*.*"

:: Empty Recycle Bin using PowerShell
powershell -command "Clear-RecycleBin -Force"

:: Delete Folder ::

:: Clean Desktop (keep Desktop folder)
del /s /f /q "%USERPROFILE%\Desktop\*.*"
for /d %%i in ("%USERPROFILE%\Desktop\*") do rd /s /q "%%i"

:: Clean Downloads (keep Downloads folder)
del /s /f /q "%USERPROFILE%\Downloads\*.*"
for /d %%i in ("%USERPROFILE%\Downloads\*") do rd /s /q "%%i"

:: Clean Documents (keep Documents folder)
del /s /f /q "%USERPROFILE%\Documents\*.*"
for /d %%i in ("%USERPROFILE%\Documents\*") do rd /s /q "%%i"

:: Clean Pictures (keep Pictures folder)
del /s /f /q "%USERPROFILE%\Pictures\*.*"
for /d %%i in ("%USERPROFILE%\Pictures\*") do rd /s /q "%%i"

:: Clean Videos (keep Videos folder)
del /s /f /q "%USERPROFILE%\Videos\*.*"
for /d %%i in ("%USERPROFILE%\Videos\*") do rd /s /q "%%i"

:: Clean Music (keep Music folder)
del /s /f /q "%USERPROFILE%\Music\*.*"
for /d %%i in ("%USERPROFILE%\Music\*") do rd /s /q "%%i"


setlocal EnableDelayedExpansion

:: ==================================================
:: D: CLEANUP - FIRST STARTUP EVERY MONDAY
:: Deletes folders older than 6 months
:: Keeps folders containing SDK or Unity
:: ==================================================

set "SCRIPT_DIR=C:\Windows\Scripts"
set "MARKER=%SCRIPT_DIR%\DDriveMondayCleanup.txt"

:: Create script folder if it doesn't exist
if not exist "%SCRIPT_DIR%" (
    mkdir "%SCRIPT_DIR%"
)

:: Get current day
for /f %%a in ('powershell -NoProfile -Command "(Get-Date).DayOfWeek"') do set "DAY=%%a"

if /I "!DAY!"=="Monday" (

    :: Get today's date
    for /f %%a in ('powershell -NoProfile -Command "(Get-Date).ToString(\"yyyy-MM-dd\")"') do set "TODAY=%%a"

    set "LASTRUN="

    :: Read marker file if it exists
    if exist "!MARKER!" (
        set /p LASTRUN=<"!MARKER!"
    )

    :: Run only once per Monday
    :: if not "!LASTRUN!"=="!TODAY!" 
	(

        echo Running Monday D: cleanup...

        :: Delete files in D:\ root only
        del /f /q "D:\*.*" 2>nul

        :: Delete folders older than 6 months,
        :: except folders whose names contain SDK or Unity
        for /f "delims=" %%i in ('
            powershell -NoProfile -Command ^
            "Get-ChildItem ''D:\'' -Directory | Where-Object { $_.Name -notmatch ''(?i)SDK|Unity'' -and $_.LastWriteTime -lt (Get-Date).AddMonths(-6) } | Select-Object -ExpandProperty FullName"
        ') do (
            echo Deleting old folder: %%i
            rd /s /q "%%i"
        )

        :: Save today's date
        echo !TODAY!>"!MARKER!"

        echo Cleanup completed.
    ) else (
        echo Cleanup already ran today.
    )

) else (
    echo Today is !DAY!. Cleanup runs only on Monday.
)

endlocal


echo Cleanup complete.
exit
