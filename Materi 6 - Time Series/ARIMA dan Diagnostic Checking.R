install.packages("forecast")   # kalau belum ada
install.packages("tseries")

library(forecast)
library(tseries)

data(AirPassengers)
ts_data <- AirPassengers

plot(ts_data, main="Time Series Plot", col="blue")

adf.test(ts_data)

ts_diff <- diff(ts_data)
plot(ts_diff)
adf.test(ts_diff)

acf(ts_diff)
pacf(ts_diff)

model <- arima(ts_data, order = c(1,1,1))
summary(model)

model_auto <- auto.arima(ts_data)
summary(model_auto)

forecast_result <- forecast(model_auto, h = 12)  # prediksi 12 periode ke depan
plot(forecast_result)

checkresiduals(model_auto)

#DIAGNOSTIC CHECKING
model <- auto.arima(ts_data)

residuals_model <- residuals(model)

mean_res <- mean(residuals_model)
var_res  <- var(residuals_model)

mean_res
var_res

acf(residuals_model, main="ACF Residual")

Box.test(residuals_model, lag = 20, type = "Ljung-Box")

if(Box.test(residuals_model, lag=20, type="Ljung-Box")$p.value > 0.05){
  cat("Residual bersifat white noise, model ARIMA sudah baik")
} else {
  cat("Residual belum white noise, model ARIMA belum optimal")
}