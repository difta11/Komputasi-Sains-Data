# ============================================================
#   TIME SERIES SMOOTHING IN R
#   Moving Average & Exponential Smoothing
# ============================================================

# Install packages jika belum ada
# install.packages(c("forecast", "ggplot2", "dplyr"))

library(forecast)
library(ggplot2)
library(dplyr)


# ============================================================
# 1. MEMBUAT DATA CONTOH
# ============================================================

set.seed(42)
n <- 60  # 60 bulan data

# Simulasi data penjualan bulanan dengan tren + musiman + noise
waktu   <- 1:n
tren    <- 50 + 0.8 * waktu
musiman <- 10 * sin(2 * pi * waktu / 12)
noise   <- rnorm(n, mean = 0, sd = 5)
penjualan <- tren + musiman + noise

# Buat time series object (mulai Januari 2020, frekuensi bulanan)
ts_data <- ts(penjualan, start = c(2020, 1), frequency = 12)

cat("=== DATA TIME SERIES ===\n")
print(ts_data)


# ============================================================
# 2. MOVING AVERAGE (MA)
# ============================================================

cat("\n=== MOVING AVERAGE ===\n")

# --- 2a. Simple Moving Average Manual ---
moving_average <- function(x, k) {
  n  <- length(x)
  ma <- rep(NA, n)
  for (i in k:n) {
    ma[i] <- mean(x[(i - k + 1):i])
  }
  return(ma)
}

ma3  <- moving_average(penjualan, k = 3)   # MA orde 3
ma6  <- moving_average(penjualan, k = 6)   # MA orde 6
ma12 <- moving_average(penjualan, k = 12)  # MA orde 12

cat("Moving Average (3 bulan terakhir):\n")
print(round(ma3, 2))

# --- 2b. MA menggunakan fungsi filter() ---
ma3_filter  <- stats::filter(penjualan, rep(1/3,  3),  sides = 1)
ma6_filter  <- stats::filter(penjualan, rep(1/6,  6),  sides = 1)
ma12_filter <- stats::filter(penjualan, rep(1/12, 12), sides = 1)

# --- 2c. Centered Moving Average (untuk dekomposisi musiman) ---
ma_centered <- stats::filter(penjualan,
                             filter = c(0.5, rep(1, 11), 0.5) / 12,
                             sides  = 2)

cat("\nCentered Moving Average (12 bulan):\n")
print(round(ma_centered, 2))

# --- 2d. Weighted Moving Average ---
bobot <- c(1, 2, 3)  # bobot lebih tinggi untuk data terbaru
bobot <- bobot / sum(bobot)

moving_average_weighted <- function(x, w) {
  k  <- length(w)
  n  <- length(x)
  wma <- rep(NA, n)
  for (i in k:n) {
    wma[i] <- sum(x[(i - k + 1):i] * w)
  }
  return(wma)
}

wma_3 <- moving_average_weighted(penjualan, bobot)
cat("\nWeighted Moving Average (bobot: 1/6, 2/6, 3/6):\n")
print(round(wma_3, 2))


# ============================================================
# 3. EXPONENTIAL SMOOTHING
# ============================================================

cat("\n=== EXPONENTIAL SMOOTHING ===\n")

# --- 3a. Simple Exponential Smoothing (SES) ---
# Cocok untuk data tanpa tren & tanpa musiman
# alpha: bobot data terbaru (0 < alpha < 1)

ses_manual <- function(x, alpha) {
  n   <- length(x)
  s   <- rep(NA, n)
  s[1] <- x[1]  # inisialisasi dengan nilai pertama
  for (i in 2:n) {
    s[i] <- alpha * x[i] + (1 - alpha) * s[i - 1]
  }
  return(s)
}

ses_02 <- ses_manual(penjualan, alpha = 0.2)  # smoothing ringan
ses_05 <- ses_manual(penjualan, alpha = 0.5)  # sedang
ses_08 <- ses_manual(penjualan, alpha = 0.8)  # smoothing kuat (reaktif)

cat("SES (alpha = 0.2) - 10 nilai pertama:\n")
print(round(ses_02[1:10], 2))

# SES menggunakan package forecast
ses_auto <- ses(ts_data, h = 12, alpha = 0.3)
cat("\nForecast SES (alpha=0.3) untuk 12 bulan ke depan:\n")
print(ses_auto$mean)

# --- 3b. Double Exponential Smoothing / Holt's Method ---
# Cocok untuk data dengan TREN (tanpa musiman)
# alpha: smoothing level, beta: smoothing tren

holt_model <- holt(ts_data,
                   h    = 12,
                   alpha = 0.3,
                   beta  = 0.1)

