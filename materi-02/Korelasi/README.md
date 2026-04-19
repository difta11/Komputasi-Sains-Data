# 📊 Korelasi dalam Analisis Data

> **Komputasi Sains Data** — Materi Korelasi  
> Memahami hubungan antar variabel menggunakan metode statistik dan visualisasi

---

## 📌 Deskripsi

Korelasi adalah ukuran statistik yang menggambarkan sejauh mana dua variabel bergerak bersama. Analisis korelasi digunakan untuk mengidentifikasi hubungan antar fitur dalam dataset, yang merupakan langkah penting sebelum membangun model machine learning.

---

## 🎯 Tujuan Pembelajaran

Setelah mempelajari materi ini, mahasiswa diharapkan mampu:

- ✅ Memahami konsep korelasi dan interpretasinya
- ✅ Membedakan jenis-jenis korelasi (Pearson, Spearman, Kendall)
- ✅ Menghitung nilai korelasi menggunakan Python
- ✅ Membuat dan membaca heatmap korelasi
- ✅ Mengidentifikasi multikolinearitas dalam dataset

---

## 📚 Materi

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

#### 🔵 Pearson Correlation
- Mengukur hubungan **linear** antara dua variabel kontinu
- Asumsi: data berdistribusi normal
- Rumus:

$$r = \frac{\sum (x_i - \bar{x})(y_i - \bar{y})}{\sqrt{\sum (x_i - \bar{x})^2 \cdot \sum (y_i - \bar{y})^2}}$$

#### 🟠 Spearman Correlation
- Mengukur hubungan **monoton** (tidak harus linear)
- Berbasis **rank** (peringkat), cocok untuk data ordinal
- Lebih robust terhadap outlier

#### 🟢 Kendall Tau
- Mengukur **konsistensi urutan** antara dua variabel
- Lebih konservatif dari Spearman, cocok untuk dataset kecil

---

### 3. Kapan Menggunakan Masing-Masing?

```
Data kontinu, distribusi normal  →  Pearson
Data ordinal / ada outlier        →  Spearman
Dataset kecil, data ordinal       →  Kendall
```

---

## 💻 Implementasi Python

### Setup Library

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
```

### Load Dataset

```python
# Contoh menggunakan dataset built-in
df = pd.read_csv('data.csv')
df.head()
```

### Pearson Correlation

```python
# Korelasi antar semua kolom numerik
correlation_matrix = df.corr(method='pearson')
print(correlation_matrix)

# Korelasi antara dua variabel spesifik
r, p_value = stats.pearsonr(df['variabel_x'], df['variabel_y'])
print(f"Pearson r: {r:.4f}, p-value: {p_value:.4f}")
```

### Spearman Correlation

```python
rho, p_value = stats.spearmanr(df['variabel_x'], df['variabel_y'])
print(f"Spearman rho: {rho:.4f}, p-value: {p_value:.4f}")
```

### Kendall Tau

```python
tau, p_value = stats.kendalltau(df['variabel_x'], df['variabel_y'])
print(f"Kendall tau: {tau:.4f}, p-value: {p_value:.4f}")
```

### Visualisasi Heatmap

```python
plt.figure(figsize=(10, 8))
sns.heatmap(
    correlation_matrix,
    annot=True,
    fmt=".2f",
    cmap='coolwarm',
    center=0,
    square=True,
    linewidths=0.5
)
plt.title('Heatmap Korelasi Antar Variabel', fontsize=14)
plt.tight_layout()
plt.savefig('heatmap_korelasi.png', dpi=150)
plt.show()
```

### Scatter Plot dengan Regresi

```python
sns.pairplot(df, kind='reg', diag_kind='kde')
plt.suptitle('Pairplot dengan Garis Regresi', y=1.02)
plt.show()
```

---

## 🔍 Interpretasi Hasil

### Membaca Heatmap
- Warna **merah** → korelasi positif tinggi
- Warna **biru** → korelasi negatif tinggi
- Warna **putih/netral** → tidak ada korelasi

### Signifikansi Statistik
- Jika **p-value < 0.05** → korelasi **signifikan** secara statistik
- Jika **p-value ≥ 0.05** → korelasi **tidak signifikan**

### ⚠️ Perhatian: Korelasi ≠ Kausalitas
> *"Correlation does not imply causation"*  
> Dua variabel yang berkorelasi tinggi tidak berarti satu menyebabkan yang lain.

---

## 🧪 Studi Kasus: Deteksi Multikolinearitas

Multikolinearitas terjadi ketika dua atau lebih fitur **sangat berkorelasi** satu sama lain, yang dapat memengaruhi performa model regresi.

```python
# Identifikasi fitur dengan korelasi > 0.85
threshold = 0.85
high_corr = (correlation_matrix.abs() > threshold) & (correlation_matrix != 1.0)

# Tampilkan pasangan yang sangat berkorelasi
pairs = [(col, row) for col in high_corr.columns
         for row in high_corr.index if high_corr.loc[row, col]]
print("Pasangan variabel dengan korelasi tinggi:")
for pair in pairs:
    print(f"  {pair[0]} ↔ {pair[1]}: {correlation_matrix.loc[pair[0], pair[1]]:.3f}")
```

---

## 📁 Struktur Folder

```
Korelasi/
├── README.md               ← Dokumentasi materi
├── notebook/
│   └── korelasi.ipynb      ← Jupyter Notebook utama
├── data/
│   └── dataset.csv         ← Dataset yang digunakan
├── output/
│   └── heatmap_korelasi.png
└── src/
    └── correlation_utils.py
```

---

## 📖 Referensi

- [Pandas Documentation — DataFrame.corr()](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.corr.html)
- [SciPy Stats — Correlation Functions](https://docs.scipy.org/doc/scipy/reference/stats.html)
- [Seaborn — Heatmap](https://seaborn.pydata.org/generated/seaborn.heatmap.html)
- Montgomery, D.C. & Runger, G.C. (2014). *Applied Statistics and Probability for Engineers*. Wiley.

---

<div align="center">
  <sub>Komputasi Sains Data · Materi Korelasi</sub>
</div>
