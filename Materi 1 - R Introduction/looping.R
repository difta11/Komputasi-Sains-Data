# data frame
source <- c("Regression","Residual","Total")
isi_ss <- c(83.29, 11.87, 95.16)
isi_df <- c(5,9,14)
isi_MSS <- c(16.66, 1.32, NA)
isi_F <- c(12.62, NA, NA)
isi_pval <- c(0.00075, NA, NA)

tabel_anov <- data.frame(source, "SS"=isi_ss, "df"=isi_df, 
												"MSS"=isi_MSS, "F"=isi_F, "P Value"=isi_pval)
tabel_anov

# print() digunakan untuk mengeluarkan 1 variabel atau suatu kata yang diinginkan.
x <- c(1,2,3)
# Output menggunakan print
print("Variabel x :")
print(x)

x <- c(1,2,3)
#Output menggunakan print
print("Variabel x :")
print(x)

# paste() digunakan jika ingin mengeluarkan 1 atau lebih variabel/kata yang diinginkan, sesuai dengan jumlah data yang dimasukkan. paste() mengeluarkan output berupa string.
x <- c(1,2,3)
#Output menggunakan paste
paste("Variabel x :", x)

# return() hanya bisa digunakan jika ingin membuat suatu function, dan membuat variabel yang ada di dalam function tersebut dapat dioperasikan dalam function yang lain. Mirip dengan di C++.
x <- c(1,2,3)
#Output menggunakan return
variabel <- function(x){
  return(x+1)
}
variabel(x)

# cat() digunakan jika ingin mengeluarkan 1 atau lebih variabel/kata yang diinginkan, serta bisa menggunakan bantuan tab ataupun enter didalamnya. cat() tidak menampilkan indeks [1] pada outputnya, berbeda dengan print() dan paste()
x <- c(1,2,3)
y <- c(4,5,6)
#Output menggunakan cat
cat("Variabel x\t:", x,"\nVariabel y\t:", y)

# looping
n <- 10
#Looping for (+)
for(i in 1:n){
  print(i*2)
}

#Looping for (-)
for(j in 20:n){
  print(j)
}

n <- 10
i <- 1
j <- 20
#Looping while (+)
while(i <= n){
  print(i)
  i <- i+1
}

#Looping while (-)
while(j >= n){
  print(j)
  j <- j-1
}

i <- 1
j <- 20
#Looping repeat (+)
repeat{
  print(i)
  i <- i+1
  if(i > 10){
    break
  }
}

#Looping repeat (-)
repeat{
  print(j)
  j <- j-1
  if(j < 10){
    break
  }
}

#if else statement
nilai <- 75

if (nilai >= 80) {
  print("Nilai Anda A")
} else if (nilai >= 70) {
  print("Nilai Anda B")
} else if (nilai >= 60) {
  print("Nilai Anda C")
} else {
  print("Nilai Anda D")
}

# function
tambah <- function(a, b) {
  hasil <- a + b
  return(hasil)
}

# Panggil function dengan argumen
tambah(5, 3)