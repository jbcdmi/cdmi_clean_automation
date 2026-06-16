Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = "C:\Windows\System32"
WshShell.Run """\\cdmi\software\_shared\_JB\script\cdmi_clean_automation\wallpaper.bat""", 0, False
