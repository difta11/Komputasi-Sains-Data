# ============================================
# Visualisasi Mean (Rata-rata)
# ============================================

data <- c(1, 3, 7, -2, 6, -5, 4)
rata <- mean(data)

# --------------------------------------------
# 1. Dotplot + garis mean
# --------------------------------------------
stripchart(data,
           method = "stack",
           pch    = 19,
           col    = "steelblue",
           main   = "Dotplot Data dengan Garis Mean",
           xlab   = "Nilai")
abline(v = rata, col = "red", lwd = 2, lty = 2)
legend("topright", legend = paste("Mean =", rata),
       col = "red", lwd = 2, lty = 2)

# --------------------------------------------
# 2. Barplot nilai + garis mean
# --------------------------------------------
barplot(data,
        names.arg = paste("x", 1:length(data), sep = ""),
        col       = "steelblue",
        main      = "Barplot Data dengan Garis Mean",
        xlab      = "Observasi",
        ylab      = "Nilai")
abline(h = rata, col = "red", lwd = 2, lty = 2)
legend("topright", legend = paste("Mean =", rata),
       col = "red", lwd = 2, lty = 2)

# --------------------------------------------
# 3. Histogram + garis mean
# --------------------------------------------
hist(data,
     col    = "steelblue",
     border = "white",
     main   = "Histogram Data dengan Garis Mean",
     xlab   = "Nilai",
     ylab   = "Frekuensi")
abline(v = rata, col = "red", lwd = 2, lty = 2)
legend("topright", legend = paste("Mean =", rata),
       col = "red", lwd = 2, lty = 2)
