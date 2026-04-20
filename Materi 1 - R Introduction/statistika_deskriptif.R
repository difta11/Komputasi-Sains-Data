# mean
x=c(2,9,2,3,4,2,1,7,6,7)
rata2=function(x){
  jumlah=0
  n=length(x)
  for (i in 1:n) {
    jumlah=jumlah+x[i]
  }
  hasil=jumlah/n
  return(hasil)
}

rata2(x)
mean(x) #function yang tersedia di r

# sort
urutkan = function(data){
  m = length(data)
  temp = NULL
  for(i in 1:(m-1)){
    for (j in (i+1):m){
      if(data[j] < data[i]){
        temp = data[i]
        data[i] = data[j]
        data[j] = temp
      }
    }
  }
  return(data)
}

test <- c(4,1,2,1)
test_urut <- urutkan(test)
test_urut

sort(test) #function yang tersedia di r

# median 
median <- function(x) {
  x <- sort(x)  # Urutkan data terlebih dahulu
  n <- length(x)  # Hitung jumlah elemen
  
  if (n %% 2 == 1) {
    return(x[(n + 1) / 2])  # Jika ganjil, ambil nilai tengah
  } else {
    return((x[n/2]+x[(n+2)/2)])/2)  # Jika genap, ambil rata-rata dua nilai tengah
  }
}

# Contoh penggunaan
data <- c(7, 1, 3, 5, 9)
median(data)  # Output: 5

data2 <- c(7, 1, 3, 5, 9, 6)
median(data2)  # Output: 5.5

# varian
x=c(2,9,2,3,4,2,1,7,6,7)
varian=function(x){
  n=length(x)
  jumlah=0
  for (i in 1:n) {
    jumlah=jumlah+(x[i]-mean(x))^2
  }
  hasil=jumlah/(n-1)
  return(hasil)
}

varian(x)
var(x) #function yang tersedia di r

# standar deviasi
x=c(2,9,2,3,4,2,1,7,6,7)
sdev=function(x){
  n=length(x)
  jumlah=0
  for (i in 1:n) {
    jumlah=jumlah+(x[i]-rata2(x))^2
  }
  hasil=sqrt(jumlah/(n-1))
  return(hasil)
}

sdev(x)
sd(x) #function yang tersedia di r

# korelasi
x=c(2,9,2,3,4,2,1,7,6,7)
y=c(1,8,4,3,6,3,6,8,5,6)
kor=function(x,y){
  n=length(x)
  a=0
  b1=0
  b2=0
  for (i in 1:n) {
    a=a+(x[i]-mean(x))*(y[i]-mean(y))
    b1=b1+(x[i]-mean(x))^2
    b2=b2+(y[i]-mean(y))^2
  }
  hasil=a/sqrt(b1*b2)
  return(hasil)
}

kor(x,y)
cor(x,y) #function yang tersedia di r

# modus
modus=function(x){
  unik=unique(x)
  hasil=unik[which.max(tabulate(match(x,unik)))]
  return(hasil)
}

x=c(2,9,2,3,4,2,1,7,6,7)
modus(x)

# range
rang <- function(x){
  n <- length(x)
  x <- sort(x)
  max <- x[n]
  min <- x[1]
  hasil <- max-min
  return(hasil)
}

x=c(2,9,2,3,4,2,1,7,6,7)
rang(x)

# iqr 
hitung_median <- function(x) {
  n <- length(x)
  x <- sort(x) 
  if (n %% 2 == 1) {
    return(x[(n + 1) / 2])
  } else {
    return((x[n / 2] + x[(n / 2) + 1]) / 2)
  }
}

hitung_iqr <- function(x) {
  x <- sort(x)
  n <- length(x)
  mid <- floor(n / 2)
  
  if (n %% 2 == 0) {
    kelompok_bawah <- x[1:mid]
    kelompok_atas <- x[(mid + 1):n]
  } else {
    kelompok_bawah <- x[1:(mid)]
    kelompok_atas <- x[(mid + 2):n]
  }
  
  q1 <- hitung_median(kelompok_bawah)
  q3 <- hitung_median(kelompok_atas)
  
  return(q3 - q1)
}

x <- c(10, 2, 38, 23, 38, 23, 21)
hitung_iqr(x)