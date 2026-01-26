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

echo Cleanup complete.
exit