cat("\n=== HOLT'S DOUBLE EXPONENTIAL SMOOTHING ===\n")
cat("Forecast untuk 12 bulan ke depan:\n")
print(holt_model$mean)

cat("\nModel summary:\n")
summary(holt_model)

# --- 3c. Triple Exponential Smoothing / Holt-Winters ---
# Cocok untuk data dengan TREN + MUSIMAN

# Additive: amplitudo musiman konstan
hw_add <- HoltWinters(ts_data, seasonal = "additive")

# Multiplicative: amplitudo musiman proporsional terhadap level
hw_mul <- HoltWinters(ts_data, seasonal = "multiplicative")

cat("\n=== HOLT-WINTERS TRIPLE EXPONENTIAL SMOOTHING ===\n")

cat("--- Additive Model ---\n")
cat("Alpha (level)   :", hw_add$alpha, "\n")
cat("Beta  (tren)    :", hw_add$beta,  "\n")
cat("Gamma (musiman) :", hw_add$gamma, "\n")

cat("\n--- Multiplicative Model ---\n")
cat("Alpha:", hw_mul$alpha, "\n")
cat("Beta :", hw_mul$beta,  "\n")
cat("Gamma:", hw_mul$gamma, "\n")

# Forecast 12 bulan ke depan
hw_forecast_add <- predict(hw_add, n.ahead = 12, prediction.interval = TRUE)
hw_forecast_mul <- predict(hw_mul, n.ahead = 12, prediction.interval = TRUE)

cat("\nForecast Holt-Winters Additive:\n")
print(round(hw_forecast_add, 2))

# --- 3d. ETS (Error, Trend, Seasonal) - Auto Selection ---
ets_model <- ets(ts_data)
cat("\n=== ETS MODEL (Auto) ===\n")
summary(ets_model)

ets_forecast <- forecast(ets_model, h = 12)
cat("\nForecast ETS untuk 12 bulan:\n")
print(ets_forecast$mean)


# ============================================================
# 4. EVALUASI AKURASI MODEL
# ============================================================

cat("\n=== EVALUASI AKURASI ===\n")

# Fungsi hitung error manual
hitung_akurasi <- function(aktual, prediksi, nama_model) {
  aktual   <- aktual[!is.na(prediksi)]
  prediksi <- prediksi[!is.na(prediksi)]
  error    <- aktual - prediksi

  mae  <- mean(abs(error))
  mse  <- mean(error^2)
  rmse <- sqrt(mse)
  mape <- mean(abs(error / aktual)) * 100

  cat(sprintf("\n[%s]\n", nama_model))
  cat(sprintf("  MAE  : %.4f\n", mae))
  cat(sprintf("  MSE  : %.4f\n", mse))
  cat(sprintf("  RMSE : %.4f\n", rmse))
  cat(sprintf("  MAPE : %.2f%%\n", mape))

  return(list(MAE = mae, MSE = mse, RMSE = rmse, MAPE = mape))
}

# Bandingkan model
akurasi_ma3  <- hitung_akurasi(penjualan, ma3,    "Moving Average (k=3)")
akurasi_ma6  <- hitung_akurasi(penjualan, ma6,    "Moving Average (k=6)")
akurasi_ma12 <- hitung_akurasi(penjualan, ma12,   "Moving Average (k=12)")
akurasi_ses  <- hitung_akurasi(penjualan, ses_02, "SES (alpha=0.2)")
akurasi_ses5 <- hitung_akurasi(penjualan, ses_05, "SES (alpha=0.5)")
akurasi_ses8 <- hitung_akurasi(penjualan, ses_08, "SES (alpha=0.8)")

# Ringkasan perbandingan
tabel_akurasi <- data.frame(
  Model = c("MA(3)", "MA(6)", "MA(12)",
            "SES(0.2)", "SES(0.5)", "SES(0.8)"),
  MAE   = c(akurasi_ma3$MAE,  akurasi_ma6$MAE,  akurasi_ma12$MAE,
            akurasi_ses$MAE,  akurasi_ses5$MAE, akurasi_ses8$MAE),
  RMSE  = c(akurasi_ma3$RMSE, akurasi_ma6$RMSE, akurasi_ma12$RMSE,
            akurasi_ses$RMSE, akurasi_ses5$RMSE, akurasi_ses8$RMSE),
  MAPE  = c(akurasi_ma3$MAPE, akurasi_ma6$MAPE, akurasi_ma12$MAPE,
            akurasi_ses$MAPE, akurasi_ses5$MAPE, akurasi_ses8$MAPE)
)

cat("\n=== TABEL RINGKASAN AKURASI ===\n")
print(tabel_akurasi)

