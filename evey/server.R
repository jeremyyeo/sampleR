## server.R ##

library(shiny)
library(lubridate)

server <- function(input, output, session) {
  
  d.left <- reactive({
    invalidateLater(1000*60*60*24, session)
    as.numeric(
      ymd_hms("2017-04-26 11:30:00", tz = "Australia/Sydney") - 
      with_tz(Sys.time(), tzone = "Australia/Sydney")
    )
  })
  h.left <- reactive({
    invalidateLater(1000*60*60, session)
    as.numeric(
      ymd_hms("2017-04-26 11:30:00", tz = "Australia/Sydney") - 
        with_tz(Sys.time(), tzone = "Australia/Sydney")
    ) * 24
  })
  m.left <- reactive({
    invalidateLater(1000*60, session)
    as.numeric(
      ymd_hms("2017-04-26 11:30:00", tz = "Australia/Sydney") - 
        with_tz(Sys.time(), tzone = "Australia/Sydney")
    ) * 24 * 60
  })
  s.left <- reactive({
    invalidateLater(1000, session)
    as.numeric(
      ymd_hms("2017-04-26 11:30:00", tz = "Australia/Sydney") - 
        with_tz(Sys.time(), tzone = "Australia/Sydney")
    ) * 24 * 60 * 60
  })
  
  output$printleft <- renderPrint({
    data.frame(days    = round(d.left(), 0),
               hours   = round(h.left(), 0),
               minutes = round(m.left(), 0),
               seconds = s.left())
  })
  
  output$nzTime <- renderInfoBox({
    invalidateLater(1000, session)
    dt <- format(with_tz(Sys.time(), tzone = "Pacific/Auckland"), format = "%H:%M:%S %a, %B %d, %Y")
    current.hour <- hour(with_tz(Sys.time(), tzone = "Pacific/Auckland"))
    icon <- if(current.hour > 6 & current.hour < 21) {icon("sun-o")} else {icon("moon-o")}
    infoBox("New Zealand", paste(dt), icon = icon, color = "green", fill = TRUE)
  })  
  
  output$sgTime <- renderInfoBox({
    invalidateLater(1000, session)
    dt <- format(with_tz(Sys.time(), tzone = "Asia/Singapore"), format = "%H:%M:%S %a, %B %d, %Y")
    current.hour <- hour(with_tz(Sys.time(), tzone = "Asia/Singapore"))
    icon <- if(current.hour > 6 & current.hour < 21) {icon("sun-o")} else {icon("moon-o")}
    infoBox("Singapore", paste(dt), icon = icon, color = "red", fill = TRUE)
  })
}
