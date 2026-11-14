import os
import sys
import subprocess
import urllib.request
import urllib.error
import json
import mimetypes

def get_github_token():
    p = subprocess.Popen(['git', 'credential', 'fill'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    out, err = p.communicate(input='protocol=https\nhost=github.com\n\n')
    for line in out.splitlines():
        if line.startswith('password='):
            return line.split('=', 1)[1].strip()
    return None

def main():
    token = get_github_token()
    if not token:
        print("[ERROR] Could not retrieve GitHub token from git credentials.")
        sys.exit(1)

    owner = "RobsHs"
    repo = "AI-ME"
    tag = "v2.1.0"
    title = "AI-ME v2.1.0 - Universal Audio Engine & Windows Security Hardening"
    body = """## 🌟 AI-ME v2.1.0 - Universal Device Compatibility & Security Update

Major update addressing Windows Defender / SmartScreen blocks across devices and adding 100% microphone hardware support.

---

### 🛡️ Windows Defender & SmartScreen Fixes
- **Authenticode Digital Signatures**: All executables and installers are signed with SHA-256 and official DigiCert timestamps.
- **Embedded Manifest**: Native `<requestedExecutionLevel level="asInvoker" uiAccess="false" />`, compatibility GUIDs (Windows 11, 10, 8.1, 7), and PerMonitorV2 DPI awareness.
- **PE VERSIONINFO**: Full publisher and product version metadata embedded.
- **Exploit Guard Mitigations**: Compiled with ASLR (`--dynamicbase`), DEP/NX (`--nxcompat`), and 64-bit High-Entropy VA (`--high-entropy-va`).
- **Clean Installer**: Removed command-line `taskkill` hooks in Inno Setup; switched to native Windows Restart Manager and application mutexes.
- **Trust Tools**: Includes `Trust-Certificate.bat` (1-click certificate trust in Windows store) and `Unblock-App.bat` (strips Mark-of-the-Web zone flags).

---

### 🎙️ Universal Audio & Voice Fixes
- **4-Tier WASAPI Engine**: Automatic fallback from 16 kHz Float autoconvert to Native Mix Format (`GetMixFormat`) in either event-driven or timer-polling (15 ms) modes.
- **Built-in Resampler & Downmixer**: Handles any input sample rate (44.1k, 48k, 88.2k, 96k, 192k) with fractional linear interpolation and downmixes multi-channel arrays to clean mono.
- **Bluetooth Tolerance**: Handshake timeout increased to 8 seconds for Bluetooth headsets (AirPods, Galaxy Buds, Sony WH-1000) switching between A2DP and HFP voice profiles.
- **Smart Privacy Guidance**: Direct detection of `E_ACCESSDENIED` with automatic launch of Windows Microphone Settings (`ms-settings:privacy-microphone`).

---

### 📦 Downloads
- **Setup Installer**: `AI-ME-Setup-v2.1.0.exe` (Recommended)
- **Portable Edition**: `AI-ME-v2.1.0-Portable.zip` (Extract & Run)
- **Certificate**: `AI-ME-Certificate.cer` (Optional manual trust)
"""

    headers = {
        'Authorization': f'Bearer {token}',
        'Accept': 'application/vnd.github+json',
        'User-Agent': 'AI-ME-Publisher'
    }

    print(f"[*] Checking existing releases for {owner}/{repo}...")
    req = urllib.request.Request(f'https://api.github.com/repos/{owner}/{repo}/releases', headers=headers)
    releases = []
    try:
        with urllib.request.urlopen(req) as resp:
            releases = json.loads(resp.read().decode())
    except urllib.error.HTTPError as e:
        print(f"[!] Failed to list releases: {e.code} {e.read().decode()}")
        sys.exit(1)

    release = None
    for r in releases:
        if r.get('tag_name') == tag:
            release = r
            print(f"[*] Found existing release for tag {tag}: ID {release['id']}")
            break

    if not release:
        print(f"[*] Creating new GitHub release for {tag}...")
        payload = {
            'tag_name': tag,
            'target_commitish': 'main',
            'name': title,
            'body': body,
            'draft': False,
            'prerelease': False
        }
        create_req = urllib.request.Request(
            f'https://api.github.com/repos/{owner}/{repo}/releases',
            headers=headers,
            data=json.dumps(payload).encode('utf-8')
        )
        try:
            with urllib.request.urlopen(create_req) as resp:
                release = json.loads(resp.read().decode())
                print(f"[SUCCESS] Created release! ID: {release['id']}")
        except urllib.error.HTTPError as e:
            print(f"[ERROR] Failed to create release: {e.code} {e.read().decode()}")
            sys.exit(1)

    upload_url_template = release['upload_url']
    upload_base = upload_url_template.split('{')[0]

    files_to_upload = [
        ('dist/AI-ME-Setup-v2.1.0.exe', 'application/vnd.microsoft.portable-executable'),
        ('dist/AI-ME-v2.1.0-Portable.zip', 'application/zip'),
        ('AI-ME-Certificate.cer', 'application/x-x509-ca-cert')
    ]

    # Check existing assets
    existing_assets = {a['name']: a['id'] for a in release.get('assets', [])}

    for file_path, content_type in files_to_upload:
        if not os.path.exists(file_path):
            print(f"[!] File not found: {file_path}, skipping.")
            continue

        file_name = os.path.basename(file_path)
        if file_name in existing_assets:
            print(f"[*] Asset {file_name} already exists (ID: {existing_assets[file_name]}), deleting old one...")
            del_req = urllib.request.Request(
                f"https://api.github.com/repos/{owner}/{repo}/releases/assets/{existing_assets[file_name]}",
                headers=headers,
                method='DELETE'
            )
            try:
                with urllib.request.urlopen(del_req) as resp:
                    print(f"[OK] Deleted old asset {file_name}")
            except urllib.error.HTTPError as e:
                print(f"[WARNING] Could not delete old asset: {e.code}")

        file_size = os.path.getsize(file_path)
        print(f"[*] Uploading {file_name} ({file_size / (1024*1024):.2f} MB)...")

        with open(file_path, 'rb') as f:
            file_data = f.read()

        upload_req = urllib.request.Request(
            f"{upload_base}?name={file_name}",
            data=file_data,
            headers={
                'Authorization': f'Bearer {token}',
                'Content-Type': content_type,
                'User-Agent': 'AI-ME-Publisher'
            }
        )

        try:
            with urllib.request.urlopen(upload_req) as resp:
                asset_resp = json.loads(resp.read().decode())
                print(f"[SUCCESS] Uploaded {file_name}! (Download URL: {asset_resp.get('browser_download_url')})")
        except urllib.error.HTTPError as e:
            print(f"[ERROR] Failed to upload {file_name}: {e.code} {e.read().decode()}")

    print("\n=======================================================")
    print(f"[DONE] Release published at: {release.get('html_url')}")
    print("=======================================================")

if __name__ == '__main__':
    main()
