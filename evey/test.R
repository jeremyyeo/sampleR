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
# holidaysNZ <-
#   read_html("https://employment.govt.nz/leave-and-holidays/public-holidays/public-holidays-and-anniversary-dates/") %>%
#   html_nodes("tr") %>%
#   html_text()
# 
# holidaysNZ <-
#   holidaysNZ[4:which(holidaysNZ %in% c("ProvinceActual dateObserved date"))-1]
# 
# holidaysNZ <- 
#   unlist(
#     lapply(
#       holidaysNZ, function(x) strsplit(x, "\n")
#     )
#   )
# 
# holidaysNZ <- 
#   data.frame(
#     matrix(holidaysNZ[holidaysNZ != ""], ncol = 6, byrow = T),
#     stringsAsFactors = F
#   )[, c(1,3)]
# colnames(holidaysNZ) <- c("Holiday", "Date")
# holidaysNZ$Date <- paste(gsub("^(.*) or (.*)$", "\\1", holidaysNZ$Date), "2017")
# holidaysNZ$Date <- strptime(holidaysNZ$Date, "%A %d %B %Y", tz = "Pacific/Auckland")
# holidaysNZ$Country <- "New Zealand"

# Retrieve SG Holidays ####
holidaysNZ <- data.frame(
  Holiday    = c(
    "Good Friday",
    "Easter Monday",
    "ANZAC Day",
    "Queen's Birthday",
    "Labour Day",
    "Christmas Day",
    "Boxing Day"
  ),
  Date = c(
    "2017-04-14",
    "2017-04-17",
    "2017-04-25",
    "2017-06-05",
    "2017-10-23",
    "2017-12-25",
    "2017-12-26"
  ),
  Country = c(rep("Singapore", 7))
)
holidaysNZ$Date <- as.Date(holidaysNZ$Date)

# Retrieve SG Holidays ####
holidaysSG <- data.frame(
  Holiday    = c(
    "Good Friday",
    "Labour Day",
    "Vesak Day",
    "Hari Raya Puasa",
    "National Day",
    "Hari Raya Haji",
    "Deepavali",
    "Christmas Day"
  ),
  Date = c(
    "2017-04-14",
    "2017-05-01",
    "2017-05-10",
    "2017-06-25",
    "2017-08-09",
    "2017-09-01",
    "2017-10-18",
    "2017-12-25"
  ),
  Country = c(rep("Singapore", 8))
)
holidaysSG$Date <- as.Date(holidaysSG$Date)

# Group Holidays ####
holidays <- rbind.data.frame(holidaysSG, holidaysNZ)
holidays$DaysLeft <- as.numeric(holidays$Date - Sys.Date())

# Test Timing ####
seconds <- as.numeric(
  ymd_hms("2017-04-26 11:30:00", tz = "Australia/Sydney") -
    with_tz(Sys.time(), tzone = "Australia/Sydney")
) * 24 * 60 * 60

plot_ly(x = "Days", y = time.remaining@day, type = "bar", name = "days", 
        marker = list(line = list(color = "black", width = 1))) %>%
  add_trace(x = "Hours", y = time.remaining@hour, name = "hours") %>%
  add_trace(x = "Minutes", y = time.remaining@minute, name = "minutes") %>%
  add_trace(x = "Seconds", y = time.remaining@.Data, name = "seconds") %>%
  layout(xaxis = list(fixedrange = T),
         yaxis = list(fixedrange = T),
         showlegend = F,
         annotations = list(x = c("Days", "Hours", "Minutes", "Seconds"),
                            y = c(time.remaining@day, time.remaining@hour, time.remaining@minute, time.remaining@.Data),
                            text = c(time.remaining@day, time.remaining@hour, time.remaining@minute, trunc(time.remaining@.Data)),
                            yanchor = "bottom",
                            showarrow = F,
                            font = list(size = 15))) %>%
  config(displayModeBar = F, staticPlot = T)