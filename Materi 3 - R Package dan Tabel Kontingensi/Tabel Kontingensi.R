# ============ TABEL KONTINGENSI ===========

# Membuat matriks frekuensi
tab <- matrix(c(30, 20,
                25, 35),
              nrow = 2,
              byrow = TRUE)

# Memberi nama baris dan kolom
rownames(tab) <- c("Laki-laki", "Perempuan")
colnames(tab) <- c("IPA", "IPS")

tab

#Menghitung total baris
row_total <- rowSums(tab)
row_total

#Menghitung total kolom
col_total <- colSums(tab)
col_total

#Menghitung total keseluruhan
n <- sum(tab)
n

#Menghitung frekuensi harapan
expected <- outer(row_total, col_total) / n
expected
#dapat juga menggunakan code berikut:
round(expected, 2)

#Menghitung statistik Chi-square secara manual
chi_manual <- sum((tab - expected)^2 / expected)
chi_manual

#Menghitung derajat bebas
r <- nrow(tab)
c <- ncol(tab)

df <- (r - 1) * (c - 1)
df

#Menghitung p-value
p_value <- pchisq(chi_manual, df = df, lower.tail = FALSE)
p_value

#Dengan menggunakan fungsi bawaan R
chisq.test(tab) #menghitung nilai chi-square

hasil <- chisq.test(tab)
hasil$expected #untuk melihat frekuensi harapan dari hasil uji

hasil$residuals #untuk melihat residual

#Menghitung proporsi pada tabel kontingensi
prop.table(tab) #proporsi keseluruhan

prop.table(tab, margin = 1) #proporsi per baris

prop.table(tab, margin = 2) #proporsi per kolom

#Data mentah dalam data frame:
data <- data.frame(
  gender = c("L", "L", "P", "P", "L", "P", "L", "P"),
  jurusan = c("IPA", "IPS", "IPA", "IPS", "IPA", "IPS", "IPS", "IPA")
)

table(data$gender, data$jurusan)
