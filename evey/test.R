library(jsonlite)
secret <- readLines(".credentials")

weatherNZ <- 
  fromJSON(
    paste0(
      "https://api.darksky.net/forecast/",
      secret,
      "/-41.2865,174.7762"
    )
  )

weatherSG <- 
  fromJSON(
    paste0(
      "https://api.darksky.net/forecast/",
      secret,
      "/1.3521,103.8198"
    )
  )

