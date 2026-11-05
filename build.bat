@echo off
if exist "D:\Windhawk\Compiler\bin\clang++.exe" (
    set COMPILER=D:\Windhawk\Compiler\bin\clang++.exe
) else (
    set COMPILER=clang++.exe
)

if not exist bin mkdir bin

echo Compiling resources (app icon)...
C:\MinGW\bin\windres.exe -O coff resource.rc resource.o
python fix_coff.py resource.o resource64.o

echo Compiling AI-ME Standalone Windows Application...
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
    src\AI-ME.cpp ^
    resource64.o ^
    -o bin\AI-ME.exe ^
    -lole32 -lshell32 -lgdi32 -ladvapi32 -lcrypt32 -lwinhttp -ld2d1 -ldwrite -lshcore -ldwmapi -lcomctl32 -lwinmm -loleaut32 -lruntimeobject -luxtheme

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Built bin\AI-ME.exe successfully!
    if exist resource.o del resource.o
    if exist resource64.o del resource64.o
) else (
    echo [ERROR] Build failed with code %ERRORLEVEL%
)
