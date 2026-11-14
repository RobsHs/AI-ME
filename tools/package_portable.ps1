# Creates the Portable ZIP distribution of AI-ME
$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$dist = Join-Path $root "dist"
$binExe = Join-Path $root "bin\AI-ME.exe"
$cert = Join-Path $root "AI-ME-Certificate.cer"
$trustBat = Join-Path $root "Trust-Certificate.bat"
$unblockBat = Join-Path $root "Unblock-App.bat"
$readme = Join-Path $root "README.md"

$portableDir = Join-Path $dist "AI-ME-v2.1.0-Portable"
$zipPath = Join-Path $dist "AI-ME-v2.1.0-Portable.zip"

Write-Host "[*] Creating Portable ZIP package..." -ForegroundColor Cyan

if (Test-Path $portableDir) {
    Remove-Item -Path $portableDir -Recurse -Force
}
New-Item -ItemType Directory -Path $portableDir | Out-Null

Copy-Item $binExe -Destination $portableDir
Copy-Item $cert -Destination $portableDir
Copy-Item $trustBat -Destination $portableDir
Copy-Item $unblockBat -Destination $portableDir
Copy-Item $readme -Destination $portableDir

if (Test-Path $zipPath) {
    Remove-Item -Path $zipPath -Force
}

Compress-Archive -Path "$portableDir\*" -DestinationPath $zipPath -CompressionLevel Optimal
Remove-Item -Path $portableDir -Recurse -Force

Write-Host "[SUCCESS] Created $zipPath successfully!" -ForegroundColor Green

