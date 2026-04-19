# =============================================================
# cleaning.R — Pipeline Data Cleaning
# Data Pre-Processing in R Module
# =============================================================

library(tidyverse)
library(naniar)
library(janitor)

# ---- Load Data -----------------------------------------------
df_raw <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE)

# ---- Missing Values ------------------------------------------
df_imputed <- df_raw %>%
  mutate(
    age = ifelse(is.na(age), median(age, na.rm = TRUE), age),
    salary = ifelse(is.na(salary), median(salary, na.rm = TRUE), salary),
    performance_score = ifelse(
      is.na(performance_score),
      median(performance_score, na.rm = TRUE),
      performance_score
    )
  )

# ---- Duplikat ------------------------------------------------
df_dedup <- df_imputed %>% distinct()

# ---- Outlier (IQR Winsorizing) --------------------------------
remove_outliers_iqr <- function(df, col) {
  Q1  <- quantile(df[[col]], 0.25, na.rm = TRUE)
  Q3  <- quantile(df[[col]], 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  df %>% filter(
    .data[[col]] >= Q1 - 1.5 * IQR,
    .data[[col]] <= Q3 + 1.5 * IQR
  )
}

df_no_outlier <- df_dedup %>%
  remove_outliers_iqr("salary")

# ---- Inkonsistensi -------------------------------------------
df_clean <- df_no_outlier %>%
  mutate(
    city       = str_to_title(str_trim(city)),
    department = str_to_title(str_trim(department)),
    name       = str_squish(str_trim(name)),
    performance_score = ifelse(performance_score < 0, NA, performance_score),
    age = ifelse(age < 18 | age > 80, NA, age)
  ) %>%
  mutate(
    performance_score = ifelse(
      is.na(performance_score),
      median(performance_score, na.rm = TRUE),
      performance_score
    ),
    age = ifelse(
      is.na(age),
      as.integer(median(age, na.rm = TRUE)),
      age
    )
  )

# ---- Tipe Data -----------------------------------------------
df_clean <- df_clean %>%
  mutate(
    id               = as.integer(id),
    age              = as.integer(age),
    years_experience = as.integer(years_experience),
    department       = as.factor(department),
    city             = as.factor(city)
  )

# ---- Simpan --------------------------------------------------
write.csv(df_clean, "data/clean_data.csv", row.names = FALSE)

cat("=== Cleaning selesai ===\n")
cat("Baris awal :", nrow(df_raw), "\n")
cat("Baris akhir:", nrow(df_clean), "\n")
cat("Disimpan ke: data/clean_data.csv\n")
