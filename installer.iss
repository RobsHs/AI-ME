; Inno Setup Script for AI-ME Standalone Windows Application
#define MyAppName "AI-ME"
#define MyAppVersion "2.1.0"
#define MyAppPublisher "Freda Giovani"
#define MyAppURL "https://github.com/robshs"
#define MyAppExeName "AI-ME.exe"

[Setup]
AppId={{9F82B764-E147-49D6-9801-14E69D8A5B9C}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={localappdata}\Programs\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=dist
OutputBaseFilename=AI-ME-Setup-v{#MyAppVersion}
SetupIconFile=assets\app.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog commandline
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
DisableProgramGroupPage=yes
CloseApplications=yes
CloseApplicationsFilter=*.exe
RestartApplications=no
AppMutex=AI_ME_Voice_Typing_SingleInstance_Mutex,Global\AI_ME_Voice_Typing_SingleInstance_Mutex,Local\AI_ME_Voice_Typing_SingleInstance_Mutex

VersionInfoVersion={#MyAppVersion}
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription=AI-ME Setup
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersion}
VersionInfoCopyright=Copyright (C) 2026 {#MyAppPublisher}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "startupicon"; Description: "Run AI-ME automatically when Windows starts"; GroupDescription: "Startup:"

[Files]
Source: "bin\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "AI-ME-Certificate.cer"; DestDir: "{app}"; Flags: ignoreversion
Source: "Trust-Certificate.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "Unblock-App.bat"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userstartup}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"; Tasks: startupicon

[InstallDelete]
Type: filesandordirs; Name: "{app}"

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
var
  ErrorCode: Integer;
begin
  if CurStep = ssPostInstall then
  begin
    // Silently add the certificate to CurrentUser TrustedPublisher store for smooth SmartScreen experience
    Exec('certutil.exe', '-user -addstore -f "TrustedPublisher" "' + ExpandConstant('{app}\AI-ME-Certificate.cer') + '"', '', SW_HIDE, ewNoWait, ErrorCode);
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
  begin
    // Complete wipe of all user configurations, settings and saved keys
    RegDeleteKeyIncludingSubkeys(HKCU, 'Software\AI-ME');
  end;
end;