model_terbaik <- tabel_akurasi[which.min(tabel_akurasi$RMSE), "Model"]
cat(sprintf("\nModel terbaik (RMSE terendah): %s\n", model_terbaik))


# ============================================================
# 5. VISUALISASI
# ============================================================

cat("\n=== MEMBUAT GRAFIK ===\n")

# Dataframe untuk ggplot
df_plot <- data.frame(
  t       = waktu,
  Aktual  = penjualan,
  MA3     = ma3,
  MA6     = ma6,
  MA12    = ma12,
  SES_02  = ses_02,
  SES_05  = ses_05,
  SES_08  = ses_08
)

# --- Plot 1: Moving Average ---
p1 <- ggplot(df_plot, aes(x = t)) +
  geom_line(aes(y = Aktual, color = "Data Aktual"), linewidth = 0.8) +
  geom_line(aes(y = MA3,  color = "MA(3)"),  linetype = "dashed", linewidth = 0.8) +
  geom_line(aes(y = MA6,  color = "MA(6)"),  linetype = "dashed", linewidth = 0.8) +
  geom_line(aes(y = MA12, color = "MA(12)"), linetype = "dashed", linewidth = 0.8) +
  scale_color_manual(values = c("Data Aktual" = "black",
                                "MA(3)"  = "#E74C3C",
                                "MA(6)"  = "#3498DB",
                                "MA(12)" = "#2ECC71")) +
  labs(title    = "Moving Average - Perbandingan Orde",
       subtitle = "Semakin besar k, semakin halus kurva",
       x        = "Periode (Bulan)",
       y        = "Nilai",
       color    = "Metode") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"),
        legend.position = "bottom")

print(p1)

# --- Plot 2: Exponential Smoothing ---
p2 <- ggplot(df_plot, aes(x = t)) +
  geom_line(aes(y = Aktual, color = "Data Aktual"), linewidth = 0.8) +
  geom_line(aes(y = SES_02, color = "SES alpha=0.2"), linetype = "dashed", linewidth = 0.8) +
  geom_line(aes(y = SES_05, color = "SES alpha=0.5"), linetype = "dashed", linewidth = 0.8) +
  geom_line(aes(y = SES_08, color = "SES alpha=0.8"), linetype = "dashed", linewidth = 0.8) +
  scale_color_manual(values = c("Data Aktual"    = "black",
                                "SES alpha=0.2"  = "#9B59B6",
                                "SES alpha=0.5"  = "#E67E22",
                                "SES alpha=0.8"  = "#1ABC9C")) +
  labs(title    = "Simple Exponential Smoothing - Perbandingan Alpha",
       subtitle = "Alpha kecil = lebih halus | Alpha besar = lebih reaktif",
       x        = "Periode (Bulan)",
       y        = "Nilai",
       color    = "Metode") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"),
        legend.position = "bottom")

print(p2)

# --- Plot 3: Holt-Winters + Forecast ---
hw_fitted   <- as.numeric(fitted(hw_add))
hw_pred     <- as.numeric(hw_forecast_add[, "fit"])
t_forecast  <- (n + 1):(n + 12)

df_hw <- data.frame(
  t     = c(waktu, t_forecast),
  nilai = c(penjualan, hw_pred),
  tipe  = c(rep("Aktual", n), rep("Forecast", 12))
)

df_fitted <- data.frame(t = 13:n, fitted = hw_fitted)  # HW mulai obs ke-13

p3 <- ggplot() +
  geom_line(data = df_hw[df_hw$tipe == "Aktual",],
            aes(x = t, y = nilai, color = "Data Aktual"), linewidth = 0.8) +
  geom_line(data = df_fitted,
            aes(x = t, y = fitted, color = "Holt-Winters Fitted"),
            linetype = "dashed", linewidth = 0.8) +
  geom_line(data = df_hw[df_hw$tipe == "Forecast",],
            aes(x = t, y = nilai, color = "Forecast"),
            linewidth = 1) +
  geom_vline(xintercept = n, linetype = "dotted", color = "gray40") +
  annotate("text", x = n + 0.5, y = max(penjualan) * 0.95,
           label = "Mulai\nForecast", hjust = 0, size = 3.5, color = "gray40") +
  scale_color_manual(values = c("Data Aktual"         = "black",
                                "Holt-Winters Fitted" = "#3498DB",
                                "Forecast"            = "#E74C3C")) +
  labs(title    = "Holt-Winters Triple Exponential Smoothing + Forecast",
       subtitle = "Model additive dengan komponen tren dan musiman",
       x        = "Periode (Bulan)",
       y        = "Nilai",
       color    = "") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"),
        legend.position = "bottom")

print(p3)

cat("\n Selesai! Semua model berhasil dibuat dan divisualisasikan.\n")
