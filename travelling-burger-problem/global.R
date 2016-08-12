library(RCurl)
rawdata <- getURL("http://burgerwelly.com/scripts/scripts.341a8e6e.js")
burgers <- sub("var burgerData=\\[(.*)\\],beerData=.*", "\\1", rawdata)
burgers <- unlist(strsplit(burgers, "},"))
burgers <- gsub("\\{", "", burgers)

burgers <- gsub("\\}", "", burgers)
burgers <- gsub("\"", "'", burgers)

beers   <- sub(".*beerData=\\[(.*)\\];angular.module.*", "\\1", rawdata)
beers   <- unlist(strsplit(beers, "},"))
beers   <- gsub("\\{", "", beers) 
beers   <- gsub("\\}", "", beers) 
beers   <- gsub("\"", "", beers) 

x <- burgers[1]
x <- unlist(strsplit(x, "',"))
x <- gsub("'", "", x)
x <- c(unlist(strsplit(x[1], ",")), x[2:length(x)])
names <- 
  matrix(
    gsub("^([[:alpha:]]+[[:blank:]]?[[:digit:]]?):(.*)", "\\1", x),
    nrow = 1
  )

details <- matrix(nrow = 0, ncol = 18)
for (i in burgers) {
  x <- i 
  x <- unlist(strsplit(x, "',"))
  x <- gsub("'", "", x)
  y <- gsub("([[:alpha:]]*:.*),([[:alpha:]]*:.*)", "\\1|\\2", x[1])
  x <- c(unlist(strsplit(y, "\\|")), x[2:length(x)])
  info <- 
    matrix(
      gsub("^([[:alpha:]]+[[:blank:]]?[[:digit:]]?):(.*)", "\\2", x), 
      nrow = 1
    )
  details <- rbind(details, info)
}

details <- as.data.frame(details)
colnames(details) <- names
details$Description <- iconv(details$Description, from = "UTF-8", to = "LATIN1")