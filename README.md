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
  <img src="https://img.shields.io/badge/Audio-Low--Latency%20WASAPI-green" alt="WASAPI" />
  <img src="https://img.shields.io/badge/Version-v2.0.0-blue" alt="Version 2.0.0" />
  <img src="https://img.shields.io/badge/License-MIT-brightgreen" alt="License: MIT" />
</p>

---

## 🌟 Overview

**AI-ME** is a native, ultra-lightweight Windows desktop assistant written in modern **C++23** with **zero external runtime dependencies**. It bridges real-time voice recording with state-of-the-art AI speech and language models, automatically transcribing, punctuating, and formatting your spoken words directly into any application—whether you are writing code in VS Code, composing documents in Microsoft Word, replying to emails in Outlook, or chatting on Discord.

Designed with an obsession for speed and elegance, AI-ME uses **hardware-accelerated Direct2D / DirectWrite**, **Windows 11 Acrylic blur & Mica effects**, and **low-latency WASAPI audio capture**.

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
- **Smart Filler Removal**: Strips hesitation sounds (*um, uh, dsb*) across Indonesian, English, Portuguese, Spanish, French, and German.
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

## 🛠️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                       AI-ME Native Client                       │
├──────────────────┬─────────────────────────────┬────────────────┤
│   WASAPI Capture │   Direct2D / DirectWrite    │ WinHTTP Client │
│  (Low Latency)   │    (Hardware Accelerated)   │   (TLS 1.3)    │
└────────┬─────────┴──────────────┬──────────────┴────────┬───────┘
         │                        │                       │
         ▼                        ▼                       ▼
   16kHz Resampler        Windows 11 Acrylic         Speech / LLM
   Audio Ring Buffer     Floating HUD Overlay       Provider Engine
                                                          │
                    ┌─────────────────────────────────────┴──────────┐
                    ▼                     ▼                          ▼
               Groq Whisper          Google Gemini              OpenRouter /
             (Llama 3.3 70B)       (Gemini 2.0 Flash)          Mistral / OpenAI
```

---

## 🚀 Getting Started

### Installation via Installer
1. Download `AI-ME-Setup-v2.0.0.exe` from the [Releases](https://github.com/RobsHs/AI-ME/releases) page.
2. Run the installer (no Administrator privileges required).
3. The setup automatically configures your Start Menu and creates a startup task if selected.

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

The compiled binary will be placed at `bin\AI-ME.exe` with static runtime linkage and embedded icon resources.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 👤 Author

Developed with ❤️ by **Freda Giovani** ([@robshs](https://github.com/robshs)).
Repository: [https://github.com/RobsHs/AI-ME](https://github.com/RobsHs/AI-ME)
