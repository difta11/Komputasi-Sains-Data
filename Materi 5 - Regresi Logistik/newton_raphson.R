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