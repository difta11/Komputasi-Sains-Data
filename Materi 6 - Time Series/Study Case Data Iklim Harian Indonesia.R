# STUDY CASE ANALISIS TIME SERIES — DATA IKLIM HARIAN INDONESIA

# Dataset : climate_data.csv
# Sumber  : Climate Data Daily IDN (data iklim harian Indonesia)
# Variabel: date     — tanggal pengamatan harian
#           Tavg     — suhu udara rata-rata harian (°C)
# Subset  : 1000 observasi pertama
#
# Metode yang diterapkan:
#   1. Moving Average (MA-20)          — smoothing tren jangka pendek
#   2. Simple Exponential Smoothing    — pembobotan observasi terbaru (α = 0.4)
#   3. Double Exponential Smoothing    — SES + komponen tren (α = 0.4, β = 0.3)
#   4. Stationarity Check & Differencing
#   5. Box-Jenkins (AR/MA/ARMA)        — pemodelan proses stokastik

library(stats)
library(tseries)

# DATA PREPARATION 
df          <- read.csv("D:/Download/College/ITS/ITS/Academic/4/Komputasi Sains Data/climate_data.csv")
df_selected <- df[1:1000, c("date", "Tavg")]
tavg        <- df_selected[, "Tavg"]

# MOVING AVERAGE (MA-20)
ma_20 <- stats::filter(tavg, rep(1/20, 20), sides = 1)

par(mar = c(4, 4, 2, 1), bg = "white")
plot(tavg, type = "l", col = "#b0b0b0", lwd = 1,
     xlab = "Index", ylab = "Tavg (°C)", main = "Moving Average MA-20",
     las = 1, bty = "l")
lines(ma_20, col = "#e05c00", lwd = 2)
legend("topright", legend = c("Original", "MA-20"),
       col = c("#b0b0b0", "#e05c00"), lwd = c(1, 2), bty = "n")

# SIMPLE EXPONENTIAL SMOOTHING (SES) 
n     <- length(tavg)
alpha <- 0.4

level    <- numeric(n)
forecast <- numeric(n)
level[1]    <- tavg[1]   # inisialisasi level awal
forecast[1] <- NA
forecast[2] <- level[1]

for (i in 2:n) {
  level[i] <- alpha * tavg[i] + (1 - alpha) * level[i-1]
  if (i < n) forecast[i+1] <- level[i]
}

hasil_ses <- data.frame(
  t  = 1:n,
  Yt = round(tavg, 2),
  Lt = round(level, 2),
  Ft = round(forecast, 2)
)
write.csv(hasil_ses, "hasil_ses.csv", row.names = FALSE)

plot(hasil_ses$Yt, type = "l", col = "#b0b0b0", lwd = 1,
     xlab = "Index", ylab = "Tavg (°C)", main = paste0("SES (α = ", alpha, ")"),
     las = 1, bty = "l")
lines(hasil_ses$Ft, col = "#2e86de", lwd = 2)
legend("topright", legend = c("Original", "Forecast"),
       col = c("#b0b0b0", "#2e86de"), lwd = c(1, 2), bty = "n")

# DOUBLE EXPONENTIAL SMOOTHING (DES)
alpha <- 0.4
beta  <- 0.3

level_d    <- numeric(n)
trend_d    <- numeric(n)
forecast_d <- numeric(n)

level_d[1]    <- tavg[1]
trend_d[1]    <- tavg[2] - tavg[1]   # estimasi trend awal
forecast_d[1] <- NA
forecast_d[2] <- level_d[1] + trend_d[1]

for (i in 2:n) {
  level_d[i] <- alpha * tavg[i] + (1 - alpha) * (level_d[i-1] + trend_d[i-1])
  trend_d[i]  <- beta * (level_d[i] - level_d[i-1]) + (1 - beta) * trend_d[i-1]
  if (i < n) forecast_d[i+1] <- level_d[i] + trend_d[i]
}

hasil_des <- data.frame(
  t  = 1:n,
  Yt = round(tavg, 2),
  Lt = round(level_d, 2),
  Tt = round(trend_d, 2),
  Ft = round(forecast_d, 2)
)
write.csv(hasil_des, "hasil_des.csv", row.names = FALSE)

plot(hasil_des$Yt, type = "l", col = "#b0b0b0", lwd = 1,
     xlab = "Index", ylab = "Tavg (°C)", main = paste0("DES (α = ", alpha, ", β = ", beta, ")"),
     las = 1, bty = "l")
lines(hasil_des$Ft, col = "#8e44ad", lwd = 2, lty = 2)
legend("topright", legend = c("Original", "Forecast"),
       col = c("#b0b0b0", "#8e44ad"), lwd = c(1, 2), lty = c(1, 2), bty = "n")

