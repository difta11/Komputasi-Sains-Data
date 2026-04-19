# =============================================================
# preprocessing_functions.R — Fungsi Reusable Pre-Processing
# Data Pre-Processing in R Module
# =============================================================

library(tidyverse)
library(caret)
library(FactoMineR)
library(factoextra)
library(Rtsne)
library(umap)

# ==============================================================
# 1. DATA CLEANING FUNCTIONS
# ==============================================================

#' Deteksi outlier dengan metode IQR
#' @param x Vektor numerik
#' @param k Multiplier IQR (default 1.5)
#' @return Logical vector: TRUE jika outlier
is_outlier_iqr <- function(x, k = 1.5) {
  Q1  <- quantile(x, 0.25, na.rm = TRUE)
  Q3  <- quantile(x, 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  x < (Q1 - k * IQR) | x > (Q3 + k * IQR)
}

#' Winsorize: batasi nilai pada persentil tertentu
#' @param x Vektor numerik
#' @param lower Persentil bawah (default 0.05)
#' @param upper Persentil atas (default 0.95)
#' @return Vektor numerik setelah winsorizing
winsorize <- function(x, lower = 0.05, upper = 0.95) {
  q <- quantile(x, c(lower, upper), na.rm = TRUE)
  pmin(pmax(x, q[1]), q[2])
}

#' Deteksi outlier dengan Z-score
#' @param x Vektor numerik
#' @param threshold Batas Z-score (default 3)
#' @return Logical vector: TRUE jika outlier
is_outlier_zscore <- function(x, threshold = 3) {
  abs((x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)) > threshold
}

#' Standardisasi teks: trim + title case
#' @param x Vektor karakter
#' @return Vektor karakter yang telah distandardisasi
standardize_text <- function(x) {
  stringr::str_to_title(stringr::str_squish(x))
}

#' Ringkasan missing values
#' @param df DataFrame
#' @return DataFrame dengan info missing values per kolom
missing_summary <- function(df) {
  df %>%
    summarise(across(everything(), ~ sum(is.na(.)))) %>%
    pivot_longer(everything(), names_to = "kolom", values_to = "n_missing") %>%
    mutate(pct_missing = round(n_missing / nrow(df) * 100, 2)) %>%
    arrange(desc(n_missing))
}

# ==============================================================
# 2. DATA TRANSFORMATION FUNCTIONS
# ==============================================================

#' Min-Max normalisasi ke rentang [0, 1]
#' @param x Vektor numerik
#' @return Vektor numerik yang telah dinormalisasi
normalize_minmax <- function(x) {
  (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}

#' Z-score standardisasi
#' @param x Vektor numerik
#' @return Vektor numerik dengan mean=0 dan sd=1
standardize_zscore <- function(x) {
  as.vector(scale(x))
}

#' Robust scaling menggunakan median dan IQR
#' @param x Vektor numerik
#' @return Vektor numerik setelah robust scaling
robust_scale <- function(x) {
  med <- median(x, na.rm = TRUE)
  iqr <- IQR(x, na.rm = TRUE)
  (x - med) / iqr
}

#' Log1p transform (aman untuk nol)
#' @param x Vektor numerik (harus >= 0)
#' @return Vektor numerik setelah log(x+1)
log_transform <- function(x) {
  log1p(x)
}

#' Label encoding untuk variabel faktor
#' @param x Vektor karakter atau faktor
#' @return Vektor integer
label_encode <- function(x) {
  as.integer(as.factor(x))
}

#' One-hot encoding untuk variabel kategorikal
#' @param df DataFrame
#' @param col Nama kolom yang akan di-encode
#' @return DataFrame dengan kolom one-hot baru
one_hot_encode <- function(df, col) {
  dummy <- model.matrix(~ . - 1, data = df[col])
  colnames(dummy) <- gsub(col, paste0(col, "_"), colnames(dummy))
  bind_cols(df %>% select(-all_of(col)), as.data.frame(dummy))
}

#' Target encoding: ganti kategori dengan mean target
#' @param df DataFrame
#' @param cat_col Nama kolom kategorikal
#' @param target_col Nama kolom target
#' @return DataFrame dengan kolom target encoding baru
target_encode <- function(df, cat_col, target_col) {
  enc_map <- df %>%
    group_by(.data[[cat_col]]) %>%
    summarise(target_mean = mean(.data[[target_col]], na.rm = TRUE), .groups = "drop")
  df %>%
    left_join(enc_map, by = cat_col) %>%
    rename_with(~ paste0(cat_col, "_encoded"), "target_mean")
}

# ==============================================================
# 3. DATA REDUCTION FUNCTIONS
# ==============================================================

#' Terapkan PCA dan kembalikan skor komponen
#' @param df DataFrame numerik
#' @param n_components Jumlah komponen (NULL = otomatis dari variance_threshold)
#' @param variance_threshold Variansi minimum kumulatif (default 0.80)
#' @param scale Data akan distandarisasi sebelum PCA
#' @return List: scores, pca_object, n_components
run_pca <- function(df, n_components = NULL, variance_threshold = 0.80, scale = TRUE) {
  df_clean <- na.omit(df)
  if (scale) df_clean <- as.data.frame(base::scale(df_clean))

  pca <- prcomp(df_clean, center = FALSE, scale. = FALSE)

  if (is.null(n_components)) {
    cum_var <- summary(pca)$importance[3, ]
    n_components <- min(which(cum_var >= variance_threshold))
  }

  list(
    scores       = as.data.frame(pca$x[, 1:n_components]),
    pca_object   = pca,
    n_components = n_components,
    var_explained = summary(pca)$importance[2, 1:n_components]
  )
}

#' Terapkan t-SNE untuk visualisasi
#' @param df DataFrame numerik (akan distandarisasi)
#' @param perplexity Nilai perplexity (default 15)
#' @param max_iter Jumlah iterasi (default 1000)
#' @return DataFrame dengan kolom TSNE1 dan TSNE2
run_tsne <- function(df, perplexity = 15, max_iter = 1000) {
  set.seed(42)
  df_clean <- as.data.frame(scale(na.omit(df)))
  df_clean <- unique(df_clean)
  result <- Rtsne::Rtsne(
    df_clean,
    dims             = 2,
    perplexity       = perplexity,
    max_iter         = max_iter,
    check_duplicates = FALSE,
    verbose          = FALSE
  )
  data.frame(TSNE1 = result$Y[, 1], TSNE2 = result$Y[, 2])
}

#' Terapkan UMAP untuk visualisasi
#' @param df DataFrame numerik (akan distandarisasi)
#' @param n_neighbors Ukuran neighborhood (default 15)
#' @param min_dist Jarak minimum (default 0.1)
#' @return DataFrame dengan kolom UMAP1 dan UMAP2
run_umap <- function(df, n_neighbors = 15, min_dist = 0.1) {
  set.seed(42)
  df_clean <- as.data.frame(scale(na.omit(df)))
  cfg <- umap::umap.defaults
  cfg$n_neighbors  <- n_neighbors
  cfg$min_dist     <- min_dist
  cfg$n_components <- 2
  result <- umap::umap(df_clean, config = cfg)
  data.frame(UMAP1 = result$layout[, 1], UMAP2 = result$layout[, 2])
}

#' Equal-width binning
#' @param x Vektor numerik
#' @param n Jumlah bin (default 4)
#' @param labels Label untuk setiap bin
#' @return Faktor
bin_equal_width <- function(x, n = 4, labels = NULL) {
  cut(x, breaks = n, labels = labels, include.lowest = TRUE)
}

#' Equal-frequency binning
#' @param x Vektor numerik
#' @param n Jumlah bin (default 4)
#' @param labels Label untuk setiap bin
#' @return Faktor
bin_equal_freq <- function(x, n = 4, labels = NULL) {
  probs <- seq(0, 1, length.out = n + 1)
  breaks <- quantile(x, probs, na.rm = TRUE)
  cut(x, breaks = breaks, labels = labels, include.lowest = TRUE)
}

# ==============================================================
# 4. PIPELINE LENGKAP
# ==============================================================

#' Pipeline preprocessing lengkap
#' @param df DataFrame mentah
#' @param target Nama kolom target (untuk supervised steps)
#' @param id_cols Kolom ID yang tidak diproses
#' @return DataFrame yang telah diproses
preprocess_pipeline <- function(df, target = NULL, id_cols = c("id", "name")) {
  cat("=== Memulai Pipeline Pre-Processing ===\n")

  # Step 1: Hapus duplikat
  df <- df %>% distinct()
  cat("[1] Duplikat dihapus. Baris:", nrow(df), "\n")

  # Step 2: Imputasi median untuk numerik
  df <- df %>%
    mutate(across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)))
  cat("[2] Missing values diimputasi.\n")

  # Step 3: Standardisasi teks
  df <- df %>%
    mutate(across(where(is.character) & !all_of(id_cols), standardize_text))
  cat("[3] Teks distandardisasi.\n")

  # Step 4: Hapus outlier pada kolom numerik (kecuali target)
  numeric_cols <- names(df)[sapply(df, is.numeric)]
  if (!is.null(target)) numeric_cols <- setdiff(numeric_cols, target)
  numeric_cols <- setdiff(numeric_cols, id_cols)

  for (col in numeric_cols) {
    outlier_idx <- is_outlier_iqr(df[[col]])
    df[[col]][outlier_idx] <- NA
    df[[col]][is.na(df[[col]])] <- median(df[[col]], na.rm = TRUE)
  }
  cat("[4] Outlier ditangani dengan winsorizing.\n")

  # Step 5: Konversi tipe data
  df <- df %>%
    mutate(across(where(is.character) & !all_of(id_cols), as.factor))
  cat("[5] Tipe data dikonversi.\n")

  cat("=== Pipeline selesai. Baris akhir:", nrow(df), "===\n")
  return(df)
}

# ==============================================================
# CONTOH PENGGUNAAN
# ==============================================================
if (FALSE) {
  df_raw   <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE)
  df_clean <- preprocess_pipeline(df_raw, target = "performance_score")

  # Normalisasi
  df_clean$salary_norm <- normalize_minmax(df_clean$salary)

  # PCA
  df_num  <- df_clean %>% select(age, salary, performance_score, years_experience)
  pca_res <- run_pca(df_num, variance_threshold = 0.80)

  # t-SNE
  tsne_df <- run_tsne(df_num, perplexity = 15)

  # Binning
  df_clean$salary_bin <- bin_equal_freq(df_clean$salary, n = 4,
    labels = c("Rendah", "Menengah-Bawah", "Menengah-Atas", "Tinggi"))
}
