Regresi Linear & Non-Linear
================

------------------------------------------------------------------------

# Regresi Linear Sederhana

## Konsep Dasar

Regresi Linear adalah metode statistik yang digunakan untuk memodelkan
hubungan linear antara satu atau lebih variabel bebas (prediktor)
terhadap satu variabel terikat (respons). Tujuan utamanya ada dua:

- Memahami pola hubungan antar variabel
- Memprediksi nilai respons berdasarkan nilai prediktor yang diketahui

Ada dua jenis variabel dalam analisis ini:

- **Variabel bebas (independent variable)** — variabel yang
  mempengaruhi, disebut sebagai variabel $X$
- **Variabel terikat (dependent variable)** — variabel yang dipengaruhi,
  disebut sebagai variabel $Y$

------------------------------------------------------------------------

## Model Regresi

Model populasi regresi linear sederhana dinyatakan sebagai:

$$Y = \beta_0 + \beta_1 X + \epsilon$$

Karena parameter populasi $\beta_0$ dan $\beta_1$ tidak diketahui, maka
dilakukan estimasi menggunakan data sampel sehingga diperoleh model:

$$\hat{y} = b_0 + b_1 x$$

Keterangan:

- $Y$ : Nilai observasi ke-i dari variabel terikat
- $\hat{y}$ : nilai prediksi variabel terikat
- $\beta_0$ : intercept populasi (nilai $Y$ saat $X = 0$)
- $\beta_1$ : koefisien/slope populasi (perubahan $Y$ per satuan $X$)
- $\epsilon$ : error/residual populasi ke-i
- $b_0$ : Taksiran $\beta_0$ dari data sampel
- $b_1$ : Taksiran $\beta_1$ dari data sampel

------------------------------------------------------------------------

## Penaksir Parameter

Parameter $b_0$ dan $b_1$ diestimasi menggunakan metode **Ordinary Least
Squares (OLS)**, yaitu dengan meminimalkan jumlah kuadrat residual.
Rumusnya:

$$
\sum_{i=1}^{n} (Y_i - \hat{Y}_i)^2
$$

Hasil estimasi parameter $$
b_1 = \frac{\sum_{i=1}^{n} (X_i - \bar{X})(Y_i - \bar{Y})}{\sum_{i=1}^{n} (X_i - \bar{X})^2}
$$

Hasil estimasi parameter $$
b_0 = \bar{Y} - b_1 \bar{X}
$$

``` r
# Data input
x <- c(5, 2, 12, 9, 15, 6, 25, 16)
y <- c(64, 87, 50, 71, 44, 56, 42, 60)

# Jumlah observasi
n <- length(y)

# Hitung rata-rata manual
xbar <- sum(x) / n
ybar <- sum(y) / n

# Inisialisasi akumulator
suma <- 0  # numerator b1
sumb <- 0  # denominator b1

for (i in 1:n) {
  suma <- suma + (x[i] - xbar) * (y[i] - ybar)  # kovarian X dan Y
  sumb <- sumb + (x[i] - xbar)^2                 # variansi X
}

# Estimasi koefisien
b1 <- suma / sumb        # slope
b0 <- ybar - b1 * xbar  # intercept

cat("b0 (intercept):", b0, "\n")
```

    ## b0 (intercept): 76.66037

``` r
cat("b1 (slope)    :", b1, "\n")
```

    ## b1 (slope)    : -1.547588

``` r
cat("Model: Y_hat =", b0, "+", b1, "* X\n")
```

    ## Model: Y_hat = 76.66037 + -1.547588 * X

------------------------------------------------------------------------

## Prediksi dan Residual

Setelah mendapat $b_0$ dan $b_1$, nilai prediksi dan residual dihitung
sebagai:

$$\hat{Y}_i = b_0 + b_1 X_i$$

$$e_i = Y_i - \hat{Y}_i$$ Residual menunjukkan seberapa jauh nilai
aktual dari garis regresi. Semakin kecil residual, semakin baik
modelnya.

``` r
# Inisialisasi vektor
ytopi <- numeric(n)  # nilai prediksi
resid <- numeric(n)  # residual

for (i in 1:n) {
  ytopi[i] <- b0 + b1 * x[i]   # prediksi Y ke-i
  resid[i]  <- y[i] - ytopi[i] # residual ke-i
}

# Tampilkan tabel prediksi
hasil <- data.frame(
  X          = x,
  Y_aktual   = y,
  Y_prediksi = round(ytopi, 4),
  Residual   = round(resid, 4)
)
print(hasil)
```

    ##    X Y_aktual Y_prediksi Residual
    ## 1  5       64    68.9224  -4.9224
    ## 2  2       87    73.5652  13.4348
    ## 3 12       50    58.0893  -8.0893
    ## 4  9       71    62.7321   8.2679
    ## 5 15       44    53.4465  -9.4465
    ## 6  6       56    67.3748 -11.3748
    ## 7 25       42    37.9707   4.0293
    ## 8 16       60    51.8990   8.1010

------------------------------------------------------------------------

## Dekomposisi Sum of Squares

Total variasi pada $Y$ dapat dipecah menjadi dua bagian:

$$SST = SSR + SSE$$

- **SST** (Sum of Squares Total) — total variasi $Y$ dari rata-ratanya:
  $$SST = \sum_{i=1}^{n}(Y_i - \bar{Y})^2$$

- **SSR** (Sum of Squares Regression) — variasi yang dijelaskan oleh
  model: $$SSR = \sum_{i=1}^{n}(\hat{Y}_i - \bar{Y})^2$$

- **SSE** (Sum of Squares Error) — variasi yang tidak bisa dijelaskan
  model: $$SSE = \sum_{i=1}^{n}(Y_i - \hat{Y}_i)^2$$ \## Tabel ANOVA

| Source | Sum of Squares | df | Mean Square | F hitung |
|----|----|----|----|----|
| Regression | $SSR$ | $df_r = 1$ | $MSR = \frac{SSR}{df_r}$ | $\frac{MSR}{MSE}$ |
| Error | $SSE$ | $df_e = n-2$ | $MSE = \frac{SSE}{df_e}$ | \- |
| Total | $SST$ | $df_t = n-1$ | \- | \- |

``` r
ssr <- 0  # sum of squares regression
sse <- 0  # sum of squares error

for (i in 1:n) {
  ssr <- ssr + (ytopi[i] - ybar)^2  # deviasi prediksi dari rata-rata Y
  sse <- sse + (y[i] - ytopi[i])^2  # deviasi aktual dari prediksi
}

sst <- ssr + sse  # total sum of squares

# Degrees of freedom
dfr <- 1      # regresi: jumlah prediktor
dfe <- n - 2  # error: n dikurangi jumlah parameter (b0 dan b1)
dft <- n - 1  # total

# Mean squares
msr <- ssr / dfr  # mean square regression
mse <- sse / dfe  # mean square error

cat("SSR:", ssr, "\nSSE:", sse, "\nSST:", sst, "\n")
```

    ## SSR: 918.4935 
    ## SSE: 639.0065 
    ## SST: 1557.5

``` r
cat("MSR:", msr, "\nMSE:", mse, "\n")
```

    ## MSR: 918.4935 
    ## MSE: 106.5011

------------------------------------------------------------------------

## Koefisien Determinasi $R^2$

Koefisien determinasi digunakan untuk mengukur mengukur proporsi variasi
$Y$ yang bisa dijelaskan oleh model:

$$R^2 = \frac{SSR}{SST}$$

Untuk mengatasi kecenderungan $R^2$ yang meningkat saat jumlah variabel
bertambah, diguakan $R^2$ adjusted:

$$R^2_{adj} = 1 - \frac{(1- R^2)(n - 1 )}{n - k}$$

``` r
rsq  <- ssr / sst                                  # R-squared
radj <- rsq - (dfr * (1 - rsq)) / (n - dfr - 1)   # R-squared adjusted

cat("R-squared         :", round(rsq, 4), "\n")
```

    ## R-squared         : 0.5897

