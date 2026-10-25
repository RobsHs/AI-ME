# AI-ME - Standalone Windows Desktop Edition & Microsoft Store Setup

Dokumentasi ini menjelaskan bagaimana proyek **AI-ME** telah dikonversi dari Windhawk Mod menjadi **Aplikasi Desktop Windows Standalone murni (`.exe`)** dan bagaimana cara mengemasnya menjadi installer ala **Microsoft Store (`.msix` / Setup)**.

---

## 1. Apa yang Telah Dilakukan?

1. **De-Windhawk (Konversi ke Standalone Native C++)**:
   * Menghilangkan ketergantungan pada injector Windhawk.
   * Fungsi penyimpanan config/API key dialihkan ke **Windows Registry Standar** (`HKCU\Software\AI-ME`).
   * Mengganti entry point Windhawk menjadi `wWinMain` standar dengan sistem **Single Instance Mutex** (mencegah app terbuka ganda).
   * Menambahkan menu **Exit AI-ME** pada System Tray agar pengguna dapat menutup aplikasi dengan mudah.
2. **Kompilasi Sukses**:
   * Dihasilkan biner: `bin\AI-ME.exe` (~1.9 MB).
   * **Nol dependensi eksternal**: Hanya menggunakan API bawaan Windows 10/11 (Direct2D, DWrite, WinHTTP, WASAPI, Crypt32).
3. **Persiapan Paket Microsoft Store (MSIX)**:
   * Dibuat folder `package/` berisi `AppxManifest.xml` (FullTrust desktop bridge).
   * Aset ikon Store dibuat lengkap di `package/Assets/` (Square44x44, Square150x150, StoreLogo, Wide310x150, SplashScreen).
4. **Persiapan Installer Mandiri (Inno Setup)**:
   * Dibuat script `installer.iss` untuk menghasilkan `AI-ME-Setup-v2.0.0.exe` (bisa diinstal tanpa hak admin, otomatis buat shortcut Start Menu & startup Windows).

---

## 2. Cara Menjalankan Aplikasi Sekarang

Anda bisa langsung menjalankan aplikasinya tanpa perlu instalasi apa pun:
1. Buka folder `bin\`.
2. Klik ganda **`AI-ME.exe`**.
3. Ikon AI-ME akan muncul di System Tray (dekat jam di pojok kanan bawah taskbar).
4. Tekan shortcut default:
   * **`Ctrl + Alt + O`**: Membuka jendela Settings / Konfigurasi Provider AI (Groq, OpenAI, Gemini, dll.).
   * **`Ctrl + Shift + Space`**: Mulai Dikte Suara (Voice Typing) di aplikasi apa pun.
   * **`Ctrl + Alt + A`**: AI Automation & Code Generation.

---

## 3. Cara Membuat Installer

### Opsi A: Installer Standar `.exe` (Inno Setup) - Paling Praktis
Jika ingin membagikan aplikasi ke teman atau pengguna umum langsung:
1. Install [Inno Setup](https://jrsoftware.org/isdl.php) (atau jalankan `winget install JRSoftware.InnoSetup`).
2. Klik kanan file `installer.iss` > pilih **Compile**.
3. Installer `AI-ME-Setup-v2.0.0.exe` akan dibuat di folder `dist\`.
4. Pengguna cukup klik installer tersebut, pilih opsi *"Run at Startup"*, dan aplikasi langsung terpasang rapi di Start Menu.

---

### Opsi B: Format Modern MSIX (Ala Microsoft Store)
Folder `package/` sudah siap dijadikan paket `.msix`:
1. Buka **MSIX Packaging Tool** (bisa didownload gratis dari Microsoft Store).
2. Pilih **Package editor** atau buat paket baru dari folder `package/`.
3. Outputnya berupa file `.msix` yang ketika diklik akan menampilkan jendela **Windows App Installer** modern khas Microsoft Store.

---

## 4. Cara Publish ke Microsoft Store Resmi

Jika Anda ingin aplikasi ini resmi tersedia dan bisa dicari di aplikasi Microsoft Store:

1. **Daftar Akun Developer**:
   * Buka [partner.microsoft.com/dashboard](https://partner.microsoft.com/dashboard).
   * Daftar akun Windows Developer (biaya pendaftaran individu sekitar $19 sekali seumur hidup, tanpa biaya tahunan).
2. **Reservasi Nama Aplikasi**:
   * Di dashboard Partner Center, klik **Create a new app** dan masukkan nama (misal: `AI-ME Voice Typing`).
3. **Upload Paket**:
   * Anda bisa mengupload file `.msix` dari langkah sebelumnya.
   * *(Catatan: Sejak 2021, Microsoft Store juga mengizinkan upload langsung file `.exe` / installer tradisional).*
4. **Isi Informasi Store Listing**:
   * Deskripsi fitur, screenshot tampilan (overlay bar, settings window).
   * Pilih kategori: *Productivity* / *Developer Tools*.
   * Masukkan Privacy Policy.
5. **Submit untuk Sertifikasi**:
   * Tim Microsoft akan memverifikasi aplikasi (biasanya 24–48 jam).
   * Setelah lolos, aplikasi Anda resmi tayang di Microsoft Store dan bisa diinstall oleh siapa saja di seluruh dunia langsung dari aplikasi Microsoft Store Windows!

---

## 5. File Proyek

* `bin\AI-ME.exe` - File aplikasi desktop mandiri siap pakai.
* `src\AI-ME.cpp` - Source code C++ standalone.
* `build.bat` - Script untuk mengompilasi ulang aplikasi sewaktu-waktu.
* `package\AppxManifest.xml` - Manifest untuk Microsoft Store / MSIX.
* `package\Assets\` - Ikon dan gambar tile Store.
* `installer.iss` - Script pembuatan installer Inno Setup.
* `generate_standalone.py` - Script sinkronisasi dari mod Windhawk.
