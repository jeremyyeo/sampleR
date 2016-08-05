library(shiny)
library(jsonlite)
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


# test
x <- burgers[1]
x <- unlist(strsplit(x, "',"))
x <- gsub("'", "", x)
x <- c(unlist(strsplit(x[1], ",")), x[2:length(x)])
names <- gsub("^([[:alpha:]]+[[:blank:]]?[[:digit:]]?):(.*)", "\\1", x)
details <- gsub("^([[:alpha:]]+[[:blank:]]?[[:digit:]]?):(.*)", "\\2", x)


# x <- gsub("([[:alpha:]]*):", "\"\\1\":", burgers[1])
