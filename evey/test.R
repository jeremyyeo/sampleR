library(jsonlite)
weatherNZ <- 
  fromJSON("https://api.darksky.net/forecast/355a2b8a4722582539dede0ab018404e/-41.2865,174.7762")
weatherSG <- 
  fromJSON("https://api.darksky.net/forecast/355a2b8a4722582539dede0ab018404e/1.3521,103.8198")

