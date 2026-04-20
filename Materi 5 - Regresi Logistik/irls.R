data(mtcars)

# Membuat Matriks X (Tambahkan kolom angka 1 untuk Intercept)
X <- as.matrix(cbind(Intercept = 1, wt = mtcars$wt, hp = mtcars$hp))

# Membuat Vektor Y (Target: am)
Y <- as.matrix(mtcars$am)

# ==========================================
# Inisialisasi
# ==========================================
# Tebakan awal untuk Beta (diisi angka 0 semua)
beta_irls <- matrix(0, nrow = ncol(X), ncol = 1) 

toleransi <- 1e-6    # Batas berhenti jika perubahan beta sangat kecil
maks_iter <- 20      # Maksimal iterasi
selisih <- 100       # Variabel penyimpan perubahan beta (dimulai dari > toleransi)
iterasi <- 0         # Penghitung iterasi

# ==========================================
# IRLS
# ==========================================
while(selisih > toleransi && iterasi < maks_iter) {
  # Hitung Vektor Probabilitas (pi)
  # pi = 1/(1+exp(-XB))
  pi_i <- 1 / (1 + exp(-X %*% beta_irls))
  
  # Buat Matriks Bobot Diagonal (W)
  # W = pi * (1 - pi)
  w <- as.vector(pi_i * (1 - pi_i))
  W <- diag(as.vector(pi_i * (1 - pi_i)))
  
	# Hitung Working Response (z)
  # z = X*beta + (Y - pi) / w (ini vektor w kecil -> diagonalnya aj)
  z <- X %*% beta_irls + (Y-pi_i) / w
  
  # Update Parameter Beta (Rumus WLS)
  # Beta_baru = (X^T * W * X)^-1 * (X^T * W * z)
  beta_baru <- solve(t(X) %*% W %*% X)  %*% (t(X) %*% W %*% z) 
  
  # Cek Konvergensi
  selisih <- max(abs(beta_baru - beta_irls))
  
  # Simpan nilai beta baru
  beta_irls <- beta_baru
  iterasi <- iterasi + 1
  
  # Progress tiap iterasi
  cat(sprintf("Iterasi %d | Selisih: %f\n", iterasi, selisih))
}
print(beta_irls)