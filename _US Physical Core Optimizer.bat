@echo off
:: Set the new log file name
set "logFile=%~dp0Physical_core_optimizer_Logs_by_Snipy_Stream.log"

:: Delete the old log file if it exists to ensure a full reset
if exist %logFile% del %logFile%

:: Create a new log file and add the header
echo ======================================================== >> %logFile%
echo [Date] %date% [Time] %time% - Start of the Physical Core Optimizer by Snipy >> %logFile%
echo ======================================================== >> %logFile%
echo. >> %logFile%

:: Check for administrator rights
mkdir "%systemdrive%\testadmin" >nul 2>&1
if '%errorlevel%' NEQ '0' (
    echo Administrator mode required. Relaunching...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
rmdir "%systemdrive%\testadmin" >nul 2>&1

:: Add the DXVK_ASYNC=1 environment variable (permanently)
echo [Action] %time%      - Adding environment variable DXVK_ASYNC=1 >> %logFile%
setx DXVK_ASYNC 1 /M >nul
if %errorlevel% NEQ 0 (
    echo           [Error] Failed to add DXVK_ASYNC variable. >> %logFile%
    echo           Please run this script as administrator. >> %logFile%
) else (
    echo           [Info] Variable DXVK_ASYNC=1 successfully added. >> %logFile%
)

:: Disable code page display
chcp 65001 >nul

:: Aesthetic display of the optimizer
cls

:: Set text color to red and background to black (Code 4 = Red, Code 0 = Black)
color 04

:: Display title and subtitles with nice formatting
echo.
echo   ======================================================
echo                ** Core Physique Optimizer **
echo                    ** By Snipy_Stream **
echo   ======================================================
echo.
echo                     Launching Skyrim SKSE
echo                Detecting system information...
echo   ------------------------------------------------------
echo.

:: Detect processor name and total number of logical cores
for /f "tokens=*" %%a in ('powershell -Command "(Get-CimInstance -Class Win32_Processor).Name"') do (
    set processorName=%%a
)
for /f "tokens=*" %%a in ('powershell -Command "(Get-CimInstance -Class Win32_Processor).NumberOfLogicalProcessors"') do (
    set logicalCores=%%a
)
for /f "tokens=*" %%a in ('powershell -Command "(Get-CimInstance -Class Win32_Processor).NumberOfCores"') do (
    set physicalCores=%%a
)

echo                  Detected processor name:
echo             %processorName%
echo.
echo             Total number of logical cores: %logicalCores%
echo               Number of physical cores: %physicalCores%
echo             [Info] Detected processor name: %processorName% >> %logFile%
echo             [Info] Total logical cores: %logicalCores% >> %logFile%
echo             [Info] Physical cores: %physicalCores% >> %logFile%

:: Launch SKSE64
echo                  Launching SKSE64...
echo [Action] %time%         - Launching SKSE64 >> %logFile%
start "" "%~dp0skse64_loader.exe"
if %errorlevel% NEQ 0 (
    echo            [Error] Failed to launch SKSE64. >> %logFile%
    echo            SKSE64 could not be started. Please check the path. >> %logFile%
    exit /b
)

:: Wait a few seconds for SkyrimSE.exe to start
timeout /t 10 /nobreak >nul

:: Execute the PowerShell script to apply affinity
echo     // Applying CPU affinity to SkyrimSE.exe... \\
echo [Action] %time%      - Applying affinity to SkyrimSE.exe via SetAffinity.ps1 >> %logFile%
powershell -ExecutionPolicy Bypass -File "%~dp0SetAffinity.ps1" -PhysicalCores %physicalCores% -LogicalCores %logicalCores% -ProcessorName "%processorName%"
if %errorlevel% NEQ 0 (
    echo           [Error] Failed to execute SetAffinity.ps1. >> %logFile%
    echo           PowerShell script for affinity could not be executed. >> %logFile%
    exit /b
)

:: Mark the end of the optimizer in the log
echo [End] %time%      - Closing optimizer after applying affinity >> %logFile%
echo.
echo   ======================================================
echo              Optimization completed successfully!
echo   ======================================================
timeout /t 10 /nobreak >nul
exit
