# ========== R PACKAGE ===========

# A. PACKAGE TAMBAHAN

# 1. readxl
#install.packages("readxl")
library(readxl)

data_excel <- read_xlsx("namafile.xlsx")
head(data_excel)

# 2. dplyr
#install.packages("dplyr")
library(dplyr)

data(iris)
df <- iris

df_bersih <- distinct(df)
head(df_bersih)

df %>% filter(Sepal.Length > 5)
df %>% select(Sepal.Length, Species)
df %>% mutate(Sepal_Ratio = Sepal.Length / Sepal.Width)

# 3. tidyr
#install.packages("tidyr")
library(tidyr)

df <- data.frame(
  nama = c("A", "B"),
  nilai = c("80,90", "70,85")
)
separate_wider_delim(df, nilai, delim = ",", 
                     names = c("uts", "uas"))

# 4. tseries
#install.packages("tseries")
library(tseries)

data_ts <- AirPassengers
adf.test(data_ts)

# 5. forecast
#install.packages("forecast")
library(forecast)

data_ts <- AirPassengers

lambda <- BoxCox.lambda(data_ts)
lambda

model_auto <- auto.arima(data_ts)
summary(model_auto)

# 6. ggplot2
#install.packages("ggplot2")
library(ggplot2)

ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, 
                 color=Species)) + geom_point()

ggplot(iris, aes(x=Sepal.Length)) +
  geom_histogram()

ggplot(iris, aes(x=Species, y=Sepal.Length)) +
  geom_boxplot()

# B. PACKAGE BAWAAN R
# 7. stats
model_lm <- lm(mpg ~ wt, data = mtcars)
summary(model_lm)

model_glm <- glm(am ~ hp + wt, data = mtcars, family = binomial)
summary(model_glm)

model_arima <- arima(AirPassengers, order = c(1,1,1))
acf(AirPassengers)
pacf(AirPassengers)
Box.test(residuals(model_arima), lag = 10, type = "Ljung-Box")
pca_model <- prcomp(iris[,1:4], scale = TRUE)
summary(pca_model)

# 8. datasets
data()

data(iris)
head(iris)

# 9. graphics
plot(AirPassengers, type = "l")
boxplot(iris$Sepal.Length) 

# 10. base
x <- c(2,4,6,8)
mean(x)
sqrt(16)

mat <- matrix(1:4, 2, 2)
t(mat)
solve(mat)

data(iris)
sum(duplicated(iris))
colSums(is.na(iris))

iris$kategori <- cut(iris$Sepal.Length, breaks = 3,
                     labels = c("Low", "Medium", "High"))
head(iris$kategori)

# KELOMPOK PACKAGE/FUNGSI BERDASARKAN TOPIK 

# preprocessing
library(dplyr)
df <- distinct(df)

cor_matrix <- cor(iris[,1:4])
library(corrplot)
corrplot(cor_matrix)
 

# regresi linear
model <- lm(y ~ x, data = df)
summary(model)

# regresi logistik
model <- glm(am ~ hp + wt, data = mtcars, family = binomial)
summary(model)

# time series
library(tseries)
library(forecast)

adf.test(AirPassengers)
lambda <- BoxCox.lambda(AirPassengers)
model <- auto.arima(AirPassengers)
summary(model)