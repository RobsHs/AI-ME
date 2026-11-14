@echo off
setlocal EnableDelayedExpansion
title AI-ME - Install & Trust Certificate
echo =======================================================
echo    AI-ME - Code Signing Certificate Trust Tool
echo =======================================================
echo.

set "CER_FILE=%~dp0AI-ME-Certificate.cer"
if not exist "%CER_FILE%" (
    echo [ERROR] Certificate file not found: %CER_FILE%
    pause
    exit /b 1
)

echo [*] Installing certificate to Current User Trusted Publishers...
certutil.exe -user -addstore -f "TrustedPublisher" "%CER_FILE%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [OK] Registered in Current User Trusted Publishers.
)

net session >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [*] Installing certificate to Local Machine Root & Trusted Publishers...
    certutil.exe -addstore -f "Root" "%CER_FILE%"
    certutil.exe -addstore -f "TrustedPublisher" "%CER_FILE%"
    echo.
    echo =======================================================
    echo [SUCCESS] AI-ME Certificate is now fully trusted!
    echo Windows SmartScreen and Defender will recognize AI-ME
    echo as a verified application on this machine.
    echo =======================================================
) else (
    echo [*] Requesting Administrator elevation to trust in Root Authorities...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process cmd -ArgumentList '/c certutil.exe -addstore -f Root """%CER_FILE%""" && certutil.exe -addstore -f TrustedPublisher """%CER_FILE%""" && echo. && echo [SUCCESS] Certificate installed into Trusted Root! && timeout /t 3' -Verb RunAs"
    echo.
    echo [OK] Elevation process launched. Please click 'Yes' on the UAC prompt.
)

echo.
pause

