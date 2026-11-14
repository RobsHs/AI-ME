@echo off
title AI-ME - Unblock Files
echo =======================================================
echo    AI-ME - Remove Windows SmartScreen Download Block
echo =======================================================
echo.
echo [*] Removing Mark-of-the-Web (Zone.Identifier) from all files...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '%~dp0' -Recurse | Unblock-File -ErrorAction SilentlyContinue; Write-Host '`n[SUCCESS] All files unblocked successfully!' -ForegroundColor Green; Write-Host 'You can now run AI-ME and the installer without SmartScreen blocks.`n' -ForegroundColor Cyan"
echo.
pause

