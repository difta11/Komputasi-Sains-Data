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
