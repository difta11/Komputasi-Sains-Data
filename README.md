# 🚀 Tutorial GitHUB R - Komputasi Sains Data Kelompok 2

Panduan lengkap untuk menghubungkan R/RStudio dengan GitHub dan mengelola kode menggunakan Git.

---

## 📋 Persiapan Awal

Sebelum mulai, pastikan kamu sudah menyiapkan hal-hal berikut:

### 1. 🧑‍💻 Buat Akun GitHub
Daftar akun di [https://github.com](https://github.com) jika belum punya.

### 2. 📦 Update R + Install RStudio
- Download R terbaru dari [https://cran.r-project.org](https://cran.r-project.org)
- Download RStudio dari [https://posit.co/downloads](https://posit.co/downloads)
- Pastikan R dan RStudio sudah diperbarui ke versi terbaru

### 3. 🔧 Install & Setup Git
Ikuti panduan lengkap di **Chapter 6** dokumentasi ini.

Atau secara singkat:
- **Windows**: Download Git dari [https://git-scm.com](https://git-scm.com)
- **Mac**: Jalankan `git --version` di Terminal, ikuti instruksi instalasi
- **Linux**: `sudo apt install git`

Setelah install, konfigurasikan identitas Git kamu:
```bash
git config --global user.name "Nama Kamu"
git config --global user.email "email@kamu.com"
```

### 4. 🔑 Buat Token (Personal Access Token)
1. Login ke GitHub
2. Pergi ke **[Settings di GitHub](https://github.com/settings/tokens)**
3. Klik **Developer settings** → **Personal access tokens** → **Tokens (classic)**
4. Klik **Generate new token**
5. Beri nama token, pilih scope `repo`, lalu klik **Generate token**
6. **Salin token** dan simpan di tempat aman (tidak bisa dilihat lagi!)

### 5. 🔗 Connect R ke GitHub
Di dalam RStudio, jalankan perintah berikut:

```r
# Install package usethis jika belum ada
install.packages("usethis")
install.packages("gitcreds")

library(usethis)
library(gitcreds)

# Simpan token GitHub ke dalam credential store
gitcreds_set()
# Paste token kamu saat diminta
```

---

## 🔄 Workflow: Update Code ke GitHub

### Langkah 1 — Clone atau Buat Repo Baru

**Clone repo yang sudah ada:**
```r
usethis::create_from_github(
  "https://github.com/username/nama-repo",
  destdir = "~/Documents/"
)
```

**Buat repo baru dari RStudio:**
```r
usethis::use_git()       # Inisialisasi Git di project lokal
usethis::use_github()    # Push project ke GitHub
```

### Langkah 2 — Edit File di RStudio

Lakukan perubahan pada file `.R`, `.Rmd`, atau file lainnya seperti biasa.

### Langkah 3 — Stage, Commit, dan Push

Menggunakan **Git pane** di RStudio (kanan atas):
1. Centang file yang ingin di-commit (Stage)
2. Klik **Commit**, tulis pesan commit yang jelas
3. Klik **Push** untuk mengirim ke GitHub

Atau menggunakan terminal:
```bash
git add .
git commit -m "Pesan commit yang deskriptif"
git push origin main
```

### Langkah 4 — Pull Perubahan dari GitHub

Jika ada perubahan dari kolaborator atau dari device lain:
```bash
git pull origin main
```

Di RStudio: klik tombol **Pull** di Git pane.

---

## 💡 Tips & Troubleshooting

| Masalah | Solusi |
|--------|--------|
| Token expired | Buat token baru di GitHub Settings dan jalankan `gitcreds_set()` lagi |
| Push ditolak | Lakukan `git pull` terlebih dahulu sebelum push |
| Konflik merge | Edit file yang konflik, hapus marker `<<<`, lalu commit ulang |
| Git tidak terdeteksi di RStudio | Cek path Git di **Tools → Global Options → Git/SVN** |

---

## 📚 Referensi

- [Happy Git with R](https://happygitwithr.com) — panduan paling lengkap untuk Git + R
- [GitHub Docs](https://docs.github.com)
- [Posit / RStudio Docs](https://docs.posit.co)

---

> 💬 Ada pertanyaan? Buka *Issue* di repo ini atau hubungi instructor.