``` r
cat("R-squared Adjusted:", round(radj, 4), "\n")
```

    ## R-squared Adjusted: 0.5213

------------------------------------------------------------------------

## Uji Serentak (Uji F)

Uji F digunakan untuk menguji apakah model regresi secara keseluruhan
signifikan, artinya apakah minimal ada satu parameter (selain intercept)
yang berpengaruh nyata terhadap $Y$.

**Hipotesis:**

$H_0 : \beta_1 = 0$ (model tidak signifikan)

$H_1 : \beta_1 \neq 0$ (model signifikan)

**Statistik uji:**

$$F_{hitung} = \frac{MSR}{MSE}, \quad F_{tabel} = F_{(1-\alpha,\ dfr,\ dfe)}$$

Tolak $H_0$ jika $F_{hitung} > F_{tabel}$

``` r
alpha <- 0.05  # tingkat signifikansi

# Hitung F hitung
fhit <- msr / mse

# F tabel dari distribusi F
ftab <- qf(1 - alpha, dfr, dfe)

# Hitung p-value
pvalf <- round(1 - pf(fhit, dfr, dfe), 7)

# Keputusan
if (fhit > ftab) {
  tandaf <- ">"
  kep    <- "Tolak H0"
} else {
  tandaf <- "<"
  kep    <- "Gagal Tolak H0"
}

# Tabel ANOVA
tabel_anova <- data.frame(
  Source   = c("Regression", "Residual", "Total"),
  df       = c(dfr, dfe, dft),
  SS       = c(ssr, sse, sst),
  MS       = c(msr, mse, NA),
  F.Hitung = c(fhit, NA, NA),
  F.Tabel  = c(ftab, NA, NA),
  p.value  = c(pvalf, NA, NA)
)

print(tabel_anova)
```

    ##       Source df        SS       MS F.Hitung  F.Tabel   p.value
    ## 1 Regression  1  918.4935 918.4935 8.624264 5.987378 0.0260588
    ## 2   Residual  6  639.0065 106.5011       NA       NA        NA
    ## 3      Total  7 1557.5000       NA       NA       NA        NA

``` r
cat("\nKesimpulan: F hitung", tandaf, "F tabel ->", kep, "\n")
```

    ## 
    ## Kesimpulan: F hitung > F tabel -> Tolak H0

------------------------------------------------------------------------

## Uji Parsial (Uji t)

Uji t digunakan untuk menguji apakah masing-masing parameter ($b_0$ dan
$b_1$) secara individual signifikan.

**Hipotesis:**

$H_0 : \beta_i = 0$

$H_1 : \beta_i \neq 0, \quad i = 0, 1$

**Standard error koefisien:**

$$s(b_0) = \sqrt{MSE \cdot \frac{\sum_{i=1}^{n} x_i^2}{n \cdot \sum_{i=1}^{n}(x_i - \bar{x})^2}}$$

$$s(b_1) = \frac{\sqrt{MSE}}{\sqrt{\sum_{i=1}^{n}(x_i - \bar{x})^2}}$$

**Statistik uji:**

$$t_{hitung} = \frac{b}{s(b)}, \quad t_{tabel} = t_{\alpha/2,\ dfe}$$

Tolak $H_0$ jika $|t_{hitung}| > t_{tabel}$

``` r
# Hitung sum xi^2 dan sum (xi - xbar)^2 secara manual
sumb0 <- 0  # untuk s(b0): sum xi^2
sumb1 <- 0  # untuk s(b1): sum (xi - xbar)^2

for (i in 1:n) {
  sumb0 <- sumb0 + x[i]^2           # jumlah kuadrat xi
  sumb1 <- sumb1 + (x[i] - xbar)^2 # jumlah kuadrat deviasi xi
}

# Standard error koefisien
seb0 <- sqrt(mse * sumb0 / (n * sumb1))  # standard error b0
seb1 <- sqrt(mse / sumb1)                # standard error b1

# t hitung
thit0 <- b0 / seb0  # t hitung untuk intercept
thit1 <- b1 / seb1  # t hitung untuk koefisien

# t tabel (dua arah)
ttab <- qt(1 - alpha / 2, dfe)

# Hitung p-value (dua arah)
pval0 <- if (thit0 < 0) 2 * pt(thit0, dfe) else 2 * (1 - pt(thit0, dfe))
pval1 <- if (thit1 < 0) 2 * pt(thit1, dfe) else 2 * (1 - pt(thit1, dfe))

# Keputusan
kept0 <- if (pval0 <= alpha) "Tolak H0" else "Gagal Tolak H0"
kept1 <- if (pval1 <= alpha) "Tolak H0" else "Gagal Tolak H0"

# Tabel parsial
tabel_parsial <- data.frame(
  Variabel       = c("Intercept", "X"),
  Coefficient    = c(b0, b1),
  Standard.Error = c(seb0, seb1),
  T.Hitung       = c(thit0, thit1),
  T.Tabel        = c(ttab, ttab),
  p.value        = c(pval0, pval1),
  Keputusan      = c(kept0, kept1)
)

print(tabel_parsial)
```

    ##    Variabel Coefficient Standard.Error T.Hitung  T.Tabel     p.value Keputusan
    ## 1 Intercept   76.660365      6.9613273 11.01232 2.446912 3.33384e-05  Tolak H0
    ## 2         X   -1.547588      0.5269802 -2.93671 2.446912 2.60588e-02  Tolak H0

------------------------------------------------------------------------

## Confidence Interval Parameter

Interval kepercayaan menunjukkan rentang nilai yang kemungkinan besar
berisi nilai parameter populasi yang sebenarnya:

$$CI(\beta_i) = b_i \pm t_{tabel} \cdot s(b_i)$$

``` r
# Margin CI
ci0 <- ttab * seb0  # margin error b0
ci1 <- ttab * seb1  # margin error b1

cat("Lower 95%\tUpper 95%\n")
```

    ## Lower 95%    Upper 95%

``` r
cat("", b0 - ci0, "\t", b0 + ci0, "\n")
```

    ##  59.62661     93.69412

``` r
cat("", b1 - ci1, "\t", b1 + ci1, "\n")
```

    ##  -2.837062    -0.2581138

------------------------------------------------------------------------

## Syntax Full — Fungsi `rls()`

Seluruh langkah di atas dirangkum dalam satu fungsi `rls(y, x)` sebagai
berikut:

