library(jsonlite)
library(rvest)
library(lubridate)

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


# Retrieve NZ Holidays ####
holidaysNZ <-
  read_html("https://employment.govt.nz/leave-and-holidays/public-holidays/public-holidays-and-anniversary-dates/") %>%
  html_nodes("tr") %>%
  html_text()

holidaysNZ <-
  holidaysNZ[4:which(holidaysNZ %in% c("ProvinceActual dateObserved date"))-1]

holidaysNZ <- 
  unlist(
    lapply(
      holidaysNZ, function(x) strsplit(x, "\n")
    )
  )

holidaysNZ <- 
  data.frame(
    matrix(holidaysNZ[holidaysNZ != ""], ncol = 6, byrow = T),
    stringsAsFactors = F
  )[, c(1,3)]
colnames(holidaysNZ) <- c("Holiday", "Date")
holidaysNZ$Date <- paste(gsub("^(.*) or (.*)$", "\\1", holidaysNZ$Date), "2017")
holidaysNZ$Date <- strptime(holidaysNZ$Date, "%A %d %B %Y", tz = "Pacific/Auckland")

# Retrieve SG Holidays ####

holidaysSG <-
  read_html("http://www.mom.gov.sg/employment-practices/public-holidays") %>%
  html_nodes("tr") %>%
  html_text()


holidaysSG <- 
  unlist(
    lapply(
      holidaysSG, function(x) strsplit(x, "\r\n")
    )
  )