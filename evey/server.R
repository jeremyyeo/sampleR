## server.R ##

library(shiny)
library(lubridate)

server <- function(input, output, session) {
  
  output$nzTime <- renderInfoBox({
    invalidateLater(1000, session)
    dt <- format(Sys.time(), format = "%a, %B %d, %Y %H:%M:%S")
    infoBox("New Zealand", paste(dt), icon = icon("clock-o"), color = "green", fill = TRUE)
  })  
  
  output$sgTime <- renderInfoBox({
    invalidateLater(1000, session)
    dt <- format(with_tz(Sys.time(), tzone = "Asia/Singapore"), format = "%a, %B %d, %Y %H:%M:%S")
    infoBox("Singapore", paste(dt), icon = icon("clock-o"), color = "red", fill = TRUE)
  })
}
