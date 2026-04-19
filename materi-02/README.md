# Data Pre-Processing in R
Modul ini dirancang untuk membantu memahami tahapan pra-pemrosesan data (*data preprocessing*) sebelum melakukan analisis atau pemodelan machine learning. Setiap topik disertai penjelasan konseptual, contoh kode yang dapat langsung dijalankan, dan visualisasi hasil.

---

## Struktur Folder

```
r-data-preprocessing/
│
├── README.md                        
│
├── materi/                          ← File .Rmd dengan penjelasan
│   ├── 01_data_cleaning.Rmd
│   ├── 02_data_transformation.Rmd
│   └── 03_data_reduction.Rmd
│
├── scripts/                         ← Kode R bersih tanpa penjelasan
│   ├── cleaning.R
│   └── preprocessing_functions.R
│
├── data/                            ← Dataset
│   ├── raw_data.csv                 ← Data mentah (belum diproses)
│   └── clean_data.csv               ← Data hasil preprocessing
│
└── requirements.txt                 ← Daftar package R yang dibutuhkan
```

## Prerequisites

### Install R & RStudio
- [Download R](https://cran.r-project.org/)
- [Download RStudio](https://posit.co/download/rstudio-desktop/)

### Install Packages

Jalankan perintah berikut di R Console:

```r
# Baca daftar package dari requirements.txt
packages <- readLines("requirements.txt")
packages <- packages[!grepl("^#", packages) & packages != ""]

# Install package yang belum ada
install.packages(setdiff(packages, rownames(installed.packages())))
```

Atau install manual satu per satu (lihat `requirements.txt`).

---

## Materi

| No | Topik | File | Deskripsi |
|----|-------|------|-----------|
| 1 | **Data Cleaning** | `01_data_cleaning.Rmd` | Missing values, duplikat, outlier, inkonsistensi |
| 2 | **Data Transformation** | `02_data_transformation.Rmd` | Scaling, encoding, normalisasi, log transform |
| 3 | **Data Reduction** | `03_data_reduction.Rmd` | Feature selection, PCA, t-SNE, UMAP, discretization |

---

## Cara Penggunaan

### 1. Clone Repository

```bash
git clone https://github.com/username/r-data-preprocessing.git
cd r-data-preprocessing
```

### 2. Buka di RStudio

Buka file `.Rmd` yang ingin dipelajari di RStudio, lalu klik tombol **Knit** untuk menghasilkan dokumen HTML.

### 3. Jalankan Script Bersih

Untuk langsung menjalankan pipeline preprocessing tanpa penjelasan:

```r
source("scripts/cleaning.R")
source("scripts/preprocessing_functions.R")
```

---

## Dataset

Dataset yang digunakan adalah data karyawan fiktif (`employee_data`) yang sengaja dibuat dengan berbagai masalah umum:

| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | integer | ID unik karyawan |
| `name` | character | Nama karyawan |
| `age` | numeric | Usia (dengan outlier) |
| `salary` | numeric | Gaji bulanan (ada outlier ekstrem) |
| `department` | character | Departemen kerja |
| `city` | character | Kota (inkonsistensi penulisan) |
| `performance_score` | numeric | Skor performa (ada nilai negatif) |
| `years_experience` | numeric | Lama pengalaman kerja |

---

