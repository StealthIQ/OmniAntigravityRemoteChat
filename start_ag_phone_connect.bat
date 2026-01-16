@echo off
setlocal enabledelayedexpansion
title Antigravity Phone Connect

:: Navigate to the script's directory
cd /d "%~dp0"

echo ===================================================
echo   Antigravity Phone Connect Launcher
echo ===================================================
echo.

:: Check for Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed.
    echo Please install it from https://nodejs.org/
    pause
    exit /b
)

:: Install deps if missing
if not exist "node_modules" (
    echo [INFO] Installing dependencies...
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] npm install failed.
        pause
        exit /b
    )
)

:: Get Local IP
set "MYIP="
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address" /c:"IP Address"') do (
    set "tmpip=%%a"
    set "tmpip=!tmpip: =!"
    if not "!tmpip!"=="" set "MYIP=!tmpip!"
)

echo [READY] Server will be available at:
echo       http://!MYIP!:3000
echo.

:: Right-Click Context Menu (4 second timeout)
echo [CONTEXT MENU] Add "Open with Antigravity (Debug)" to Right-Click?
echo Press 'y' within 4 seconds to install, or wait to skip...
choice /c yn /t 4 /d n /m "Install"
if %errorlevel%==1 (
    echo [INFO] Requesting Registry modification...
    powershell -Command "Start-Process reg -ArgumentList 'add \"HKEY_CLASSES_ROOT\Directory\Background\shell\AntigravityDebug\" /t REG_SZ /v \"\" /d \"Open with Antigravity (Debug)\" /f' -Verb RunAs"
    powershell -Command "Start-Process reg -ArgumentList 'add \"HKEY_CLASSES_ROOT\Directory\Background\shell\AntigravityDebug\command\" /t REG_SZ /v \"\" /d \"cmd /c antigravity . --remote-debugging-port=9000\" /f' -Verb RunAs"
    powershell -Command "Start-Process reg -ArgumentList 'add \"HKEY_CLASSES_ROOT\Directory\shell\AntigravityDebug\" /t REG_SZ /v \"\" /d \"Open with Antigravity (Debug)\" /f' -Verb RunAs"
    powershell -Command "Start-Process reg -ArgumentList 'add \"HKEY_CLASSES_ROOT\Directory\shell\AntigravityDebug\command\" /t REG_SZ /v \"\" /d \"cmd /c cd /d %%1 && antigravity . --remote-debugging-port=9000\" /f' -Verb RunAs"
    echo [SUCCESS] Context menu added!
)
echo.

echo [STARTING] Launching monitor server...
node server.js
pause
