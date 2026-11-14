# Generates and installs AI-ME Authenticode Code Signing Certificate
$ErrorActionPreference = "Stop"

$certSubject = "CN=Freda Giovani (AI-ME), O=AI-ME Open Source Project, OU=Software Development"
$friendlyName = "AI-ME Code Signing Certificate"
$cerPath = Join-Path $PSScriptRoot "..\AI-ME-Certificate.cer"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  AI-ME Code Signing Certificate Setup" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# 1. Find existing cert in CurrentUser\My
$existing = Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert -ErrorAction SilentlyContinue | Where-Object { $_.Subject -like "*AI-ME*" }

if ($existing) {
    $cert = $existing | Select-Object -First 1
    Write-Host "[*] Found existing AI-ME certificate: $($cert.Thumbprint)" -ForegroundColor Green
} else {
    Write-Host "[*] Creating new 4096-bit SHA256 Code Signing Certificate..." -ForegroundColor Yellow
    $cert = New-SelfSignedCertificate `
        -Type CodeSigningCert `
        -Subject $certSubject `
        -KeyLength 4096 `
        -KeySpec Signature `
        -KeyUsage DigitalSignature `
        -NotAfter (Get-Date).AddYears(10) `
        -HashAlgorithm SHA256 `
        -CertStoreLocation Cert:\CurrentUser\My `
        -FriendlyName $friendlyName

    Write-Host "[SUCCESS] Created certificate: $($cert.Thumbprint)" -ForegroundColor Green
}

# 2. Export public .cer
Export-Certificate -Cert $cert -FilePath $cerPath -Force | Out-Null
Write-Host "[*] Exported public certificate to: $cerPath" -ForegroundColor Green

# 3. Trust certificate in CurrentUser Root and TrustedPublisher stores
try {
    $rootStore = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root", "CurrentUser")
    $rootStore.Open("ReadWrite")
    $rootStore.Add($cert)
    $rootStore.Close()

    $pubStore = New-Object System.Security.Cryptography.X509Certificates.X509Store("TrustedPublisher", "CurrentUser")
    $pubStore.Open("ReadWrite")
    $pubStore.Add($cert)
    $pubStore.Close()

    Write-Host "[SUCCESS] Trusted certificate in CurrentUser Root & TrustedPublisher stores!" -ForegroundColor Green
} catch {
    Write-Host "[!] Note: Could not auto-install to user root: $_" -ForegroundColor Yellow
}

return $cert

