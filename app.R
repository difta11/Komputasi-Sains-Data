x = 1:6
x

# average dari x
avg_x <- sum(x) / length(x)
avg_x

average_data <- function(data) {
  return(sum(x) / length(x))
}

avg_x_wf <- average_data(x)
avg_x_wf

# average with looping
average_data_wl <- function(data) {
  sum_data = 0
  count_data = 0
  for (i in data) {
    sum_data = sum_data + i
    count_data = count_data + 1
  }

  return(sum_data / count_data)
}

avg_x_wl <- average_data_wl(x)
avg_x_wl
