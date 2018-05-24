x <- jsonlite::fromJSON("https://www.reddit.com/r/cubers/top.json")


x <- data.frame(name = c("bob", "jones"),
                number = c(1,2))

x <- httr::GET("https://www.xero.com/blog/feed/?paged=137")

library(httr)
library(feedeR)
