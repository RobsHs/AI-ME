# AI-ME - Next-Gen AI Voice Typing, Coding & Automation Assistant

<p align="center">
  <img src="assets/preview_256.png" width="128" height="128" alt="AI-ME Icon" />
</p>

<p align="center">
  <strong>Speak, and it's written. Seamless, real-time voice typing and intelligent automation for Windows.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-0078D6?logo=windows" alt="Platform: Windows" />
  <img src="https://img.shields.io/badge/Language-Native%20C%2B%2B23-00599C?logo=c%2B%2B" alt="Language: C++23" />
  <img src="https://img.shields.io/badge/Graphics-Direct2D%20%26%20DirectWrite-00BCF2" alt="Direct2D" />
  <img src="https://img.shields.io/badge/Audio-Universal%20WASAPI%20Engine-green" alt="WASAPI" />
  <img src="https://img.shields.io/badge/Security-Authenticode%20Signed%20%7C%20ASLR%20%7C%20DEP-brightgreen" alt="Security Hardened" />
  <img src="https://img.shields.io/badge/Version-v2.1.0-blue" alt="Version 2.1.0" />
  <img src="https://img.shields.io/badge/License-MIT-brightgreen" alt="License: MIT" />
</p>

---

## 🌟 Overview

**AI-ME** is a native, ultra-lightweight Windows desktop assistant written in modern **C++23** with **zero external runtime dependencies**. It bridges real-time voice recording with state-of-the-art AI speech and language models, automatically transcribing, punctuating, and formatting your spoken words directly into any application—whether you are writing code in VS Code, composing documents in Microsoft Word, replying to emails in Outlook, or chatting on Discord.

Designed with an obsession for speed and elegance, AI-ME uses **hardware-accelerated Direct2D / DirectWrite**, **Windows 11 Acrylic blur & Mica effects**, and a **Universal Low-Latency WASAPI Audio Engine**.

---

## 🛡️ v2.1.0 Universal Compatibility & Security Hardening

Version **v2.1.0** introduces a major cross-device compatibility overhaul addressing audio capture across diverse hardware and resolving Windows Defender / SmartScreen installation hurdles:

### 1. Universal Multi-Tier Audio Engine (100% Microphone Support)
- **Multi-Tier Format Fallback**:
  - **Tier 1**: Direct 16 kHz IEEE Float with OS `AUTOCONVERTPCM` and Event-Driven capture.
  - **Tier 2**: Direct 16 kHz IEEE Float with OS `AUTOCONVERTPCM` in Timer-Polling mode.
  - **Tier 3**: Device Native Mix Format (`GetMixFormat`) with Event-Driven capture.
  - **Tier 4**: Device Native Mix Format with Timer-Polling mode (universal fallback for legacy/virtual devices).
- **High-Precision Software Resampler & Downmixer**:
  - Handles any hardware sampling rate (44.1 kHz, 48 kHz, 88.2 kHz, 96 kHz, 192 kHz) with continuous fractional-phase linear interpolation and zero click artifacts.
  - Handles mono, stereo, and multi-channel microphone arrays (averaging primary channels).
  - Handles 16-bit PCM, 24-bit PCM (packed 3-byte and 4-byte container), 32-bit PCM, and 32-bit IEEE Float formats.
- **Hardware & Bluetooth Headset Tolerance**:
  - Expanded handshake timeout to 8 seconds, ensuring Bluetooth headsets (AirPods, Sony WH-1000, Galaxy Buds) have adequate time to switch from A2DP to HFP/HSP voice profiles.
  - Smart endpoint fallback (`eConsole` → `eCommunications` → active endpoint enumeration) ensures audio capture works even when a headset is only designated for communications.
- **Smart Privacy Access Guidance**:
  - When Windows blocks microphone access (`E_ACCESSDENIED`), AI-ME automatically guides the user and launches `ms-settings:privacy-microphone` directly.

### 2. Windows Defender & SmartScreen Hardening
- **Authenticode Digital Signatures with Official Timestamps**:
  - Both `bin\AI-ME.exe` and `dist\AI-ME-Setup-v2.1.0.exe` are digitally signed with SHA-256 and verified against official DigiCert timestamp servers.
- **Embedded Application Manifest (`AI-ME.manifest`)**:
  - Explicit `<requestedExecutionLevel level="asInvoker" uiAccess="false" />` ensures UAC heuristics never trigger false elevation blocks.
  - Complete `<compatibility>` block for Windows 11, Windows 10, Windows 8.1, and Windows 7.
  - `PerMonitorV2` High-DPI and `longPathAware` support.
- **Complete PE Resource Version Metadata**:
  - Embedded `VERSIONINFO` in PE headers (Company Name, Product Name, File Description, Copyright, Version `2.1.0.0`).
