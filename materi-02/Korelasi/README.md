# Korelasi dalam Analisis Data
> Memahami hubungan antar variabel menggunakan metode statistik dan visualisasi

---
```
Korelasi/
├── README.md                  # Dokumentasi materi 
├── korelasi.Rmd               # Notebook R Markdown utama
├── clean_data.csv             # Dataset yang digunakan
└── korelasi.html              # Hasil knit Rmd
 
```
---

## Deskripsi

Korelasi adalah ukuran statistik yang menggambarkan sejauh mana dua variabel bergerak bersama. Analisis korelasi digunakan untuk mengidentifikasi hubungan antar fitur dalam dataset, yang merupakan langkah penting sebelum membangun model machine learning.

---

## Materi

### 1. Apa itu Korelasi?

Korelasi mengukur **kekuatan** dan **arah** hubungan linear antara dua variabel numerik. Nilainya berkisar antara **-1** hingga **+1**.

| Nilai | Interpretasi |
|-------|-------------|
| `+1`  | Korelasi positif sempurna |
| `0.7` s/d `0.9` | Korelasi positif kuat |
| `0.4` s/d `0.6` | Korelasi positif sedang |
| `0.1` s/d `0.3` | Korelasi positif lemah |
| `0`   | Tidak ada korelasi |
| `-0.1` s/d `-0.3` | Korelasi negatif lemah |
| `-1`  | Korelasi negatif sempurna |

---

### 2. Jenis-Jenis Korelasi

#### Pearson Correlation
Mengukur hubungan **linear** antara dua variabel kontinu.

$$r = \frac{\sum_{i=1}^{n}(x_i - \bar{x})(y_i - \bar{y})}{\sqrt{\sum_{i=1}^{n}(x_i - \bar{x})^2 \cdot \sum_{i=1}^{n}(y_i - \bar{y})^2}}$$

**Asumsi:**
- Data berdistribusi **normal**
- Hubungan antar variabel bersifat **linear**
- Tidak ada **outlier** ekstrem

---

#### Spearman Correlation
Mengukur hubungan **monoton** berbasis **peringkat (rank)**, bukan nilai asli.

$$\rho = 1 - \frac{6 \sum d_i^2}{n(n^2 - 1)}$$

Di mana $d_i$ adalah selisih rank antara pasangan ke-$i$, dan $n$ adalah jumlah observasi.

**Digunakan saat:**
- Data berskala **ordinal**
- Data **tidak berdistribusi normal**
- Terdapat **outlier** dalam data

---

#### Kendall Tau
Mengukur **konsistensi urutan** (concordance) antara dua variabel.

$$\tau = \frac{C - D}{\frac{1}{2}n(n-1)}$$

Di mana:
- $C$ = jumlah pasangan **concordant** (urutan pasangan sama)
- $D$ = jumlah pasangan **discordant** (urutan pasangan berbeda)

**Kapan digunakan:**
- Dataset **kecil**
- Data mengandung banyak nilai sama (*ties*)
- Ingin hasil yang lebih **konservatif** dari Spearman

---

### 3. Kapan Menggunakan Masing-Masing?

```
Data kontinu, distribusi normal   →  Pearson
Data ordinal / ada outlier        →  Spearman
Dataset kecil, data ordinal       →  Kendall
```

---
### 4. Uji Signifikansi

Setiap nilai korelasi perlu diuji apakah **signifikan secara statistik**:

- **H₀**: tidak ada korelasi (r = 0)
- **H₁**: ada korelasi (r ≠ 0)
- Jika **p-value < 0.05** → korelasi signifikan ✅
- Jika **p-value ≥ 0.05** → korelasi tidak signifikan ❌

---

---
## Implementasi R

### Library yang Digunakan

| Library | Fungsi |
|---|---|
| `tidyverse` | Manipulasi dan visualisasi data |
| `corrplot` | Heatmap korelasi interaktif |
| `ggcorrplot` | Heatmap korelasi berbasis ggplot2 |
| `psych` | `pairs.panels()` untuk scatter plot matrix |

### Cara Menjalankan

```r
# Install library jika belum ada
install.packages(c("tidyverse", "corrplot", "ggcorrplot", "psych"))

# Buka file Rmd di RStudio, lalu klik "Knit"
# atau jalankan per chunk secara interaktif
```

### Ringkasan Isi Notebook

| Bagian | Deskripsi |
|---|---|
| Load Data | Membaca `clean_data.csv` dan eksplorasi awal |
| Pearson | Hitung korelasi + uji signifikansi |
| Spearman | Hitung korelasi berbasis rank |
| Kendall | Hitung tau dan interpretasi |
| Perbandingan | Tabel perbandingan ketiga metode |
| Visualisasi | Heatmap, scatter plot, pairs panel |
| Uji Normalitas | Shapiro-Wilk test sebagai syarat Pearson |
| Kesimpulan | Ringkasan korelasi tiap variabel dengan salary |

---


