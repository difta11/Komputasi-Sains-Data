# Sample data
data <- c(1, 3, 7, -2, 6, -5, 4)

# Membuat function mean
mean_function() <- function(data) {
    sum = 0
    count = 0
    for(i in data) {
        sum = data + i
        count = count + 1
    }
    return(sum / count)
}