``` r
rls <- function(y, x) {

  # Persiapan
  n    <- length(y)
  xbar <- sum(x) / n  # rata-rata x
  ybar <- sum(y) / n  # rata-rata y

  # Penaksir parameter
  suma <- 0; sumb <- 0
  for (i in 1:n) {
    suma <- suma + (x[i] - xbar) * (y[i] - ybar)  # numerator b1
    sumb <- sumb + (x[i] - xbar)^2                 # denominator b1
  }
  b1 <- suma / sumb        # slope
  b0 <- ybar - b1 * xbar  # intercept

  # Prediksi dan sum of squares
  ytopi <- numeric(n); ssr <- 0; sse <- 0
  for (i in 1:n) {
    ytopi[i] <- b0 + b1 * x[i]            # nilai prediksi
    ssr      <- ssr + (ytopi[i] - ybar)^2 # sum squares regression
    sse      <- sse + (y[i] - ytopi[i])^2 # sum squares error
  }
  sst <- ssr + sse

  # Degrees of freedom dan mean squares
  dfr <- 1; dfe <- n - 2; dft <- n - 1
  msr <- ssr / dfr; mse <- sse / dfe

  # R-squared
  rsq  <- ssr / sst
  radj <- rsq - (dfr * (1 - rsq)) / (n - dfr - 1)

  # Uji serentak (uji F)
  alpha <- 0.05
  fhit  <- msr / mse
  ftab  <- qf(1 - alpha, dfr, dfe)
  pvalf <- round(1 - pf(fhit, dfr, dfe), 7)
  if (fhit > ftab) { tandaf <- ">"; kepf <- "Tolak H0"
  } else            { tandaf <- "<"; kepf <- "Gagal Tolak H0" }

  # Uji parsial (uji t)
  sumb0 <- 0; sumb1 <- 0
  for (i in 1:n) {
    sumb0 <- sumb0 + x[i]^2           # sum xi^2
    sumb1 <- sumb1 + (x[i] - xbar)^2 # sum (xi - xbar)^2
  }
  seb0  <- sqrt(mse * sumb0 / (n * sumb1))  # standard error b0
  seb1  <- sqrt(mse / sumb1)                # standard error b1
  thit0 <- b0 / seb0; thit1 <- b1 / seb1
  ttab  <- qt(1 - alpha / 2, dfe)
  pval0 <- if (thit0 < 0) 2 * pt(thit0, dfe) else 2 * (1 - pt(thit0, dfe))
  pval1 <- if (thit1 < 0) 2 * pt(thit1, dfe) else 2 * (1 - pt(thit1, dfe))
  kept0 <- if (pval0 <= alpha) "Tolak H0" else "Gagal Tolak H0"
  kept1 <- if (pval1 <= alpha) "Tolak H0" else "Gagal Tolak H0"
  ci0 <- ttab * seb0; ci1 <- ttab * seb1

  # ---- OUTPUT ----
  cat("Dari pengujian regresi linear sederhana yang dilakukan, menghasilkan output sebagai berikut :\n")
  cat("~~~~~~~~~~~~~~~~~~~~~~~~~\n")
  print(data.frame(
    Variabel = c("R\u00b2", "R\u00b2Adjusted", "Observations"),
    Nilai    = c(rsq, radj, n)
  ), row.names = FALSE)
  cat("~~~~~~~~~~~~~~~~~~~~~~~~~")

  cat("\nDilakukan Uji Serentak")
  cat("\nH0 : \u03b21 = 0")
  cat("\nH1 : \u03b21 \u2260 0")
  cat("\n-----------------------------TABEL ANOVA--------------------------------\n")
  print(data.frame(
    Source   = c("Regression", "Residual", "Total"),
    df       = c(dfr, dfe, dft),
    SS       = c(ssr, sse, sst),
    MS       = c(msr, mse, NA),
    F.Hitung = c(fhit, NA, NA),
    F.Tabel  = c(ftab, NA, NA),
    p.value  = c(pvalf, NA, NA)
  ), row.names = FALSE)
  cat("------------------------------------------------------------------------")
  cat("\nKesimpulan : Karena nilai F Hitung", tandaf, "F Tabel, maka keputusan", kepf)

  cat("\n\nLalu dilakukan Uji Parsial")
  cat("\nH0 : \u03b2i = 0, i = 0,1")
  cat("\nH1 : \u03b2i \u2260 0")
  cat("\n-------------------------------------------------------------------------\n")
  print(data.frame(
    Variabel       = c("Intercept", "X"),
    Coefficient    = c(b0, b1),
    Standard.Error = c(seb0, seb1),
    T.Hitung       = c(thit0, thit1),
    T.Tabel        = c(ttab, ttab),
    p.value        = c(pval0, pval1),
    Keputusan      = c(kept0, kept1)
  ), row.names = FALSE)
  cat("-------------------------------------------------------------------------")
  cat("\nLower 95%\tUpper 95%")
  cat("\n", b0 - ci0, "\t", b0 + ci0)
  cat("\n", b1 - ci1, "\t", b1 + ci1)
  cat("\n")
}

# Cara pakai
x <- c(5, 2, 12, 9, 15, 6, 25, 16)
y <- c(64, 87, 50, 71, 44, 56, 42, 60)
rls(y, x)
```

    ## Dari pengujian regresi linear sederhana yang dilakukan, menghasilkan output sebagai berikut :
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~
    ##      Variabel     Nilai
    ##            R² 0.5897229
    ##    R²Adjusted 0.5213434
    ##  Observations 8.0000000
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~
    ## Dilakukan Uji Serentak
    ## H0 : β1 = 0
    ## H1 : β1 ≠ 0
    ## -----------------------------TABEL ANOVA--------------------------------
    ##      Source df        SS       MS F.Hitung  F.Tabel   p.value
    ##  Regression  1  918.4935 918.4935 8.624264 5.987378 0.0260588
    ##    Residual  6  639.0065 106.5011       NA       NA        NA
    ##       Total  7 1557.5000       NA       NA       NA        NA
    ## ------------------------------------------------------------------------
    ## Kesimpulan : Karena nilai F Hitung > F Tabel, maka keputusan Tolak H0
    ## 
    ## Lalu dilakukan Uji Parsial
    ## H0 : βi = 0, i = 0,1
    ## H1 : βi ≠ 0
    ## -------------------------------------------------------------------------
    ##   Variabel Coefficient Standard.Error T.Hitung  T.Tabel     p.value Keputusan
    ##  Intercept   76.660365      6.9613273 11.01232 2.446912 3.33384e-05  Tolak H0
    ##          X   -1.547588      0.5269802 -2.93671 2.446912 2.60588e-02  Tolak H0
    ## -------------------------------------------------------------------------
    ## Lower 95%    Upper 95%
    ##  59.62661     93.69412
    ##  -2.837062    -0.2581138

------------------------------------------------------------------------

# Regresi Linear Berganda

## Model Umum

Regresi linear berganda merupakan perluasan dari regresi sederhana di
mana terdapat lebih dari satu variabel bebas untuk memprediksi $Y$:

$$Y = \beta_0 + \beta_1 X_1i + \beta_2 X_2i + \cdots + \beta_k X_ki + \epsilon{i}$$

$$\hat{y} = b_0 + b_1 x_1 + b_2 x_2 + \cdots + b_k x_k$$

------------------------------------------------------------------------

## Bentuk Matriks

Dengan banyaknya parameter, Model regresi dapat dituliskan dalam bentuk
matriks sebagai:

$$\mathbf{Y} = \begin{bmatrix} Y_1 \\ Y_2 \\ \vdots \\ Y_n \end{bmatrix}, \quad \mathbf{X} = \begin{bmatrix} 1 & X_{11} & \cdots & X_{1k} \\ 1 & X_{21} & \cdots & X_{2k} \\ \vdots & \vdots & \ddots & \vdots \\ 1 & X_{n1} & \cdots & X_{nk} \end{bmatrix}, \quad \boldsymbol{\beta} = \begin{bmatrix} \beta_0 \\ \beta_1 \\ \vdots \\ \beta_k \end{bmatrix}$$

------------------------------------------------------------------------

## Penaksir Parameter

Model populasi regresi linear sederhana dinyatakan sebagai:

$$\hat{\boldsymbol{\beta}} = \mathbf{b} = (X'X)^{-1}X'Y$$

Nilai prediksi dan residual:

$$\hat{Y} = Xb, \quad e = Y - \hat{Y}$$

Sum of squares dalam notasi matriks:

$$SSR = b'(X'Y) - n\bar{Y}^2$$

