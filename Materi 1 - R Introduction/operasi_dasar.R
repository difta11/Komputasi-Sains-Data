# mendefinisikan variabel
x <- 10
y = "Hello, world!"

# menampilkan nilai variabel
print(x)
print(y)

# operator aritmatika
35+19
98-67.9961
6*5
90/18
sqrt(144)
19^2
6%%2

#Contoh dalam bilangan kompleks
a <- 5+2i
b <- 3-7i

#Penjumlahan bilangan kompleks
hasil_penjumlahan <- a + b
print(hasil_penjumlahan)

#Pengurangan bilangan kompleks
hasil_pengurangan <- a - b
print(hasil_pengurangan)

g <- 6.889

print(g)
floor(g) #pembulatan ke nilai terendah selanjutnya
ceiling(g) #selalu membulatkan ke atas
trunc(g) #selalu membulatkan ke hanya nilai di kiri desimal
round(g) #pembulatan biasa
round(g,2) #pembulatan dengan mengatur angka di belakang koma

# array
num <- c(1,5,9)
num_1 <- 1:20

# sequence
seq <- 1:10
print(seq)

seq_1 <- seq(from=2, to=10, by=2)
print(seq_1)

seq_2 <- seq(from=3, to=10, length.out=5)
print(seq_2)

#Membuat vektor berdasarkan panjang vektor referensi
panjang = c(4,6,3,5,6,4)
seq(from = 3, to = 10, along.with = panjang)

seq_2 <- seq(from=3, to=10, length.out=5)
print(seq_2)

#Membuat vektor berdasarkan panjang vektor referensi
panjang = c(4,6,3,5,6,4)
seq(from = 3, to = 10, along.with = panjang)

# rep
a <- c(3,5,7)
rep(a, times=10) #mengulang angka 3,5,7 sebanyak 10 kali
rep(a, each=3) #mengulang masing-masing angka sebanyak 3 kali
rep(a, len=5) #mengulang angka hingga ada 5 elemen

rep1 <- rep(1:5, times = 3)
rep2 <- rep(1:5, each = 3)

# matriks
mat_1 <- matrix(1:9, nrow=3, ncol=3)
mat_2 <- matrix(c(1,3,2,5,4,7,6,9,8), 3, 3)

# Secara default, pengisian terjadi secara kolom (column-wise). Bisa diubah ke row-wise dengan byrow = TRUE 
mat_3 <- matrix(c(1,3,2,5,4,7,6,9,8), 3, 3, byrow=T)

#Mengakses elemen baris ke-2, kolom ke-3
mat[2,3]

#Mengakses seluruh baris ke-1
mat[1, ]

#Mengakses seluruh kolom ke-2
mat[ ,2]

x <- matrix(1:10,2,5,byrow=T)
x
dim(x)
x[1,2] #mencari elemen baris 1 kolom 2
x[2,5] #mencari elemen baris 2 kolom 5
x[2,] #mencari semua elemen di baris 2
x[,4] #mencari semua elemen di kolom 4

x2 <- matrix(1:9,3,3)
x2
x2[row(x2)==col(x2)] #nyari diagonal
diag(x2)

x3 <- matrix(1:4,2,2)
x3
x3.inv <- solve(x3)
x3.inv

x3.det <- det(x3)
x3.det

x3.tran <- t(x3)
x3.tran

x4 <- matrix(1:10,2,5)
x5 <- matrix(15:6,5,2)
x4
x5
x4%*%x5

# 1. Membuat dataframe
df <- data.frame(
  nama = c("A", "B", "C", "D"),
  nilai = c(80, 65, 90, 55)
)

print(df)

# 2. Looping dengan for
for (i in 1:nrow(df)) {
  cat("Mahasiswa:", df$nama[i], "- Nilai:", df$nilai[i], "\n")
}

# 3. If-else
x <- 10
if (x > 5) {
  print("benar")
} else {
  print("salah")
}


# 4. Membuat function
nilai <- 60

cek_status <- function(nilai) {
  if (nilai >= 75) {
    return("Lulus")
  } else {
    return("Tidak Lulus")
  }
}