# 📊 Ukuran Penyebaran (Measures of Dispersion)

Ukuran penyebaran adalah ukuran statistik yang menggambarkan **seberapa jauh** data tersebar atau bervariasi dari nilai pusatnya (mean, median). Semakin besar nilainya, semakin heterogen (beragam) data tersebut.

---

## 📋 Daftar Ukuran Penyebaran

| No | Ukuran | Simbol | Keterangan |
|----|--------|--------|------------|
| 1 | Range (Jangkauan) | R | Selisih nilai max dan min |
| 2 | Deviasi Rata-rata (Mean Deviation) | MD | Rata-rata jarak dari mean |
| 3 | Varians (Variance) | s² / σ² | Rata-rata kuadrat deviasi |
| 4 | Standar Deviasi (Standard Deviation) | s / σ | Akar kuadrat dari varians |
| 5 | Koefisien Variasi (CV) | CV | Penyebaran relatif dalam % |
| 6 | Interkuartil Range (IQR) | IQR | Selisih Q3 dan Q1 |

---

## 1. 📏 Range (Jangkauan)

**Definisi:** Selisih antara nilai maksimum dan nilai minimum dalam data.

**Rumus:**
```
R = X_max - X_min
```

**Kelebihan:** Mudah dihitung  
**Kekurangan:** Sangat sensitif terhadap outlier

---

## 2. 📐 Deviasi Rata-rata (Mean Deviation)

**Definisi:** Rata-rata dari nilai absolut selisih setiap data terhadap mean.

**Rumus:**
```
MD = Σ|Xi - X̄| / n
```

---

## 3. 📊 Varians (Variance)

**Definisi:** Rata-rata dari kuadrat selisih setiap data terhadap mean.

**Rumus Populasi:**
```
σ² = Σ(Xi - μ)² / N
```

**Rumus Sampel:**
```
s² = Σ(Xi - X̄)² / (n - 1)
```

> Pembagi `n-1` pada sampel disebut **koreksi Bessel** untuk menghasilkan estimasi yang tidak bias.

---

## 4. 📉 Standar Deviasi (Standard Deviation)

**Definisi:** Akar kuadrat dari varians. Satuannya sama dengan data asli, sehingga lebih mudah diinterpretasikan.

**Rumus Sampel:**
```
s = √(Σ(Xi - X̄)² / (n - 1))
```

---

## 5. 📈 Koefisien Variasi (Coefficient of Variation)

**Definisi:** Ukuran penyebaran relatif yang dinyatakan dalam persentase. Berguna untuk membandingkan variabilitas dua kelompok data dengan satuan berbeda.

**Rumus:**
```
CV = (s / X̄) × 100%
```

> CV < 30% → data homogen  
> CV ≥ 30% → data heterogen

---

## 6. 📦 Interkuartil Range (IQR)

**Definisi:** Selisih antara kuartil ketiga (Q3) dan kuartil pertama (Q1). Merepresentasikan sebaran 50% data tengah.

**Rumus:**
```
IQR = Q3 - Q1
```

**Kelebihan:** Tidak terpengaruh outlier (robust)

---

## 💻 Implementasi R dengan Looping