- **Compiler Exploit Mitigations**:
  - Compiled with ASLR (`-Wl,--dynamicbase`), DEP/NX (`-Wl,--nxcompat`), and 64-bit High-Entropy VA (`-Wl,--high-entropy-va`).
- **Clean Installer Execution**:
  - Eliminated hidden `taskkill.exe` invocations during installation. Inno Setup uses native Windows Restart Manager and application mutexes (`AppMutex`).
- **1-Click Certificate Trust & Unblock Tools**:
  - `Trust-Certificate.bat`: 1-click script to install the publisher certificate into the Windows Certificate Store (`TrustedPublisher` and `Root`), completely clearing SmartScreen warnings.
  - `Unblock-App.bat`: 1-click script to strip Mark-of-the-Web (`Zone.Identifier`) from downloaded release archives.

---

## ✨ Key Features

- **Direct Injection into Any App**: Works anywhere your cursor can type via native `SendInput` and clipboard synchronization.
- **Multi-Provider AI Failover**:
  - **Speech-to-Text (STT)**: Groq Whisper Large v3 (ultra-fast transcription) & OpenAI Whisper-1.
  - **Large Language Models (LLM)**: Groq (Llama 3.3 70B & 3.1 8B), Google Gemini 2.0 Flash, OpenRouter, Mistral, and OpenAI.
  - **Automatic Failover & Self-Healing**: Automatically switches to healthy backup providers upon rate limits or temporary outages.
- **Context-Aware Style Engine**:
  - **Natural**: Clean, verbatim transcription with smart punctuation.
  - **Formal / Office**: Polished prose, structured paragraphs, and professional tone.
  - **Coding / Tech**: Converts spoken instructions directly into syntax-highlighted, bug-free source code.
  - **Academic**: Formats literature reviews, citations, and formal research language.
  - **Automate / Command**: Executes actions, summaries, and transformations on highlighted text.
- **Per-Application Automatic Style Switching**: Automatically selects your preferred dictation style based on the active foreground window.
- **Smart Filler Removal**: Strips hesitation sounds across Indonesian, English, Portuguese, Spanish, French, and German.
- **Custom User Dictionary**: Ensures proper spelling of names, brands, technical acronyms, and jargon.
- **Windows 11 Fluid UI**:
  - Direct2D hardware-accelerated floating HUD bar.
  - Acrylic blur, subtle glow, and customizable neon accent colors.
  - Dark mode synchronization with Windows system settings.
- **Enterprise-Grade Privacy**:
  - Audio is streamed directly and securely via TLS 1.3 to your chosen AI provider.
  - Keys encrypted locally with **Windows DPAPI** (`CryptProtectData`).
  - No telemetries, no third-party tracking, no audio recorded to disk.

---

## ⌨️ Default Keyboard Shortcuts

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `Ctrl + Shift + Space` | **Dictate (Push-to-Talk / Toggle)** | Speak and let AI transcribe & polish your text in real time. |
| `Ctrl + Alt + O` | **Settings & Providers** | Open configuration, manage API keys, audio devices & styles. |
| `Ctrl + Alt + A` | **AI Command & Automation** | Transform selected text with custom automated prompts. |
| `Escape` | **Cancel Dictation** | Instantly discard current recording without pasting. |

*Shortcuts can be fully customized in Settings > Shortcuts.*

---

## 🚀 Getting Started

### Installation via Installer
1. Download `AI-ME-Setup-v2.1.0.exe` from the [Releases](https://github.com/RobsHs/AI-ME/releases) page.
2. Run the installer (no Administrator privileges required).
3. The setup automatically configures your Start Menu and creates a startup task if selected.

> [!TIP]
> If Windows SmartScreen shows a prompt on a newly formatted device, simply run `Trust-Certificate.bat` once or click **"More info" -> "Run anyway"**. Running `Trust-Certificate.bat` permanently registers the certificate in your Windows Trusted Publisher store.

### Portable Version
1. Download `AI-ME-v2.1.0-Portable.zip`.
2. Extract anywhere on your system.
3. Run `Unblock-App.bat` (optional, strips download zone flags) and launch `AI-ME.exe`.

### Building from Source

**Prerequisites:**
- Windows 10 (Version 1809+) or Windows 11
- MinGW-w64 with Clang++ (C++23 support)
- Inno Setup 6 (optional, for building the installer)

```cmd
git clone https://github.com/RobsHs/AI-ME.git
cd AI-ME
build.bat
```

The build script compiles resources with modern manifests, builds `bin\AI-ME.exe` with ASLR/DEP hardening, signs the binary with Authenticode and DigiCert timestamping, compiles `dist\AI-ME-Setup-v2.1.0.exe`, and packages `dist\AI-ME-v2.1.0-Portable.zip`.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 👤 Author

Developed with ❤️ by **Freda Giovani** ([@robshs](https://github.com/robshs)).  
Repository: [https://github.com/RobsHs/AI-ME](https://github.com/RobsHs/AI-ME)
