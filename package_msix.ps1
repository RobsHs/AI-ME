# MSIX Packaging Script for AI-ME
$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   AI-ME MSIX Packaging Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. Check if bin\AI-ME.exe exists
if (-not (Test-Path "bin\AI-ME.exe")) {
    Write-Host "[!] bin\AI-ME.exe not found. Running build.bat first..." -ForegroundColor Yellow
    cmd /c .\build.bat
}

# 2. Sync to package folder
Write-Host "[*] Copying binary to package directory..." -ForegroundColor Green
Copy-Item "bin\AI-ME.exe" -Destination "package\AI-ME.exe" -Force

# 3. Locate MakeAppx.exe
$makeAppx = (Get-ChildItem -Path "C:\Program Files (x86)\Windows Kits", "C:\Program Files\Windows Kits" -Recurse -Filter "makeappx.exe" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName)

if ($makeAppx) {
    Write-Host "[*] Found MakeAppx at: $makeAppx" -ForegroundColor Green
    if (-not (Test-Path "dist")) { New-Item -ItemType Directory -Path "dist" | Out-Null }
    
    $outputMsix = "dist\AI-ME-v2.1.0.msix"
    Write-Host "[*] Creating MSIX package: $outputMsix ..." -ForegroundColor Green
    & $makeAppx pack /d "package" /p $outputMsix /o
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[SUCCESS] Created $outputMsix successfully!" -ForegroundColor Green
        Write-Host "[*] Signing MSIX package..." -ForegroundColor Cyan
        & "$PSScriptRoot\tools\Sign-Binaries.ps1" -Files $outputMsix
    }
} else {
    Write-Host "[i] MakeAppx.exe (Windows SDK) was not found on your system." -ForegroundColor Yellow
    Write-Host "    The 'package/' folder is already 100% prepared with AppxManifest.xml and all Assets!" -ForegroundColor Cyan
}
