## server.R ##

library(shiny)
library(lubridate)

server <- function(input, output, session) {
  
  output$nzTime <- renderInfoBox({
    invalidateLater(1000, session)
    dt <- format(with_tz(Sys.time(), tzone = "Pacific/Auckland"), format = "%H:%M:%S %a, %B %d, %Y")
    current.hour <- hour(with_tz(Sys.time(), tzone = "Pacific/Auckland"))
    icon <- if(current.hour > 7 & current.hour < 21) {icon("sun-o")} else {icon("moon-o")}
    infoBox("New Zealand", paste(dt), icon = icon, color = "green", fill = TRUE)
  })  
  
  output$sgTime <- renderInfoBox({
    invalidateLater(1000, session)
    dt <- format(with_tz(Sys.time(), tzone = "Asia/Singapore"), format = "%H:%M:%S %a, %B %d, %Y")
    current.hour <- hour(with_tz(Sys.time(), tzone = "Asia/Singapore"))
    icon <- if(current.hour > 7 & current.hour < 21) {icon("sun-o")} else {icon("moon-o")}
    infoBox("Singapore", paste(dt), icon = icon, color = "red", fill = TRUE)
  })
}
