install.packages("readxl")

setwd("D:/Kuliah/matkul/Komstat (R)")
getwd()
library(readxl)
lokasi <- "D:/Kuliah/matkul/Komstat (R)/data_tinggi.xlsx"
data1 <- read_xlsx(lokasi)
data2 <- read_xlsx("data_tinggi.xlsx")
data1
data2

# data splitting
# memisahkan data
nama <- data$Nama
usia <- data$Usia
tinggi <- data$Tinggi

# jika tidak ada nama kolom pada file tersebut maka gunakan
nama <- data[, 1]
usia <- data[, 2]
tinggi <- data[, 3]

# data manipulation
data=c(1:10)
data[-1] #menghilangkan index 1
data[-c(1:5)] #menghilangkan index 1 sampai 5
data[-1,-2] #error karena vector hanya 1 dimensi

mat=matrix(c(1:9),3,byrow = T)
mat[-1,-2] #menghilangkan baris 1 dan kolom 2
mat[-2,] #menghilangkan baris 2
mat[,-3] #menghilangkan kolom 3
mat[-1] #menghilangkan index 1 dan merubah menjadi vector

#Membuat vektor-vektor
vektor1 <- c(1, 2, 3)
vektor2 <- c(4, 5, 6)
vektor3 <- c(7, 8, 9)

#Menggabungkan vektor-vektor menjadi matriks berdasarkan penambahan baris
matriks_rbind <- rbind(vektor1, vektor2, vektor3)
#Menggabungkan vektor-vektor menjadi matriks berdasarkan penambahan kolom
matriks_cbind <- cbind(vektor1, vektor2, vektor3)

# data filtering
# Contoh data numerik
data <- c(2, 5, 8, 10, 3, 6)

# Filter data yang lebih besar dari 5
filtered_data <- data[which(data > 5)]
print(filtered_data)

data <- c(-2, 5, -3, 7, 0, 10)
filtered_data <- data[which(...)]
print(filtered_data)

data <- c("apel", "nanas", "pisang", "jeruk", "apel")

# Filter data yang tepat sama dengan "apel"
filtered_data <- data[which(data == "apel")]
print(filtered_data)

#Menggabungkan data
kolom1 = c('Kereta','Kapal','Mobil','Motor','Sepeda','Jalan')
kolom2 = c(44,15,25,18,40,32)
kolom3 = c('Male','Male','Female','Male','Male','Female')
data = data.frame(kolom1,kolom2,kolom3)

#Mengubah nama kolom
names(data)[names(data)=='kolom1']='Kendaraan'
names(data)[names(data)=='kolom2']='Usia'
names(data)[names(data)=='kolom3']='Gender'
data

#Memfilter data
data[which(data$Gender=='Male'),] #Jika ingin mengeluarkan Gender Male pada semua kolom
data[which(data$Usia<30),2] #Jika ingin mengeluarkan Usia < 30 pada kolom Usia saja
data[which(data$Gender=='Female'),-1] ##Jika ingin mengeluarkan Gender Female tanpa kolom Kendaraan
