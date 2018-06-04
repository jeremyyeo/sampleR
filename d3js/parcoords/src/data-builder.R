# Used to build dummy data.csv

source          <- c("source_a", "source_b", "source_c")
milestone_month <- seq(as.Date("2016-01-01"), by = "month", length = 24)
activity_month  <- seq(as.Date("2016-01-01"), by = "month", length = 24)
user_type       <- c("low_value", "medium_value", "high_value")
deleted_flag    <- c(0, 1)
tenure          <- 0:12
profit          <- 10:30

num  <- sample(c(100000:500000), 1)
prob <- c(0.65, 0.25, 0.1)

df <-
  data.frame(
    source          = sample(source, num, replace = T, prob = prob),
    milestone_month = sample(milestone_month, num, replace = T),
    activity_month  = sample(activity_month, num, replace = T),
    user_type       = sample(user_type, num, replace = T, prob = prob),
    deleted_flag    = sample(deleted_flag, num, replace = T),
    profit          = c(sample(profit, num, replace = T) * sample(tenure, num, replace = T))
  )

write.csv(df, file = "data.csv", row.names = F)
