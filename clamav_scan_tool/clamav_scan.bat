@echo off
setlocal

set SCAN_TARGET=%1
if "%SCAN_TARGET%"=="" (
    echo Usage: clamav_scan.bat [folder_or_file_to_scan]
    exit /b 1
)

powershell -ExecutionPolicy Bypass -File "%~dp0scan.ps1" "%SCAN_TARGET%"
