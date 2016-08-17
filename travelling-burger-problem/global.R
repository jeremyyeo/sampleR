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
details <- details[, -c(1, 7, 9, 18)]
details$Price <- as.numeric(gsub("\\$", "", details$Price))
details$Page <- paste0("<a href='", details$Page, "'>", "visawoap</a>")
details$Maps <- paste0("<a href='", details$Maps, "'>", "Google Maps</a>")
details$Address <- paste(details$`Address 1`, details$`Address 2`, details$`Address 3`, sep = ", ")
details <- details[, -c(7, 8, 9)]
details$Available <- factor(gsub("\nAvailable:", "", details$Available))
details$Restaurant <- as.character(details$Restaurant)
details$Name <- as.character(details$Name)
details$Beer <- as.character(details$Beer)
details$Category <- factor(gsub("\nCategory:", "", details$Category))
