# 📊 Ukuran Pemusatan (Measures of Central Tendency)

Ukuran pemusatan adalah nilai statistik yang merepresentasikan **pusat atau nilai tengah** dari suatu kumpulan data. Nilai ini menggambarkan kecenderungan data berkumpul di sekitar satu titik.

---

## 📋 Daftar Ukuran Pemusatan

| No | Ukuran | Simbol | Fungsi R | Keterangan |
|----|--------|--------|----------|------------|
| 1 | Mean (Rata-rata) | x̄ / μ | `mean()` | Jumlah semua nilai dibagi banyak data |
| 2 | Median | Me | `median()` | Nilai tengah setelah data diurutkan |
| 3 | Modus (Mode) | Mo | `table()` / `which.max()` | Nilai yang paling sering muncul |
| 4 | Kuartil (Quartile) | Q1, Q2, Q3 | `quantile()` | Membagi data menjadi 4 bagian sama besar |
| 5 | Persentil (Percentile) | Pk | `quantile(, probs=)` | Membagi data menjadi 100 bagian sama besar |
| 6 | Weighted Mean | x̄w | `weighted.mean()` | Rata-rata dengan bobot berbeda tiap nilai |

---

## 1. 📏 Mean (Rata-rata)

**Definisi:** Jumlah seluruh nilai data dibagi dengan banyaknya data. Paling umum digunakan namun sensitif terhadap outlier.

**Rumus:**
```
x̄ = Σxi / n
```

**Kode R:**
```r
x <- c(4, 7, 13, 2, 1)
mean(x)               # 5.4
mean(x, na.rm = TRUE) # abaikan NA
```

**Kelebihan:** Mudah dihitung dan dipahami  
**Kekurangan:** Sensitif terhadap outlier (nilai ekstrem)

---

## 2. 📍 Median

**Definisi:** Nilai tengah dari data yang telah diurutkan. Jika jumlah data genap, median adalah rata-rata dua nilai tengah.

**Rumus:**
```
Me = X[(n+1)/2]                      → n ganjil
Me = (X[n/2] + X[n/2+1]) / 2        → n genap
```

**Kode R:**
```r
x <- c(4, 7, 13, 2, 1)
median(x)  # 4
```

**Kelebihan:** Tidak terpengaruh outlier  
**Kekurangan:** Tidak memperhitungkan semua nilai data

---

## 3. 🔢 Modus (Mode)

**Definisi:** Nilai yang paling sering muncul dalam data. Data bisa memiliki lebih dari satu modus (bimodal / multimodal).

**Kode R:**
```r
x <- c(1, 2, 2, 3, 4, 4, 4, 5)

# Cara 1 — tabel frekuensi
table(x)

# Cara 2 — fungsi custom
modus <- function(v) {
  as.numeric(names(which.max(table(v))))
}
modus(x)  # 4
```

**Kelebihan:** Bisa digunakan untuk data kategorik  
**Kekurangan:** Tidak selalu unik, bisa tidak ada modus

---

## 4. 📊 Kuartil (Quartile)

**Definisi:** Membagi data terurut menjadi 4 bagian sama besar. Q1 = 25%, Q2 = 50% (median), Q3 = 75%.

**Kode R:**
```r
x <- c(1, 3, 5, 7, 9, 11, 13, 15)

quantile(x)                            # Q0, Q1, Q2, Q3, Q4
quantile(x, 0.25)                      # Q1
quantile(x, 0.75)                      # Q3
quantile(x, probs = c(0.25, 0.5, 0.75))
```

**Kelebihan:** Menggambarkan sebaran data secara lengkap  
**Kekurangan:** Lebih kompleks dari mean/median

---

## 5. 📈 Persentil (Percentile)

**Definisi:** Nilai yang membagi data menjadi 100 bagian sama besar. Persentil ke-k berarti k% data berada di bawah nilai tersebut.

**Kode R:**
```r
x <- c(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)

quantile(x, probs = 0.90)                      # persentil ke-90
quantile(x, probs = c(0.10, 0.50, 0.90))       # P10, P50, P90
```

**Kelebihan:** Berguna untuk perbandingan posisi relatif  
**Kekurangan:** Interpretasi lebih sulit bagi pemula

---

## 6. ⚖️ Weighted Mean (Rata-rata Tertimbang)

**Definisi:** Rata-rata di mana setiap nilai memiliki bobot (kontribusi) yang berbeda-beda. Sering digunakan dalam perhitungan IPK.

**Rumus:**
```
x̄w = Σ(wi × xi) / Σwi
```

**Kode R:**
```r
nilai <- c(80, 90, 70, 85)
bobot <- c(3, 2, 4, 1)      # jumlah SKS

weighted.mean(nilai, bobot)  # 79.0
```

**Kelebihan:** Akurat saat tiap data punya kontribusi berbeda  
**Kekurangan:** Membutuhkan data bobot yang valid
