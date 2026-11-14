# Signs specified files with the AI-ME Code Signing Certificate
param(
    [string[]]$Files = @("bin\AI-ME.exe")
)

$cert = Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert -ErrorAction SilentlyContinue | Where-Object { $_.Subject -like "*AI-ME*" } | Select-Object -First 1

if (-not $cert) {
    Write-Host "[!] No AI-ME certificate found. Running Create-Certificate.ps1..." -ForegroundColor Yellow
    $cert = & "$PSScriptRoot\Create-Certificate.ps1"
}

if (-not $cert) {
    Write-Error "Could not obtain code signing certificate."
    exit 1
}

$timestampServers = @(
    "http://timestamp.digicert.com",
    "http://timestamp.sectigo.com",
    "http://timestamp.comodoca.com"
)

foreach ($file in $Files) {
    if (Test-Path $file) {
        Write-Host "[*] Signing $file with certificate $($cert.Thumbprint)..." -ForegroundColor Cyan
        $signed = $false
        foreach ($ts in $timestampServers) {
            try {
                $res = Set-AuthenticodeSignature -FilePath $file -Certificate $cert -TimestampServer $ts -HashAlgorithm SHA256 -ErrorAction Stop
                if ($res.Status -eq "Valid" -or $res.Status -eq "UnknownError") {
                    Write-Host "[SUCCESS] Signed $file with timestamp ($ts)" -ForegroundColor Green
                    $signed = $true
                    break
                }
            } catch {
                # try next timestamp server
            }
        }
        if (-not $signed) {
            Write-Host "[*] Timestamping offline, signing without timestamp..." -ForegroundColor Yellow
            $res = Set-AuthenticodeSignature -FilePath $file -Certificate $cert -HashAlgorithm SHA256
            Write-Host "[SUCCESS] Signed $file (Status: $($res.Status))" -ForegroundColor Green
        }
    } else {
        Write-Host "[!] File not found: $file" -ForegroundColor Yellow
    }
}