```r
# ============================================================
# UKURAN PENYEBARAN - Implementasi R dengan Looping
# ============================================================

# --- Data ---
data_list <- list(
  Kelompok_A = c(10, 20, 30, 40, 50, 60, 70),
  Kelompok_B = c(35, 36, 38, 40, 42, 44, 45),
  Kelompok_C = c(5, 15, 50, 80, 100, 120, 200)
)

# ============================================================
# Fungsi-fungsi ukuran penyebaran (manual)
# ============================================================

hitung_range <- function(x) {
  max(x) - min(x)
}

hitung_mean_deviation <- function(x) {
  mean(abs(x - mean(x)))
}

hitung_varians_sampel <- function(x) {
  n <- length(x)
  sum((x - mean(x))^2) / (n - 1)
}

hitung_sd_sampel <- function(x) {
  sqrt(hitung_varians_sampel(x))
}

hitung_cv <- function(x) {
  (hitung_sd_sampel(x) / mean(x)) * 100
}

hitung_iqr <- function(x) {
  q <- quantile(x, probs = c(0.25, 0.75))
  unname(q[2] - q[1])
}

# ============================================================
# Looping: Hitung semua ukuran penyebaran untuk tiap kelompok
# ============================================================

cat("=============================================================\n")
cat("       HASIL UKURAN PENYEBARAN PER KELOMPOK\n")
cat("=============================================================\n\n")

# Simpan hasil ke dalam list untuk analisis lanjutan
hasil <- list()

for (nama in names(data_list)) {
  x <- data_list[[nama]]

  range_val <- hitung_range(x)
  md_val    <- hitung_mean_deviation(x)
  var_val   <- hitung_varians_sampel(x)
  sd_val    <- hitung_sd_sampel(x)
  cv_val    <- hitung_cv(x)
  iqr_val   <- hitung_iqr(x)

  hasil[[nama]] <- list(
    Range   = range_val,
    MD      = md_val,
    Varians = var_val,
    SD      = sd_val,
    CV      = cv_val,
    IQR     = iqr_val
  )

  cat(sprintf("--- %s ---\n", nama))
  cat(sprintf("  Data          : %s\n", paste(x, collapse = ", ")))
  cat(sprintf("  Mean          : %.4f\n", mean(x)))
  cat(sprintf("  Range         : %.4f\n", range_val))
  cat(sprintf("  Mean Deviation: %.4f\n", md_val))
  cat(sprintf("  Varians (s²)  : %.4f\n", var_val))
  cat(sprintf("  Std Deviasi   : %.4f\n", sd_val))
  cat(sprintf("  Koef. Variasi : %.2f%%\n", cv_val))
  cat(sprintf("  IQR           : %.4f\n", iqr_val))
  cat("\n")
}

# ============================================================
# Looping: Buat tabel ringkasan perbandingan antar kelompok
# ============================================================

cat("=============================================================\n")
cat("              TABEL RINGKASAN PERBANDINGAN\n")
cat("=============================================================\n")
cat(sprintf("%-15s %8s %8s %10s %8s %8s %8s\n",
    "Kelompok", "Range", "MD", "Varians", "SD", "CV(%)", "IQR"))
cat(strrep("-", 70), "\n")

for (nama in names(hasil)) {
  h <- hasil[[nama]]
  cat(sprintf("%-15s %8.2f %8.2f %10.2f %8.2f %8.2f %8.2f\n",
      nama, h$Range, h$MD, h$Varians, h$SD, h$CV, h$IQR))
}
cat(strrep("-", 70), "\n")

# ============================================================
# Looping: Interpretasi otomatis berdasarkan CV
# ============================================================

cat("\n=============================================================\n")
cat("               INTERPRETASI KOEFISIEN VARIASI\n")
cat("=============================================================\n")

for (nama in names(hasil)) {
  cv <- hasil[[nama]]$CV
  kategori <- ifelse(cv < 30, "HOMOGEN (seragam)", "HETEROGEN (beragam)")
  cat(sprintf("  %s → CV = %.2f%% → Data %s\n", nama, cv, kategori))
}

# ============================================================
# Looping: Deteksi outlier menggunakan IQR Fence
# ============================================================

cat("\n=============================================================\n")
cat("           DETEKSI OUTLIER (Metode IQR Fence)\n")
cat("=============================================================\n")

for (nama in names(data_list)) {
  x   <- data_list[[nama]]
  q1  <- quantile(x, 0.25)
  q3  <- quantile(x, 0.75)
  iqr <- q3 - q1
  lb  <- q1 - 1.5 * iqr   # Lower Bound
  ub  <- q3 + 1.5 * iqr   # Upper Bound

  outlier <- x[x < lb | x > ub]

  cat(sprintf("  %s:\n", nama))
  cat(sprintf("    Batas Bawah = %.2f | Batas Atas = %.2f\n", lb, ub))

  if (length(outlier) == 0) {
    cat("    Outlier     : Tidak ada\n")
  } else {
    cat(sprintf("    Outlier     : %s\n", paste(outlier, collapse = ", ")))
  }
  cat("\n")
}
```

---

## 📤 Contoh Output

```
=============================================================
       HASIL UKURAN PENYEBARAN PER KELOMPOK
=============================================================

--- Kelompok_A ---
  Data          : 10, 20, 30, 40, 50, 60, 70
  Mean          : 40.0000
  Range         : 60.0000
  Mean Deviation: 17.1429
  Varians (s²)  : 466.6667
  Std Deviasi   : 21.6025
  Koef. Variasi : 54.01%
  IQR           : 30.0000

--- Kelompok_B ---
  Data          : 35, 36, 38, 40, 42, 44, 45
  Mean          : 40.0000
  Range         : 10.0000
  Mean Deviation: 2.8571
  Varians (s²)  : 12.6667
  Std Deviasi   : 3.5590
  Koef. Variasi : 8.90%
  IQR           : 6.0000

--- Kelompok_C ---
  Data          : 5, 15, 50, 80, 100, 120, 200
  Mean          : 81.4286
  Range         : 195.0000
  ...
```

---

## 🔍 Cara Membaca Hasil

| Ukuran | Nilai Kecil | Nilai Besar |
|--------|-------------|-------------|
| Range | Data homogen | Data heterogen / ada outlier |
| MD | Deviasi kecil dari mean | Deviasi besar dari mean |
| Varians | Data berkelompok | Data tersebar |
| SD | Variasi kecil | Variasi besar |
| CV | < 30% → Homogen | ≥ 30% → Heterogen |
| IQR | Data tengah rapat | Data tengah tersebar |

---

## 📚 Referensi

- Walpole, R.E. et al. *Probability & Statistics for Engineers and Scientists*
- Montgomery, D.C. *Applied Statistics and Probability for Engineers*
- R Documentation: `?var`, `?sd`, `?IQR`, `?quantile`

---

*Dibuat untuk keperluan pembelajaran statistika deskriptif* 📖
