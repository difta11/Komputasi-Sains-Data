data(mtcars)

# Membuat Matriks X (Tambahkan kolom angka 1 untuk Intercept)
X <- as.matrix(cbind(Intercept = 1, wt = mtcars$wt, hp = mtcars$hp))

# Membuat Vektor Y (Target: am)
Y <- as.matrix(mtcars$am)

# ==========================================
# Inisialisasi
# ==========================================
# Tebakan awal untuk Beta (diisi angka 0 semua)
beta_nr <- matrix(0, nrow = ncol(X), ncol = 1) 

toleransi <- 1e-6    # Batas berhenti jika perubahan beta sangat kecil
maks_iter <- 20      # Maksimal iterasi 
selisih <- 100       # Variabel penyimpan perubahan beta (dimulai dari > toleransi)
iterasi <- 0         # Penghitung iterasi

# ==========================================
# Newton Rhapson
# ==========================================
while(selisih > toleransi && iterasi < maks_iter) {
  # Hitung Vektor Probabilitas (pi)
  # pi = 1/(1+exp(-XB))
  pi_i <- 1 / (1 + exp(-X %*% beta_nr))
  
  # Buat Matriks Bobot Diagonal (W)
  # W = pi * (1 - pi)
  W <- diag(as.vector(pi_i * (1 - pi_i)))
  
  # Gradien (U) = X^T (Y - pi)
  U <- t(X) %*% (Y-pi_i)
  
  # Hessian (H) = -X^T W X
  H <- -t(X) %*% W %*% X
  
  # Update Parameter Beta (Rumus Newton-Raphson)
  # Beta_baru = Beta_lama - (H_invers * U)
  beta_baru <- beta_nr - (solve(H) %*% U)
  
  # Cek Konvergensi
  selisih <- max(abs(beta_baru - beta_nr))
  
  # Simpan nilai beta baru
  beta_nr <- beta_baru
  iterasi <- iterasi + 1
  
  # Progress tiap iterasi
  cat(sprintf("Iterasi %d | Selisih: %f\n", iterasi, selisih))
}
print(beta_nr)


# ==========================================
# PERHITUNGAN STATISTIK INFERENSIAL
# ==========================================
  
var_beta <- solve(-H)

se_beta <- sqrt(diag(var_beta))

z_score <- beta_nr / se_beta

p_value <- 2 * (1 - pnorm(abs(z_score)))

summary_manual <- data.frame(
  Estimate = round(beta_nr, 4),
  Std.Error = round(se_beta, 4),
  z_value = round(z_score, 4),
  Pr_z = round(p_value, 4)
)

cat("\n--- Ringkasan Statistik (Manual Newton-Raphson) ---\n")
print(summary_manual)

# ==========================================
# VALIDASI DENGAN FUNGSI GLM() BAWAAN R
# ==========================================
model_r <- glm(am ~ wt + hp, data = mtcars, family = binomial(link = "logit"))

cat("\n--- Perbandingan dengan Fungsi glm() R ---\n")
print(coef(model_r))

selisih_validasi <- max(abs(beta_nr - coef(model_r)))
cat(sprintf("\nSelisih antara manual vs glm(): %e\n", selisih_validasi))

# ==========================================
# PERHITUNGAN LOG-LIKELIHOOD
# ==========================================
log_lik <- sum(Y * log(pi_i) + (1 - Y) * log(1 - pi_i))
cat(sprintf("Log-Likelihood: %f\n", log_lik))