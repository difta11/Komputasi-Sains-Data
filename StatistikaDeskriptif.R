# sample data
data <- c(1, 3, 7, -2, 6, -5, 4)

# membuat function mean
mean_function <- function(data) {
    sum = 0
    count = 0
    for(i in data) {
        sum = data + i
        count = count + 1
    }
    return(sum / count)
}

avg_x_wl <- mean_function(data)
avg_x_wl

mean_function_fast_track <- function(data) {
  return(sum(data) / length(data))
}

avg_x_wf <- average_data(data)
avg_x_wf
