@echo off
setlocal EnableDelayedExpansion

if exist "D:\Windhawk\Compiler\bin\clang++.exe" (
    set COMPILER=D:\Windhawk\Compiler\bin\clang++.exe
) else (
    set COMPILER=clang++.exe
)

if not exist bin mkdir bin
if not exist dist mkdir dist

echo =======================================================
echo   AI-ME Build Pipeline (Security Hardened ^& Signed)
echo =======================================================
echo.

echo [1/5] Compiling resources (Manifest, VersionInfo, App Icon)...
C:\MinGW\bin\windres.exe -O coff resource.rc resource.o
python fix_coff.py resource.o resource64.o

echo [2/5] Compiling AI-ME C++23 Native Executable (ASLR, DEP enabled)...
%COMPILER% ^
    -target x86_64-w64-mingw32 ^
    -std=c++23 ^
    -DUNICODE ^
    -D_UNICODE ^
    -DWINVER=0x0A00 ^
    -D_WIN32_WINNT=0x0A00 ^
    -D_WIN32_IE=0x0A00 ^
    -DNTDDI_VERSION=0x0A000008 ^
    -D__USE_MINGW_ANSI_STDIO=0 ^
    -Wno-pragma-pack ^
    -Wno-pragma-system-header-outside-header ^
    -O2 ^
    -mwindows ^
    -municode ^
    -static ^
    -Wl,--dynamicbase ^
    -Wl,--nxcompat ^
    -Wl,--high-entropy-va ^
    src\AI-ME.cpp ^
    resource64.o ^
    -o bin\AI-ME.exe ^
    -lole32 -lshell32 -lgdi32 -ladvapi32 -lcrypt32 -lwinhttp -ld2d1 -ldwrite -lshcore -ldwmapi -lcomctl32 -lwinmm -loleaut32 -lruntimeobject -luxtheme

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Compilation failed with code %ERRORLEVEL%
    exit /b %ERRORLEVEL%
)

if exist resource.o del resource.o
if exist resource64.o del resource64.o
echo [SUCCESS] Built bin\AI-ME.exe successfully!

echo.
echo [3/5] Digitally signing bin\AI-ME.exe with Authenticode ^& DigiCert Timestamp...
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\Sign-Binaries.ps1 -Files "bin\AI-ME.exe"

echo.
echo [4/5] Building Inno Setup Installer...
set "ISCC_PATH="
if exist "C:\Users\ADVAN\AppData\Local\Programs\Inno Setup 6\ISCC.exe" set "ISCC_PATH=C:\Users\ADVAN\AppData\Local\Programs\Inno Setup 6\ISCC.exe"
if not defined ISCC_PATH if exist "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" set "ISCC_PATH=C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
if not defined ISCC_PATH if exist "C:\Program Files\Inno Setup 6\ISCC.exe" set "ISCC_PATH=C:\Program Files\Inno Setup 6\ISCC.exe"

if defined ISCC_PATH (
    "%ISCC_PATH%" installer.iss
    if !ERRORLEVEL! EQU 0 (
        echo [SUCCESS] Built dist\AI-ME-Setup-v2.1.0.exe!
        echo Digitally signing installer...
        powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\Sign-Binaries.ps1 -Files "dist\AI-ME-Setup-v2.1.0.exe"
    ) else (
        echo [WARNING] Inno Setup compilation failed with code !ERRORLEVEL!
    )
) else (
    echo [NOTE] Inno Setup compiler (ISCC.exe) not found. Skipping setup packaging.
)

echo.
echo [5/5] Packaging Portable Distribution ZIP...
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\package_portable.ps1

echo.
echo =======================================================
echo    BUILD COMPLETE - ALL ARTIFACTS HARDENED ^& READY!
echo =======================================================
