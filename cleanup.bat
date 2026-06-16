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
for %F in ("%USERPROFILE%\Desktop\*") do @if /I not "%~xF"==".lnk" if /I not "%~xF"==".exe" del /f /q "%F"
for /d %D in ("%USERPROFILE%\Desktop\*") do @rd /s /q "%D"

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


echo Cleanup complete.
exit
