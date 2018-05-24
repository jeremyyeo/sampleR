sum_by <- function(df, group, var) {
  require(dplyr)
  df %>% group_by(group) %>% summarise(avg = mean(var))
}

sum_by_working <- function(df, group, var) {
  require(dplyr)
  
  x <- vector("list", length(group))
  for (i in 1:length(group)) {
    x[i]        <- list(unique(df[, group[i]]))
    names(x)[i] <- group[i]
  }
  
  # df <- unique(df[, group])
  print(x)
  # df %>% group_by(group) %>% summarise(avg = mean(var))
}

library(dplyr)
mtcars %>% group_by(cyl) %>% summarise(avg = mean(mpg))
                                     