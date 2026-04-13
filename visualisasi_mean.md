# 📊 Visualisasi Mean (Rata-rata) dalam R

Dokumen ini menjelaskan cara membuat visualisasi sederhana untuk memahami posisi **mean** dalam sebuah data menggunakan R base graphics.

---

## 📦 Data yang Digunakan

```r
data <- c(1, 3, 7, -2, 6, -5, 4)
rata <- mean(data)   # 2
```

---

## 1. 🔵 Dotplot + Garis Mean

Menampilkan setiap titik data dan menandai posisi mean dengan garis merah putus-putus.

```r
stripchart(data,
           method = "stack",
           pch    = 19,
           col    = "steelblue",
           main   = "Dotplot Data dengan Garis Mean",
           xlab   = "Nilai")
abline(v = rata, col = "red", lwd = 2, lty = 2)
legend("topright", legend = paste("Mean =", rata),
       col = "red", lwd = 2, lty = 2)
```

**Kapan digunakan:** Data sedikit, ingin melihat posisi tiap nilai terhadap mean.

---

## 2. 📊 Barplot + Garis Mean

Menampilkan nilai tiap observasi dalam bentuk batang, dengan garis horizontal di posisi mean.

```r
barplot(data,
        names.arg = paste("x", 1:length(data), sep = ""),
        col       = "steelblue",
        main      = "Barplot Data dengan Garis Mean",
        xlab      = "Observasi",
        ylab      = "Nilai")
abline(h = rata, col = "red", lwd = 2, lty = 2)
legend("topright", legend = paste("Mean =", rata),
       col = "red", lwd = 2, lty = 2)
```

**Kapan digunakan:** Ingin membandingkan nilai tiap observasi terhadap rata-rata.

---

## 3. 📉 Histogram + Garis Mean

Menampilkan distribusi frekuensi data dengan garis vertikal di posisi mean.

```r
hist(data,
     col    = "steelblue",
     border = "white",
     main   = "Histogram Data dengan Garis Mean",
     xlab   = "Nilai",
     ylab   = "Frekuensi")
abline(v = rata, col = "red", lwd = 2, lty = 2)
legend("topright", legend = paste("Mean =", rata),
       col = "red", lwd = 2, lty = 2)
```

**Kapan digunakan:** Data lebih banyak, ingin melihat bentuk distribusi dan posisi mean.

---

## 🎨 Keterangan Visual

| Elemen | Keterangan |
|--------|------------|
| Warna biru (`steelblue`) | Titik / batang / bar data |
| Garis merah putus-putus | Posisi mean |
| `lty = 2` | Garis putus-putus |
| `lwd = 2` | Ketebalan garis |
| `abline(v = ...)` | Garis vertikal (dotplot & histogram) |
| `abline(h = ...)` | Garis horizontal (barplot) |

---

## ▶️ Cara Menjalankan

```r
source("visualisasi_mean.R")
```

Atau jalankan tiap blok kode satu per satu di RStudio.
