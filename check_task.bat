@echo off
schtasks /query /TN "PC_AutoCleanup" /FO LIST /V | find "Status"
pause
