# ============================================
# Ukuran Pemusatan: MEAN (Rata-rata)
# ============================================

# Sample data
data <- c(1, 3, 7, -2, 6, -5, 4)

# --------------------------------------------
# 1. Mean Manual (tanpa fungsi bawaan R)
# --------------------------------------------
mean_function <- function(data) {
  sum   <- 0
  count <- 0
  for (i in data) {
    sum   <- sum + i
    count <- count + 1
  }
  return(sum / count)
}

avg_x_wl <- mean_function(data)
cat("Mean (manual loop)     :", avg_x_wl, "\n")

# --------------------------------------------
# 2. Mean Fast Track (satu baris)
# --------------------------------------------
mean_function_fast_track <- function(data) {
  return(sum(data) / length(data))
}

avg_x_wf <- mean_function_fast_track(data)
cat("Mean (fast track)      :", avg_x_wf, "\n")

# --------------------------------------------
# 3. Mean Built-in R
# --------------------------------------------
avg_builtin <- mean(data)
cat("Mean (built-in)        :", avg_builtin, "\n")

# --------------------------------------------
# 4. Mean dengan NA (abaikan nilai kosong)
# --------------------------------------------
data_na <- c(1, 3, NA, -2, 6, NA, 4)
avg_na  <- mean(data_na, na.rm = TRUE)
cat("Mean (dengan NA)       :", avg_na, "\n")

# --------------------------------------------
# 5. Weighted Mean (rata-rata tertimbang)
# --------------------------------------------
nilai <- c(80, 90, 70, 85)
bobot <- c(3,  2,  4,  1)   # contoh: jumlah SKS

avg_weighted <- weighted.mean(nilai, bobot)
cat("Weighted Mean          :", avg_weighted, "\n")
