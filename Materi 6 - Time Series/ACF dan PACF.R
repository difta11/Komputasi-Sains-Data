# ── Data contoh ──────────────────────────────────────────────
set.seed(42)
x <- cumsum(rnorm(100))          # simulasi random walk

# ── Fungsi: mean & varian manual ─────────────────────────────
mean_manual <- function(v) sum(v) / length(v)

var_manual  <- function(v) {
  mu <- mean_manual(v)
  sum((v - mu)^2) / (length(v) - 1)
}

# ── Hitung ACF manual ─────────────────────────────
acf_manual <- function(x, max_lag = 20) {
  n  <- length(x)
  mu <- mean_manual(x)

  # γ(0) = varian populasi (pembagi n, bukan n-1)
  gamma0 <- sum((x - mu)^2) / n

  acf_vals <- numeric(max_lag + 1)
  acf_vals[1] <- 1                    # lag-0 selalu 1

  for (k in 1:max_lag) {
    # γ(k) = (1/n) Σ (x_t − μ)(x_{t−k} − μ)
    gamma_k <- sum((x[(k+1):n] - mu) *
                    (x[1:(n-k)]   - mu)) / n
    acf_vals[k + 1] <- gamma_k / gamma0
  }
  acf_vals
}

# ── Hitung PCF manual ─────────────────────────────
pacf_manual <- function(x, max_lag = 20) {
  acf_v    <- acf_manual(x, max_lag)
  rho      <- acf_v[-1]           # lag 1..max_lag
  pacf_v   <- numeric(max_lag)
  phi_prev <- numeric(0)

  for (k in 1:max_lag) {
    if (k == 1) {
      phi_kk <- rho[1]

    } else {
      # numerator   = ρ(k) − Σ_{j=1}^{k-1} φ_{j} ρ(k-j)
      # denominator = 1    − Σ_{j=1}^{k-1} φ_{j} ρ(j)
      num <- rho[k] - sum(phi_prev * rho[(k-1):1])
      den <- 1      - sum(phi_prev * rho[1:(k-1)])
      phi_kk <- num / den

      # update koefisien φ_{j} untuk orde berikutnya
      phi_prev <- phi_prev - phi_kk * rev(phi_prev)
    }
    pacf_v[k]  <- phi_kk
    phi_prev   <- c(phi_prev, phi_kk)
  }
  pacf_v
}

# ── Plot manual ─────────────────────────────
plot_corr <- function(vals, lags, title,
                       ci = 1.96 / sqrt(length(x))) {

  # batas y: sedikit lebih lebar dari nilai max/min
  ylim <- c(min(c(vals, -ci)) - 0.05,
             max(c(vals,  ci)) + 0.05)

  # kanvas kosong
  plot(NA, xlim = c(0, max(lags)), ylim = ylim,
       xlab = "Lag", ylab = "Korelasi",
       main = title, las = 1)
  abline(h = 0, col = "gray50")

  # batas kepercayaan 95 % (garis putus-putus biru)
  abline(h = c(-ci, ci), lty = 2, col = "steelblue")

  # batang vertikal
  for (i in seq_along(lags)) {
    segments(lags[i], 0, lags[i], vals[i],
             col  = if (abs(vals[i]) > ci) "tomato" else "gray30",
             lwd  = 2)
    points(lags[i], vals[i], pch = 19, cex = 0.7,
           col  = if (abs(vals[i]) > ci) "tomato" else "gray30")
  }
}

# ── Jalankan & tampilkan ─────────────────────────────
max_lag <- 20

acf_vals  <- acf_manual(x,  max_lag)
pacf_vals <- pacf_manual(x, max_lag)

par(mfrow = c(1, 2))          # 2 panel berdampingan

plot_corr(acf_vals[-1],    # buang lag-0
          1:max_lag,
          title = "ACF Manual")

plot_corr(pacf_vals,
          1:max_lag,
          title = "PACF Manual")

par(mfrow = c(1, 1))          # kembalikan layout default