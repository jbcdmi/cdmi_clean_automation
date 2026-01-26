
# Windows Startup Cleanup Automation

## Overview

This repository provides a **centrally managed Windows startup automation framework** using batch (`.bat`) scripts.  
The automation runs **on every system startup** to ensure **consistent cleanup, configuration, and presentation** across multiple Windows PCs.

Scripts are **automatically synchronized from GitHub** on each boot, ensuring that all machines always execute the **latest approved version** without manual intervention.

This solution is well-suited for:

- Corporate environments  
- Computer labs  
- Schools & training centers  
- Shared or kiosk systems  
- Managed IT deployments  

---

## Key Capabilities

### 🧹 System Cleanup (Executed on Every Startup)

The automation performs routine system hygiene tasks:

- Clears **Windows Temp directory**
- Clears **User Temp (`%TEMP%`)**
- Clears **Recent files**
- Clears **Prefetch data**

**Benefits:**
- Frees disk space
- Improves system responsiveness
- Reduces long-term clutter
- Ensures consistent system state across machines

---

### 🖼️ Wallpaper Standardization

- Resets the desktop wallpaper to a **predefined corporate/standard image**
- Enforces **visual consistency** across all PCs
- Ideal for branded or controlled environments

---

## Repository Structure
cdmi_clean_automation/
├── auto_clean_and_wallpaper_task.bat # Main orchestrator script that runs cleanup and wallpaper tasks
├── check_task.bat # Verifies if the automation tasks are already scheduled/running
├── cleanup.bat # Performs system cleanup (Temp, Recent, Prefetch, etc.)
├── launcher.ahk # AutoHotkey script to launch tasks with optional GUI or hidden execution
├── run_hidden.vbs # VBScript to execute batch files silently without opening a console window
├── wallpaper.bat # Sets the desktop wallpaper to the standard image
└── wallpaper.png # Standard wallpaper image used by wallpaper.bat

**Notes:**

- `auto_clean_and_wallpaper_task.bat` is the entry point and calls `cleanup.bat` and `wallpaper.bat`.
- `launcher.ahk` and `run_hidden.vbs` are used to **run scripts silently** or with optional automation triggers.
- All other files are supporting resources for **consistent cleanup and configuration**.

---

## Architecture & Execution Flow

### Startup Execution Model

1. A **bootstrap script** is configured to run at Windows startup  
   (via Task Scheduler, Startup folder, or Group Policy)

2. The bootstrap script:
   - Downloads the latest version of this GitHub repository as a ZIP
   - Extracts the contents locally
   - Copies scripts to a secured directory:
     ```
     C:\Windows\Scripts
     ```
   - Executes the main controller script (`auto_clean_and_wallpaper_task.bat`)

3. `auto_clean_and_wallpaper_task.bat` orchestrates:
   - System cleanup tasks
   - Wallpaper reset

4. On every reboot, **the latest scripts from GitHub are used**

> ⚠️ No scripts are executed directly from the internet.  
> All code is downloaded, extracted, and executed **locally**.

---

## Bootstrap Script (Startup Loader)

```bat
@echo off
setlocal

set TARGET=C:\Windows\Scripts
set ZIPURL=https://github.com/jbcdmi/cdmi_clean_automation/archive/refs/heads/main.zip
set ZIPFILE=%TEMP%\cdmi_clean_automation.zip
set EXTRACT=%TEMP%\cdmi_clean_automation_extract

timeout /t 15 /nobreak >nul

if not exist "%TARGET%" mkdir "%TARGET%"

rmdir /s /q "%EXTRACT%" 2>nul

powershell -Command "Invoke-WebRequest '%ZIPURL%' -OutFile '%ZIPFILE%'"
powershell -Command "Expand-Archive -Force '%ZIPFILE%' '%EXTRACT%'"

xcopy "%EXTRACT%\cdmi-clean-automation-main\*" "%TARGET%\" /E /Y /I

del /f /q "%ZIPFILE%"
rmdir /s /q "%EXTRACT%"

call "%TARGET%\auto_clean_and_wallpaper_task.bat.bat"

endlocal
exit /b