$$SSE = Y'Y - b'(X'Y)$$

Untuk uji serentak, uji parsial, CI, dan $R^2$ — rumusnya **sama
persis** dengan regresi sederhana, hanya $dfr = k-1$ dan $dfe = n-k$.

------------------------------------------------------------------------

## Syntax Full — Fungsi `regan()`

``` r
regan <- function(y, x) {

  # Persiapan matriks
  Y <- as.matrix(y)
  X <- as.matrix(cbind(1, x))  # tambah kolom 1 untuk intercept
  n <- dim(X)[1]               # jumlah observasi
  k <- dim(X)[2]               # jumlah kolom (termasuk intercept)

  # Estimasi parameter: b = (X'X)^-1 X'Y
  xtx <- solve(t(X) %*% X)  # invers dari (X'X)
  xty <- t(X) %*% Y          # X'Y
  b   <- xtx %*% xty          # vektor koefisien

  # Prediksi dan rata-rata Y
  ytopi <- X %*% b            # nilai prediksi Y
  ybar  <- sum(y) / n         # rata-rata Y

  # Sum of squares (formula matriks)
  ssr <- as.numeric(t(b) %*% xty - n * ybar^2)  # SSR = b'(X'Y) - n*ybar^2
  sse <- as.numeric(t(Y) %*% Y   - t(b) %*% xty) # SSE = Y'Y - b'(X'Y)
  sst <- ssr + sse

  # Degrees of freedom dan mean squares
  dfr <- k - 1; dfe <- n - k; dft <- dfr + dfe
  msr <- ssr / dfr; mse <- sse / dfe

  # R-squared
  rsq  <- ssr / sst
  radj <- rsq - (dfr * (1 - rsq)) / (n - dfr - 1)

  # Uji serentak (uji F)
  alpha <- 0.05
  fhit  <- msr / mse
  ftab  <- qf(1 - alpha, dfr, dfe)
  pvalf <- round(1 - pf(fhit, dfr, dfe), 7)
  if (fhit > ftab) { tandaf <- ">"; kepf <- "Tolak H0"
  } else            { tandaf <- "<"; kepf <- "Gagal Tolak H0" }

  # Uji parsial (uji t)
  sb   <- sqrt(mse) * sqrt(diag(xtx))  # standard error tiap koefisien
  thit <- as.vector(b) / sb             # t hitung tiap koefisien
  ttab <- qt(1 - alpha / 2, dfe)        # t tabel (dua arah)

  pval_t   <- numeric(k); kept     <- character(k)
  ci_lower <- numeric(k); ci_upper <- numeric(k)
  for (i in 1:k) {
    pval_t[i]   <- if (thit[i] < 0) 2 * pt(thit[i], dfe) else 2 * (1 - pt(thit[i], dfe))
    kept[i]     <- if (pval_t[i] <= alpha) "Tolak H0" else "Gagal Tolak H0"
    ci_lower[i] <- as.vector(b)[i] - ttab * sb[i]  # batas bawah CI
    ci_upper[i] <- as.vector(b)[i] + ttab * sb[i]  # batas atas CI
  }

  var_names <- c("Intercept", paste0("X", 1:(k - 1)))
  regresi   <- if (k > 2) "berganda" else "sederhana"

  # ---- OUTPUT ----
  cat("Dari pengujian regresi linear", regresi, "yang dilakukan, menghasilkan output sebagai berikut :\n")
  cat("~~~~~~~~~~~~~~~~~~~~~~~~~\n")
  print(data.frame(
    Variabel = c("R\u00b2", "R\u00b2Adjusted", "Observations"),
    Nilai    = c(rsq, radj, n)
  ), row.names = FALSE)
  cat("~~~~~~~~~~~~~~~~~~~~~~~~~")

  cat("\nDilakukan Uji Serentak")
  cat("\nH0 : ")
  for (i in 1:(k - 1)) cat(paste0("\u03b2", i, " = "))
  cat("0")
  cat("\nH1 : \u03b2i \u2260 0, i = ")
  cat(paste(1:(k - 1), collapse = ","))
  cat("\n-----------------------------TABEL ANOVA--------------------------------\n")
  print(data.frame(
    Source   = c("Regression", "Residual", "Total"),
    df       = c(dfr, dfe, dft),
    SS       = c(ssr, sse, sst),
    MS       = c(msr, mse, NA),
    F.Hitung = c(fhit, NA, NA),
    F.Tabel  = c(ftab, NA, NA),
    p.value  = c(pvalf, NA, NA)
  ), row.names = FALSE)
  cat("------------------------------------------------------------------------")
  cat("\nKesimpulan : Karena nilai F Hitung", tandaf, "F Tabel, maka keputusan", kepf)

  cat("\n\nLalu dilakukan Uji Parsial")
  cat("\nH0 : \u03b2i = 0, i = ")
  cat(paste(0:(k - 1), collapse = ","))
  cat("\nH1 : \u03b2i \u2260 0")
  cat("\n-------------------------------------------------------------------------\n")
  print(data.frame(
    Variabel       = var_names,
    Coefficient    = as.vector(b),
    Standard.Error = sb,
    T.Hitung       = thit,
    T.Tabel        = rep(ttab, k),
    p.value        = pval_t,
    Keputusan      = kept
  ), row.names = FALSE)
  cat("-------------------------------------------------------------------------")
  cat("\nLower 95%\tUpper 95%")
  for (i in 1:k) cat("\n", ci_lower[i], "\t", ci_upper[i])
  cat("\n")
}

# Cara pakai
x1 <- c(1, 3, 5, 7, 9, 2, 4, 6, 8, 10)
x2 <- c(80, 75, 70, 65, 60, 85, 78, 72, 68, 55)
y  <- c(30, 35, 40, 45, 50, 32, 38, 43, 48, 55)
regan(y, cbind(x1, x2))
```

    ## Dari pengujian regresi linear berganda yang dilakukan, menghasilkan output sebagai berikut :
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~
    ##      Variabel    Nilai
    ##            R²  0.99405
    ##    R²Adjusted  0.99235
    ##  Observations 10.00000
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~
    ## Dilakukan Uji Serentak
    ## H0 : β1 = β2 = 0
    ## H1 : βi ≠ 0, i = 1,2
    ## -----------------------------TABEL ANOVA--------------------------------
    ##      Source df         SS          MS F.Hitung  F.Tabel p.value
    ##  Regression  2 586.887128 293.4435642 584.7367 4.737414       0
    ##    Residual  7   3.512872   0.5018388       NA       NA      NA
    ##       Total  9 590.400000          NA       NA       NA      NA
    ## ------------------------------------------------------------------------
    ## Kesimpulan : Karena nilai F Hitung > F Tabel, maka keputusan Tolak H0
    ## 
    ## Lalu dilakukan Uji Parsial
    ## H0 : βi = 0, i = 0,1,2
    ## H1 : βi ≠ 0
    ## -------------------------------------------------------------------------
    ##   Variabel Coefficient Standard.Error   T.Hitung  T.Tabel      p.value
    ##  Intercept 31.20436646     6.46204225  4.8288707 2.364624 1.901937e-03
    ##         X1  2.52547549     0.22685016 11.1327912 2.364624 1.050198e-05
    ##         X2 -0.04935709     0.07446721 -0.6628029 2.364624 5.286696e-01
    ##       Keputusan
    ##        Tolak H0
    ##        Tolak H0
    ##  Gagal Tolak H0
    ## -------------------------------------------------------------------------
    ## Lower 95%    Upper 95%
    ##  15.92406     46.48467
    ##  1.98906      3.061891
    ##  -0.2254441   0.1267299

------------------------------------------------------------------------

# Regresi Non-Linear

## Konsep Dasar

Regresi non-linear digunakan ketika hubungan antara variabel independen
(X) dan dependen (Y) tidak dapat dijelaskan dengan garis lurus,
melainkan **membentuk pola kurva** seperti eksponensial, logaritmik,
atau polinomial. Strategi utamanya adalah **linearisasi**,
mentransformasi model non-linear ke bentuk linear agar bisa diselesaikan
dengan OLS biasa.

------------------------------------------------------------------------

## Perbedaan regresi non-linear dengan regresi linear:

- Perubahan Y tidak konstan terhadap perubahan X
- Hubungan bisa melengkung (curved relationship)
- Interpretasi efek X terhadap Y bisa berubah tergantung nilai X

------------------------------------------------------------------------

## Overview Model

Tiga bentuk umum regresi non-linear:

- Eksponensial: pertumbuhan cepat
- Polinomial: pola naik-turun
- Logaritmik: cepat di awal, lalu melambat

------------------------------------------------------------------------

## Model Eksponensial

Model eksponensial digunakan saat $Y$ tumbuh atau menyusut secara
proporsional terhadap $X$.

**Contoh:**

- Pertumbuhan populasi
- Penyebaran data meningkat cepat

**Model asli:**

$$Y = \alpha \cdot e^{\beta X}$$

**Linearisasi** dengan mengambil $\ln$ di kedua sisi:

$$\ln(Y) = \ln(\alpha) + \beta X$$

Misalkan $Y^* = \ln(Y)$ dan $A = \ln(\alpha)$, maka modelnya menjadi
linear biasa:

$$Y^* = A + \beta X$$

Setelah estimasi $b_0$ dan $b_1$ diperoleh, konversi balik:

$$\hat{Y} = e^{b_0} \cdot e^{b_1 X}$$

**Interpretasi:** Setiap kenaikan $X$ sebesar 1 satuan, $Y$ berubah
sebesar $(e^{b_1} - 1) \times 100\%$.

``` r
nonlinear_eksponen <- function(y, x) {

  n      <- length(x)
  y_star <- log(y)           # linearisasi: Y* = ln(Y)
  xbar   <- sum(x) / n
  ys_bar <- sum(y_star) / n

  # Penaksir parameter pada skala ln(Y)
  suma <- 0; sumb <- 0
  for (i in 1:n) {
    suma <- suma + (x[i] - xbar) * (y_star[i] - ys_bar)  # numerator b1
    sumb <- sumb + (x[i] - xbar)^2                        # denominator b1
  }
  b1 <- suma / sumb
  b0 <- ys_bar - b1 * xbar
  alpha_hat <- exp(b0)  # konversi balik intercept ke skala asli

  # Prediksi dan SS pada skala ln(Y)
  ytopi_star <- numeric(n); sse_s <- 0; sst_s <- 0
  for (i in 1:n) {
    ytopi_star[i] <- b0 + b1 * x[i]
    sse_s <- sse_s + (y_star[i] - ytopi_star[i])^2
    sst_s <- sst_s + (y_star[i] - ys_bar)^2
  }
  ssr_s <- sst_s - sse_s
  dfr <- 1; dfe <- n - 2; dft <- n - 1
  msr <- ssr_s / dfr; mse <- sse_s / dfe
  rsq  <- ssr_s / sst_s
  radj <- rsq - (dfr * (1 - rsq)) / (n - dfr - 1)

  # AIC (skala ln)
  aic <- n * log(sse_s / n) + 2 * (dfr + 1)

  # Uji serentak
  alpha_uji <- 0.05
  fhit  <- msr / mse
  ftab  <- qf(1 - alpha_uji, dfr, dfe)
  pvalf <- round(1 - pf(fhit, dfr, dfe), 7)
  if (fhit > ftab) { tandaf <- ">"; kepf <- "Tolak H0"
  } else            { tandaf <- "<"; kepf <- "Gagal Tolak H0" }

  # Uji parsial
  sumb0_t <- 0; sumb1_t <- 0
  for (i in 1:n) {
    sumb0_t <- sumb0_t + x[i]^2
    sumb1_t <- sumb1_t + (x[i] - xbar)^2
  }
  seb0  <- sqrt(mse * sumb0_t / (n * sumb1_t))
  seb1  <- sqrt(mse / sumb1_t)
  thit0 <- b0 / seb0; thit1 <- b1 / seb1
  ttab  <- qt(1 - alpha_uji / 2, dfe)
  pval0 <- if (thit0 < 0) 2 * pt(thit0, dfe) else 2 * (1 - pt(thit0, dfe))
  pval1 <- if (thit1 < 0) 2 * pt(thit1, dfe) else 2 * (1 - pt(thit1, dfe))
  kept0 <- if (pval0 <= alpha_uji) "Tolak H0" else "Gagal Tolak H0"
  kept1 <- if (pval1 <= alpha_uji) "Tolak H0" else "Gagal Tolak H0"
  ci0 <- ttab * seb0; ci1 <- ttab * seb1

  # ---- OUTPUT ----
  cat("Dari pengujian regresi non-linear (Eksponensial) yang dilakukan, menghasilkan output sebagai berikut :\n")
  cat("Transformasi : ln(Y) =", round(b0, 4), "+", round(b1, 4), "* X\n")
  cat("Model Asli   : Y_hat =", round(alpha_hat, 4), "* exp(", round(b1, 4), "* X)\n")
  cat("-------------------------\n")
  print(data.frame(
    Variabel = c("R\u00b2 (skala ln)", "R\u00b2Adjusted", "AIC", "Observations"),
    Nilai    = c(rsq, radj, aic, n)
  ), row.names = FALSE)
  cat("-------------------------")

  cat("\nDilakukan Uji Serentak (pada skala ln(Y))")
  cat("\nH0 : \u03b21 = 0")
  cat("\nH1 : \u03b21 \u2260 0")
  cat("\n-----------------------------TABEL ANOVA--------------------------------\n")
  print(data.frame(
    Source   = c("Regression", "Residual", "Total"),
    df       = c(dfr, dfe, dft),
    SS       = c(ssr_s, sse_s, sst_s),
    MS       = c(msr, mse, NA),
    F.Hitung = c(fhit, NA, NA),
    F.Tabel  = c(ftab, NA, NA),
    p.value  = c(pvalf, NA, NA)
  ), row.names = FALSE)
  cat("------------------------------------------------------------------------")
  cat("\nKesimpulan : Karena nilai F Hitung", tandaf, "F Tabel, maka keputusan", kepf)

  cat("\n\nLalu dilakukan Uji Parsial")
  cat("\nH0 : \u03b2i = 0, i = 0,1")
  cat("\nH1 : \u03b2i \u2260 0")
  cat("\n-------------------------------------------------------------------------\n")
  print(data.frame(
    Variabel       = c("b0 = ln(\u03b10)", "b1"),
    Coefficient    = c(b0, b1),
    Standard.Error = c(seb0, seb1),
    T.Hitung       = c(thit0, thit1),
    T.Tabel        = c(ttab, ttab),
    p.value        = c(pval0, pval1),
    Keputusan      = c(kept0, kept1)
  ), row.names = FALSE)
  cat("-------------------------------------------------------------------------")
  cat("\nLower 95%\tUpper 95%")
  cat("\n", b0 - ci0, "\t", b0 + ci0)
  cat("\n", b1 - ci1, "\t", b1 + ci1)

  # Interpretasi
  persen <- round((exp(b1) - 1) * 100, 2)
  arah   <- if (b1 > 0) "naik" else "turun"
  cat("\n\nInterpretasi :")
  cat("\nSetiap kenaikan X sebesar 1 satuan, Y", arah, "sebesar", abs(persen), "%")
  cat("\n(faktor pengali e^b1 =", round(exp(b1), 4), ")\n")

  # Plot
  x_seq  <- seq(min(x), max(x), length.out = 200)
  y_pred <- alpha_hat * exp(b1 * x_seq)
  plot(x, y, pch = 16, col = "steelblue", cex = 1.3,
       main = "Model Eksponensial",
       xlab = "X", ylab = "Y")
  lines(x_seq, y_pred, col = "tomato", lwd = 2)
  legend("topleft", bty = "n",
         legend = c("Data", paste0("Y = ", round(alpha_hat,3),
                                   " \u00d7 exp(", round(b1,3), "X)")),
         col = c("steelblue","tomato"), pch = c(16, NA), lty = c(NA, 1), lwd = 2)

  # Kembalikan nilai kunci (untuk perbandingan model)
  invisible(list(model = "Eksponensial", SSE = sse_s, R2 = rsq, R2adj = radj, AIC = aic))
}

# Cara pakai
x <- c(1, 2, 3, 4, 5)
y <- c(2.7, 7.4, 20.1, 54.6, 148.4)
hasil_eksponen <- nonlinear_eksponen(y, x)
```

    ## Dari pengujian regresi non-linear (Eksponensial) yang dilakukan, menghasilkan output sebagai berikut :
    ## Transformasi : ln(Y) = -0.0045 + 1.0012 * X
    ## Model Asli   : Y_hat = 0.9955 * exp( 1.0012 * X)
    ## -------------------------
    ##       Variabel      Nilai
    ##  R² (skala ln)   0.999997
    ##     R²Adjusted   0.999996
    ##            AIC -56.131870
    ##   Observations   5.000000
    ## -------------------------
    ## Dilakukan Uji Serentak (pada skala ln(Y))
    ## H0 : β1 = 0
    ## H1 : β1 ≠ 0
    ## -----------------------------TABEL ANOVA--------------------------------
    ##      Source df           SS           MS F.Hitung  F.Tabel p.value
    ##  Regression  1 1.002376e+01 1.002376e+01  1005009 10.12796       0
    ##    Residual  3 2.992142e-05 9.973806e-06       NA       NA      NA
    ##       Total  4 1.002379e+01           NA       NA       NA      NA
    ## ------------------------------------------------------------------------
    ## Kesimpulan : Karena nilai F Hitung > F Tabel, maka keputusan Tolak H0
    ## 
    ## Lalu dilakukan Uji Parsial
    ## H0 : βi = 0, i = 0,1
    ## H1 : βi ≠ 0
    ## -------------------------------------------------------------------------
    ##     Variabel  Coefficient Standard.Error   T.Hitung  T.Tabel      p.value
    ##  b0 = ln(α0) -0.004482539   0.0033122781   -1.35331 3.182446 2.688994e-01
    ##           b1  1.001187300   0.0009986894 1002.50115 3.182446 2.188843e-09
    ##       Keputusan
    ##  Gagal Tolak H0
    ##        Tolak H0
    ## -------------------------------------------------------------------------
    ## Lower 95%    Upper 95%
    ##  -0.01502369      0.006058608
    ##  0.998009     1.004366
    ## 
    ## Interpretasi :
    ## Setiap kenaikan X sebesar 1 satuan, Y naik sebesar 172.15 %
    ## (faktor pengali e^b1 = 2.7215 )

![](Regresi_files/figure-gfm/fungsi-eksponen-1.png)<!-- -->

------------------------------------------------------------------------

## Model Polinomial

Model polinomial digunakan saat hubungan $Y$ dan $X$ berbentuk kurva
parabola (naik lalu turun, atau sebaliknya).

**Model derajat 2 (kuadratik):**

$$Y = \beta_0 + \beta_1 X + \beta_2 X^2 + \epsilon$$

Triknya: perlakukan $X^2$ sebagai variabel baru $X_2 = X^2$, lalu
selesaikan dengan **regresi linear berganda** menggunakan metode
matriks.

**Titik puncak/lembah kurva:**

$$X^* = -\frac{b_1}{2b_2}$$

**Interpretasi:** Efek marginal $\frac{dY}{dX} = b_1 + 2b_2 X$ —
nilainya berubah tergantung $X$.

``` r
nonlinear_polinom <- function(y, x, derajat = 2) {

  n <- length(x)

  # Susun matriks desain: kolom 1, X, X^2, ..., X^derajat
  X_mat <- matrix(1, nrow = n)
  for (d in 1:derajat) X_mat <- cbind(X_mat, x^d)
  Y_vec <- matrix(y, nrow = n)

  # Estimasi parameter OLS
  XtX     <- t(X_mat) %*% X_mat
  XtY     <- t(X_mat) %*% Y_vec
  XtX_inv <- solve(XtX)
  b       <- XtX_inv %*% XtY

  # Prediksi dan SS
  ytopi <- X_mat %*% b
  ybar  <- sum(y) / n
  k     <- ncol(X_mat)

  ssr <- as.numeric(t(b) %*% XtY - n * ybar^2)
  sse <- as.numeric(t(Y_vec) %*% Y_vec - t(b) %*% XtY)
  sst <- ssr + sse
  dfr <- k - 1; dfe <- n - k; dft <- dfr + dfe
  msr <- ssr / dfr; mse <- sse / dfe
  rsq  <- ssr / sst
  radj <- rsq - (dfr * (1 - rsq)) / (n - dfr - 1)

  # AIC
  aic <- n * log(sse / n) + 2 * k

  # Uji serentak
  alpha_uji <- 0.05
  fhit  <- msr / mse
  ftab  <- qf(1 - alpha_uji, dfr, dfe)
  pvalf <- round(1 - pf(fhit, dfr, dfe), 7)
  if (fhit > ftab) { tandaf <- ">"; kepf <- "Tolak H0"
  } else            { tandaf <- "<"; kepf <- "Gagal Tolak H0" }

  # Uji parsial
  sb   <- sqrt(mse) * sqrt(diag(XtX_inv))
  thit <- as.vector(b) / sb
  ttab <- qt(1 - alpha_uji / 2, dfe)
  pval_t   <- numeric(k); kept     <- character(k)
  ci_lower <- numeric(k); ci_upper <- numeric(k)
  for (i in 1:k) {
    pval_t[i]   <- if (thit[i] < 0) 2 * pt(thit[i], dfe) else 2 * (1 - pt(thit[i], dfe))
    kept[i]     <- if (pval_t[i] <= alpha_uji) "Tolak H0" else "Gagal Tolak H0"
    ci_lower[i] <- as.vector(b)[i] - ttab * sb[i]
    ci_upper[i] <- as.vector(b)[i] + ttab * sb[i]
  }

  var_names <- c("Intercept", paste0("X^", 1:derajat))

  # Titik ekstrem (untuk derajat 2)
  x_ext <- NA; y_ext <- NA; tipe <- ""
  if (derajat == 2) {
    x_ext <- -as.vector(b)[2] / (2 * as.vector(b)[3])
    y_ext <- sum(as.vector(b) * c(1, x_ext, x_ext^2))
    tipe  <- if (as.vector(b)[3] < 0) "Maksimum (puncak)" else "Minimum (lembah)"
  }

  # ---- OUTPUT ----
  cat("Dari pengujian regresi non-linear (Polinomial Derajat", derajat, ") yang dilakukan, menghasilkan output sebagai berikut :\n")
  if (derajat == 2) cat("Titik", tipe, ": X =", round(x_ext, 4), ", Y =", round(y_ext, 4), "\n")
  cat("-------------------------\n")
  print(data.frame(
    Variabel = c("R\u00b2", "R\u00b2Adjusted", "AIC", "Observations"),
    Nilai    = c(rsq, radj, aic, n)
  ), row.names = FALSE)
  cat("-------------------------")

  cat("\nDilakukan Uji Serentak")
  cat("\nH0 : "); for (i in 1:derajat) cat(paste0("\u03b2", i, " = ")); cat("0")
  cat("\nH1 : \u03b2i \u2260 0, i = "); cat(paste(1:derajat, collapse = ","))
  cat("\n-----------------------------TABEL ANOVA--------------------------------\n")
  print(data.frame(
    Source   = c("Regression", "Residual", "Total"),
    df       = c(dfr, dfe, dft),
    SS       = c(ssr, sse, sst),
    MS       = c(msr, mse, NA),
    F.Hitung = c(fhit, NA, NA),
    F.Tabel  = c(ftab, NA, NA),
    p.value  = c(pvalf, NA, NA)
  ), row.names = FALSE)
  cat("------------------------------------------------------------------------")
  cat("\nKesimpulan : Karena nilai F Hitung", tandaf, "F Tabel, maka keputusan", kepf)

  cat("\n\nLalu dilakukan Uji Parsial")
  cat("\nH0 : \u03b2i = 0, i = "); cat(paste(0:derajat, collapse = ","))
  cat("\nH1 : \u03b2i \u2260 0")
  cat("\n-------------------------------------------------------------------------\n")
  print(data.frame(
    Variabel       = var_names,
    Coefficient    = as.vector(b),
    Standard.Error = sb,
    T.Hitung       = thit,
    T.Tabel        = rep(ttab, k),
    p.value        = pval_t,
    Keputusan      = kept
  ), row.names = FALSE)
  cat("-------------------------------------------------------------------------")
  cat("\nLower 95%\tUpper 95%")
  for (i in 1:k) cat("\n", ci_lower[i], "\t", ci_upper[i])

  # Interpretasi efek marginal
  if (derajat == 2) {
    cat("\n\nInterpretasi :")
    cat("\nEfek marginal dY/dX =", round(as.vector(b)[2], 4), "+",
        round(2 * as.vector(b)[3], 4), "* X")
    cat("\n(nilainya berubah tergantung nilai X)")
    cat("\nTitik", tipe, ": X =", round(x_ext, 4), ", Y =", round(y_ext, 4), "\n")
  }

  # Plot
  x_seq  <- seq(min(x), max(x), length.out = 200)
  b_vec  <- as.vector(b)
  y_pred <- sapply(x_seq, function(xi) sum(b_vec * xi^(0:derajat)))

  plot(x, y, pch = 16, col = "steelblue", cex = 1.3,
       main = paste("Model Polinomial Derajat", derajat),
       xlab = "X", ylab = "Y")
  lines(x_seq, y_pred, col = "tomato", lwd = 2)
  if (derajat == 2 && !is.na(x_ext)) {
    abline(v = x_ext, lty = 2, col = "gray40")
    points(x_ext, y_ext, pch = 4, cex = 1.5, col = "darkgreen", lwd = 2)
    text(x_ext, y_ext, paste0("  X*=", round(x_ext,2)), adj = 0, cex = 0.85)
  }
  legend("topright", bty = "n",
         legend = c("Data", "Kurva taksiran", "Titik ekstrem"),
         col = c("steelblue","tomato","darkgreen"),
         pch = c(16, NA, 4), lty = c(NA, 1, NA), lwd = 2)

  invisible(list(model = paste("Polinomial Derajat", derajat),
                 SSE = sse, R2 = rsq, R2adj = radj, AIC = aic))
}

# Cara pakai
x <- c(1, 2, 3, 4, 5, 6, 7)
y <- c(2, 5, 9, 11, 10, 7, 3)
hasil_polinom <- nonlinear_polinom(y, x, derajat = 2)
```

    ## Dari pengujian regresi non-linear (Polinomial Derajat 2 ) yang dilakukan, menghasilkan output sebagai berikut :
    ## Titik Maksimum (puncak) : X = 4.1579 , Y = 10.3559 
    ## -------------------------
    ##      Variabel      Nilai
    ##            R²  0.9675746
    ##    R²Adjusted  0.9513619
    ##           AIC -1.5488671
    ##  Observations  7.0000000
    ## -------------------------
    ## Dilakukan Uji Serentak
    ## H0 : β1 = β2 = 0
    ## H1 : βi ≠ 0, i = 1,2
    ## -----------------------------TABEL ANOVA--------------------------------
    ##      Source df        SS         MS F.Hitung  F.Tabel   p.value
    ##  Regression  2 71.047619 35.5238095    59.68 6.944272 0.0010514
    ##    Residual  4  2.380952  0.5952381       NA       NA        NA
    ##       Total  6 73.428571         NA       NA       NA        NA
    ## ------------------------------------------------------------------------
    ## Kesimpulan : Karena nilai F Hitung > F Tabel, maka keputusan Tolak H0
    ## 
    ## Lalu dilakukan Uji Parsial
    ## H0 : βi = 0, i = 0,1,2
    ## H1 : βi ≠ 0
    ## -------------------------------------------------------------------------
    ##   Variabel Coefficient Standard.Error   T.Hitung  T.Tabel      p.value
    ##  Intercept  -5.2857143     1.20232202  -4.396255 2.776445 0.0117253250
    ##        X^1   7.5238095     0.68903791  10.919297 2.776445 0.0003994583
    ##        X^2  -0.9047619     0.08417938 -10.748023 2.776445 0.0004247960
    ##  Keputusan
    ##   Tolak H0
    ##   Tolak H0
    ##   Tolak H0
    ## -------------------------------------------------------------------------
    ## Lower 95%    Upper 95%
    ##  -8.623895    -1.947533
    ##  5.610734     9.436885
    ##  -1.138481    -0.6710425
    ## 
    ## Interpretasi :
    ## Efek marginal dY/dX = 7.5238 + -1.8095 * X
    ## (nilainya berubah tergantung nilai X)
    ## Titik Maksimum (puncak) : X = 4.1579 , Y = 10.3559

![](Regresi_files/figure-gfm/fungsi-polinomial-1.png)<!-- -->

------------------------------------------------------------------------

## Model Logaritmik

Model logaritmik cocok saat $Y$ meningkat tajam di awal kemudian
melambat seiring $X$ bertambah.

**Model:**

$$Y = \beta_0 + \beta_1 \ln(X) + \epsilon$$

**Transformasi:** ganti $X$ dengan $X^* = \ln(X)$, sehingga modelnya
menjadi linear biasa:

$$Y = \beta_0 + \beta_1 X^*$$

Tidak ada transformasi balik pada $Y$ — prediksi langsung bisa dibaca
pada skala asli.

**Interpretasi:** $X$ naik 1% $\Rightarrow$ $Y$ berubah sebesar
$\frac{b_1}{100}$ satuan.

``` r
nonlinear_logaritma <- function(y, x) {

  n      <- length(x)
  x_star <- log(x)           # transformasi: X* = ln(X)
  xbar   <- sum(x_star) / n
  ybar   <- sum(y) / n

  # Penaksir parameter
  suma <- 0; sumb <- 0
  for (i in 1:n) {
    suma <- suma + (x_star[i] - xbar) * (y[i] - ybar)  # numerator b1
    sumb <- sumb + (x_star[i] - xbar)^2                 # denominator b1
  }
  b1 <- suma / sumb
  b0 <- ybar - b1 * xbar

  # Prediksi dan SS
  ytopi <- numeric(n); sse <- 0; sst <- 0
  for (i in 1:n) {
    ytopi[i] <- b0 + b1 * x_star[i]
    sse <- sse + (y[i] - ytopi[i])^2
    sst <- sst + (y[i] - ybar)^2
  }
  ssr <- sst - sse
  dfr <- 1; dfe <- n - 2; dft <- n - 1
  msr <- ssr / dfr; mse <- sse / dfe
  rsq  <- ssr / sst
  radj <- rsq - (dfr * (1 - rsq)) / (n - dfr - 1)

  # AIC
  aic <- n * log(sse / n) + 2 * (dfr + 1)

  # Uji serentak
  alpha_uji <- 0.05
  fhit  <- msr / mse
  ftab  <- qf(1 - alpha_uji, dfr, dfe)
  pvalf <- round(1 - pf(fhit, dfr, dfe), 7)
  if (fhit > ftab) { tandaf <- ">"; kepf <- "Tolak H0"
  } else            { tandaf <- "<"; kepf <- "Gagal Tolak H0" }

  # Uji parsial
  sumb0_t <- 0; sumb1_t <- 0
  for (i in 1:n) {
    sumb0_t <- sumb0_t + x_star[i]^2
    sumb1_t <- sumb1_t + (x_star[i] - xbar)^2
  }
  seb0  <- sqrt(mse * sumb0_t / (n * sumb1_t))
  seb1  <- sqrt(mse / sumb1_t)
  thit0 <- b0 / seb0; thit1 <- b1 / seb1
  ttab  <- qt(1 - alpha_uji / 2, dfe)
  pval0 <- if (thit0 < 0) 2 * pt(thit0, dfe) else 2 * (1 - pt(thit0, dfe))
  pval1 <- if (thit1 < 0) 2 * pt(thit1, dfe) else 2 * (1 - pt(thit1, dfe))
  kept0 <- if (pval0 <= alpha_uji) "Tolak H0" else "Gagal Tolak H0"
  kept1 <- if (pval1 <= alpha_uji) "Tolak H0" else "Gagal Tolak H0"
  ci0 <- ttab * seb0; ci1 <- ttab * seb1

  # ---- OUTPUT ----
  cat("Dari pengujian regresi non-linear (Logaritmik) yang dilakukan, menghasilkan output sebagai berikut :\n")
  cat("Model : Y_hat =", round(b0, 4), "+", round(b1, 4), "* ln(X)\n")
  cat("-------------------------\n")
  print(data.frame(
    Variabel = c("R\u00b2", "R\u00b2Adjusted", "AIC", "Observations"),
    Nilai    = c(rsq, radj, aic, n)
  ), row.names = FALSE)
  cat("-------------------------")

  cat("\nDilakukan Uji Serentak")
  cat("\nH0 : \u03b21 = 0")
  cat("\nH1 : \u03b21 \u2260 0")
  cat("\n-----------------------------TABEL ANOVA--------------------------------\n")
  print(data.frame(
    Source   = c("Regression", "Residual", "Total"),
    df       = c(dfr, dfe, dft),
    SS       = c(ssr, sse, sst),
    MS       = c(msr, mse, NA),
    F.Hitung = c(fhit, NA, NA),
    F.Tabel  = c(ftab, NA, NA),
    p.value  = c(pvalf, NA, NA)
  ), row.names = FALSE)
  cat("------------------------------------------------------------------------")
  cat("\nKesimpulan : Karena nilai F Hitung", tandaf, "F Tabel, maka keputusan", kepf)

  cat("\n\nLalu dilakukan Uji Parsial")
  cat("\nH0 : \u03b2i = 0, i = 0,1")
  cat("\nH1 : \u03b2i \u2260 0")
  cat("\n-------------------------------------------------------------------------\n")
  print(data.frame(
    Variabel       = c("Intercept", "ln(X)"),
    Coefficient    = c(b0, b1),
    Standard.Error = c(seb0, seb1),
    T.Hitung       = c(thit0, thit1),
    T.Tabel        = c(ttab, ttab),
    p.value        = c(pval0, pval1),
    Keputusan      = c(kept0, kept1)
  ), row.names = FALSE)
  cat("-------------------------------------------------------------------------")
  cat("\nLower 95%\tUpper 95%")
  cat("\n", b0 - ci0, "\t", b0 + ci0)
  cat("\n", b1 - ci1, "\t", b1 + ci1)

  # Interpretasi
  cat("\n\nInterpretasi :")
  cat("\nX naik 1% \u2192 Y berubah sebesar", round(b1 / 100, 4), "satuan")
  cat("\n(karena b1/100 =", round(b1 / 100, 4), ")\n")

  # Plot
  x_seq  <- seq(min(x[x > 0]), max(x), length.out = 200)
  y_pred <- b0 + b1 * log(x_seq)
  plot(x, y, pch = 16, col = "steelblue", cex = 1.3,
       main = "Model Logaritmik",
       xlab = "X", ylab = "Y")
  lines(x_seq, y_pred, col = "tomato", lwd = 2)
  legend("topleft", bty = "n",
         legend = c("Data", paste0("Y = ", round(b0,3), " + ",
                                   round(b1,3), " ln(X)")),
         col = c("steelblue","tomato"), pch = c(16, NA), lty = c(NA, 1), lwd = 2)

  invisible(list(model = "Logaritmik", SSE = sse, R2 = rsq, R2adj = radj, AIC = aic))
}

# Cara pakai
x <- c(1, 2, 4, 8, 16, 32)
y <- c(0, 3.5, 7.0, 10.5, 14.0, 17.5)
hasil_log <- nonlinear_logaritma(y, x)
```

    ## Dari pengujian regresi non-linear (Logaritmik) yang dilakukan, menghasilkan output sebagai berikut :
    ## Model : Y_hat = 0 + 5.0494 * ln(X)
    ## -------------------------
    ##      Variabel     Nilai
    ##            R²    1.0000
    ##    R²Adjusted    1.0000
    ##           AIC -409.2911
    ##  Observations    6.0000
    ## -------------------------
    ## Dilakukan Uji Serentak
    ## H0 : β1 = 0
    ## H1 : β1 ≠ 0
    ## -----------------------------TABEL ANOVA--------------------------------
    ##      Source df           SS           MS     F.Hitung  F.Tabel p.value
    ##  Regression  1 2.143750e+02 2.143750e+02 1.175146e+32 7.708647       0
    ##    Residual  4 7.296963e-30 1.824241e-30           NA       NA      NA
    ##       Total  5 2.143750e+02           NA           NA       NA      NA
    ## ------------------------------------------------------------------------
    ## Kesimpulan : Karena nilai F Hitung > F Tabel, maka keputusan Tolak H0
    ## 
    ## Lalu dilakukan Uji Parsial
    ## H0 : βi = 0, i = 0,1
    ## H1 : βi ≠ 0
    ## -------------------------------------------------------------------------
    ##   Variabel Coefficient Standard.Error     T.Hitung  T.Tabel p.value
    ##  Intercept    0.000000   9.775248e-16 0.000000e+00 2.776445       1
    ##      ln(X)    5.049433   4.657969e-16 1.084042e+16 2.776445       0
    ##       Keputusan
    ##  Gagal Tolak H0
    ##        Tolak H0
    ## -------------------------------------------------------------------------
    ## Lower 95%    Upper 95%
    ##  -2.714044e-15    2.714044e-15
    ##  5.049433     5.049433
    ## 
    ## Interpretasi :
    ## X naik 1% → Y berubah sebesar 0.0505 satuan
    ## (karena b1/100 = 0.0505 )

![](Regresi_files/figure-gfm/fungsi-logaritmik-1.png)<!-- -->

------------------------------------------------------------------------

## Perbandingan Model

Untuk memilih model terbaik, gunakan tiga kriteria sekaligus:

- **SSE** : semakin kecil semakin baik (kesalahan prediksi lebih kecil)
- **$R^2$** : semakin besar semakin baik (variasi Y lebih banyak
  dijelaskan)
- **AIC** : semakin kecil semakin baik (mempertimbangkan kompleksitas
  model)

> **Catatan:** Isi objek `hasil_*` di bawah dengan hasil dari
> fungsi-fungsi di atas pada data yang sama.

``` r
# Kumpulkan hasil dari ketiga model (jalankan pada data yang sama terlebih dahulu)
# Ganti nilai di bawah ini dengan hasil dari masing-masing fungsi di atas
SSE_eksponen   <- hasil_eksponen$SSE
R2_eksponen    <- hasil_eksponen$R2
R2adj_eksponen <- hasil_eksponen$R2adj
AIC_eksponen   <- hasil_eksponen$AIC

SSE_polinom    <- hasil_polinom$SSE
R2_polinom     <- hasil_polinom$R2
R2adj_polinom  <- hasil_polinom$R2adj
AIC_polinom    <- hasil_polinom$AIC

SSE_log        <- hasil_log$SSE
R2_log         <- hasil_log$R2
R2adj_log      <- hasil_log$R2adj
AIC_log        <- hasil_log$AIC

# Susun tabel perbandingan
tabel_banding <- data.frame(
  Model    = c("Eksponensial", paste("Polinomial", hasil_polinom$model), "Logaritmik"),
  SSE      = c(SSE_eksponen,  SSE_polinom,  SSE_log),
  R2       = c(R2_eksponen,   R2_polinom,   R2_log),
  R2adj    = c(R2adj_eksponen,R2adj_polinom,R2adj_log),
  AIC      = c(AIC_eksponen,  AIC_polinom,  AIC_log)
)

cat("=== Perbandingan Antar Model ===\n")
```

    ## === Perbandingan Antar Model ===

``` r
print(tabel_banding, row.names = FALSE)
```

    ##                            Model          SSE        R2     R2adj         AIC
    ##                     Eksponensial 2.992142e-05 0.9999970 0.9999960  -56.131870
    ##  Polinomial Polinomial Derajat 2 2.380952e+00 0.9675746 0.9513619   -1.548867
    ##                       Logaritmik 7.296963e-30 1.0000000 1.0000000 -409.291124

``` r
cat("\nModel terbaik (SSE terkecil) :", tabel_banding$Model[which.min(tabel_banding$SSE)], "\n")
```

    ## 
    ## Model terbaik (SSE terkecil) : Logaritmik

``` r
cat("Model terbaik (R\u00b2 terbesar)  :", tabel_banding$Model[which.max(tabel_banding$R2)],  "\n")
```

    ## Model terbaik (R² terbesar)  : Logaritmik

``` r
cat("Model terbaik (AIC terkecil) :", tabel_banding$Model[which.min(tabel_banding$AIC)], "\n")
```

    ## Model terbaik (AIC terkecil) : Logaritmik