# STATIONARITY CHECK & DIFFERENCING 
par(mfrow = c(2, 2), mar = c(4, 4, 3, 1), bg = "white")

plot(tavg, type = "l", col = "#b0b0b0", lwd = 1,
     main = "Data Asli (Tavg)", xlab = "Index", ylab = "°C",
     las = 1, bty = "l")
acf(tavg, main = "ACF — Data Asli", col = "#2e86de", lwd = 2, las = 1, bty = "l")

adf_asli <- adf.test(tavg)
cat("ADF (data asli) — p-value:", round(adf_asli$p.value, 4), "\n")
if (adf_asli$p.value > 0.05) {
  cat("Kesimpulan: Data TIDAK stasioner, perlu differencing.\n")
} else {
  cat("Kesimpulan: Data sudah stasioner, differencing tidak diperlukan.\n")
}

tavg_diff <- diff(tavg, differences = 1)

plot(tavg_diff, type = "l", col = "#e05c00", lwd = 1,
     main = "Setelah Differencing (d=1)", xlab = "Index", ylab = "Δ°C",
     las = 1, bty = "l")
acf(tavg_diff, main = "ACF — Setelah Diff", col = "#e05c00", lwd = 2, las = 1, bty = "l")

par(mfrow = c(1, 1))

adf_diff <- adf.test(tavg_diff)
cat("ADF setelah diff(1) — p-value:", round(adf_diff$p.value, 4), "\n")
if (adf_diff$p.value <= 0.05) {
  cat("Kesimpulan: Data sudah stasioner setelah differencing orde 1.\n")
} else {
  cat("Kesimpulan: Data masih belum stasioner, pertimbangkan differencing orde 2.\n")
}

data_bj <- if (adf_asli$p.value > 0.05) tavg_diff else tavg
d_order  <- if (adf_asli$p.value > 0.05) 1 else 0
cat("Data yang digunakan untuk Box-Jenkins: d =", d_order, "\n")

# BOX-JENKINS (AR/MA/ARMA) 
plot_bj <- function(data, title, col_line = "#2e86de") {
  par(mfrow = c(1, 3), mar = c(4, 4, 3, 1), bg = "white")
  ts.plot(data, col = col_line, lwd = 1.2,
          main = title, ylab = "Value", xlab = "Time",
          gpars = list(las = 1, bty = "l"))
  acf(data,  main = "ACF",  col = col_line, lwd = 2, las = 1, bty = "l")
  pacf(data, main = "PACF", col = col_line, lwd = 2, las = 1, bty = "l")
  par(mfrow = c(1, 1))
}

# AR(1)
cat("\nAR(1)\n")
plot_bj(data_bj, paste0("AR(1) — d=", d_order), col_line = "#2e86de")
fit_ar <- arima(data_bj, order = c(1, d_order, 0))
print(summary(fit_ar))
lb_ar <- Box.test(residuals(fit_ar), lag = 10, type = "Ljung-Box")
print(lb_ar)
if (lb_ar$p.value > 0.05) {
  cat("Kesimpulan: Residual AR(1) adalah white noise, model sudah memadai.\n")
} else {
  cat("Kesimpulan: Residual AR(1) masih mengandung autokorelasi, model perlu ditinjau.\n")
}

# MA(1)
cat("\nMA(1)\n")
plot_bj(data_bj, paste0("MA(1) — d=", d_order), col_line = "#e05c00")
fit_ma <- arima(data_bj, order = c(0, d_order, 1))
print(summary(fit_ma))
lb_ma <- Box.test(residuals(fit_ma), lag = 10, type = "Ljung-Box")
print(lb_ma)
if (lb_ma$p.value > 0.05) {
  cat("Kesimpulan: Residual MA(1) adalah white noise, model sudah memadai.\n")
} else {
  cat("Kesimpulan: Residual MA(1) masih mengandung autokorelasi, model perlu ditinjau.\n")
}

# ARMA(1,1)
cat("\nARMA(1,1)\n")
plot_bj(data_bj, paste0("ARMA(1,1) — d=", d_order), col_line = "#27ae60")
fit_arma <- arima(data_bj, order = c(1, d_order, 1))
print(summary(fit_arma))
lb_arma <- Box.test(residuals(fit_arma), lag = 10, type = "Ljung-Box")
print(lb_arma)
if (lb_arma$p.value > 0.05) {
  cat("Kesimpulan: Residual ARMA(1,1) adalah white noise, model sudah memadai.\n")
} else {
  cat("Kesimpulan: Residual ARMA(1,1) masih mengandung autokorelasi, model perlu ditinjau.\n")
}