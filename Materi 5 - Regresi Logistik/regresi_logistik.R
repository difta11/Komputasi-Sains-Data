# ============================================================
# REGRESI LOGISTIK BINER DI R
# Contoh kasus: prediksi kelulusan mahasiswa
# Y = lulus (0 = tidak, 1 = ya)
# X1 = jam_belajar
# X2 = kehadiran
# ============================================================

# ---------------------------
# 1. MEMBUAT DATA CONTOH
# ---------------------------
data <- data.frame(
  jam_belajar = c(2, 3, 4, 5, 6, 2, 1, 7, 8, 3, 4, 6, 5, 7, 2),
  kehadiran   = c(60, 65, 70, 75, 80, 55, 50, 85, 90, 68, 72, 78, 74, 88, 58),
  lulus       = c(0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0)
)

# Lihat data
print(data)

# Ubah variabel respon menjadi factor jika ingin dibaca sebagai kategori
data$lulus_factor <- factor(data$lulus, levels = c(0, 1), labels = c("Tidak", "Ya"))

# ---------------------------
# 2. EKSPLORASI DATA
# ---------------------------
str(data)
summary(data)

# Tabel frekuensi respon
table(data$lulus_factor)

# ---------------------------
# 3. MEMBANGUN MODEL REGRESI LOGISTIK
# ---------------------------
# Model:
# logit(P(Y=1)) = b0 + b1*jam_belajar + b2*kehadiran

model <- glm(lulus ~ jam_belajar + kehadiran,
             data = data,
             family = binomial(link = "logit"))

# Ringkasan model
summary(model)

# ---------------------------
# 4. MENAMPILKAN PERSAMAAN MODEL
# ---------------------------
coef_model <- coef(model)
cat("\nPersamaan model logit:\n")
cat("log(p / (1-p)) =",
    round(coef_model[1], 4),
    ifelse(coef_model[2] >= 0, " + ", " - "), abs(round(coef_model[2], 4)), "* jam_belajar",
    ifelse(coef_model[3] >= 0, " + ", " - "), abs(round(coef_model[3], 4)), "* kehadiran\n",
    sep = "")

# ---------------------------
# 5. ODDS RATIO
# ---------------------------
odds_ratio <- exp(coef(model))
cat("\nOdds Ratio:\n")
print(odds_ratio)

# Confidence Interval Odds Ratio
cat("\nConfidence Interval Odds Ratio:\n")
print(exp(confint(model)))

# ---------------------------
# 6. NILAI PROBABILITAS PREDIKSI
# ---------------------------
data$prob_prediksi <- predict(model, type = "response")
print(data[, c("jam_belajar", "kehadiran", "lulus", "prob_prediksi")])

# ---------------------------
# 7. KLASIFIKASI HASIL PREDIKSI
# ---------------------------
# Gunakan cut-off 0.5
data$prediksi_kelas <- ifelse(data$prob_prediksi >= 0.5, 1, 0)

cat("\nHasil klasifikasi:\n")
print(data[, c("lulus", "prob_prediksi", "prediksi_kelas")])

# ---------------------------
# 8. CONFUSION MATRIX
# ---------------------------
conf_matrix <- table(
  Aktual = data$lulus,
  Prediksi = data$prediksi_kelas
)

cat("\nConfusion Matrix:\n")
print(conf_matrix)

# ---------------------------
# 9. MENGHITUNG AKURASI, PRESISI, RECALL
# ---------------------------
TP <- conf_matrix["1", "1"]
TN <- conf_matrix["0", "0"]
FP <- conf_matrix["0", "1"]
FN <- conf_matrix["1", "0"]

akurasi <- (TP + TN) / sum(conf_matrix)
presisi <- TP / (TP + FP)
recall  <- TP / (TP + FN)
specificity <- TN / (TN + FP)

cat("\nEvaluasi Model:\n")
cat("Akurasi    =", round(akurasi, 4), "\n")
cat("Presisi    =", round(presisi, 4), "\n")
cat("Recall     =", round(recall, 4), "\n")
cat("Specificity=", round(specificity, 4), "\n")

# ---------------------------
# 10. UJI SIGNIFIKANSI MODEL
# ---------------------------
cat("\nUji signifikansi model (anova):\n")
print(anova(model, test = "Chisq"))

# ---------------------------
# 11. PREDIKSI DATA BARU
# ---------------------------
data_baru <- data.frame(
  jam_belajar = c(3, 5, 7),
  kehadiran   = c(65, 75, 90)
)

data_baru$prob_lulus <- predict(model, newdata = data_baru, type = "response")
data_baru$prediksi_kelas <- ifelse(data_baru$prob_lulus >= 0.5, 1, 0)

cat("\nPrediksi data baru:\n")
print(data_baru)

# ---------------------------
# 12. VISUALISASI SEDERHANA
# ---------------------------
# Plot probabilitas prediksi vs jam_belajar
plot(data$jam_belajar, data$prob_prediksi,
     pch = 19,
     xlab = "Jam Belajar",
     ylab = "Probabilitas Lulus",
     main = "Probabilitas Prediksi Regresi Logistik")

# ---------------------------
# 13. VISUALISASI DENGAN ggplot2
# ---------------------------
if (!require(ggplot2)) install.packages("ggplot2")
library(ggplot2)

ggplot(data, aes(x = jam_belajar, y = prob_prediksi, color = lulus_factor)) +
  geom_point(size = 3) +
  labs(
    title = "Probabilitas Kelulusan",
    x = "Jam Belajar",
    y = "Probabilitas Lulus",
    color = "Status"
  ) +
  theme_minimal()

# ---------------------------
# 14. INTERPRETASI SINGKAT OTOMATIS
# ---------------------------
cat("\nInterpretasi singkat:\n")
for (i in 2:length(coef_model)) {
  nama_var <- names(coef_model)[i]
  nilai_or <- exp(coef_model[i])

  cat("- Variabel", nama_var,
      "memiliki odds ratio =", round(nilai_or, 4), "\n")

  if (nilai_or > 1) {
    cat("  Artinya, kenaikan 1 unit pada", nama_var,
        "meningkatkan peluang lulus.\n")
  } else {
    cat("  Artinya, kenaikan 1 unit pada", nama_var,
        "menurunkan peluang lulus.\n")
  }
}

# ---------------------------
# 15. MENYIMPAN HASIL KE CSV
# ---------------------------
write.csv(data, "hasil_regresi_logistik.csv", row.names = FALSE)
cat("\nFile hasil_regresi_logistik.csv berhasil disimpan.\n")