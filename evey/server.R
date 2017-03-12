## server.R ##

library(shiny)
library(lubridate)
library(plotly)

server <- function(input, output, session) {
  amberPalette <- c("#FFF8E1", "#FFECB3", "#FFE082", "#FFD54F", "#FFCA28", 
                    "#FFC107", "#FFB300", "#FFA000", "#FF8F00", "#FF6F00")
  
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
  
  # output$printleft <- renderPrint({
  #   data.frame(days    = round(d.left(), 0),
  #              hours   = round(h.left(), 0),
  #              minutes = round(m.left(), 0),
  #              seconds = s.left())
  # })
  
  totaldays <- as.numeric(
    ymd_hms("2017-04-26 11:30:00", tz = "Australia/Sydney") - 
      ymd_hms("2017-02-26 06:40:00", tz = "Pacific/Auckland") 
  )
  
  
  output$plotdleft <- renderPlotly({
    plot_ly(x = ~d.left(), y = "1", type = "bar", orientation = "h", hoverinfo = "none",
            marker = list(color = amberPalette[6], line = list(color = "black", width = 1))) %>%
      layout(xaxis = list(fixedrange = T, title = "", range = c(0, totaldays)),
             yaxis = list(fixedrange = T, showticklabels = F),
             annotations = list(x = ~d.left()/2, 
                                y = "1", 
                                text = ~trunc(d.left()), 
                                xanchor = "center",
                                showarrow = F,
                                font = list(size = 15))) %>%
      config(displayModeBar = F, staticPlot = T)
  }) 
  
  output$plothleft <- renderPlotly({
    plot_ly(x = ~h.left(), y = "1", type = "bar", orientation = "h", hoverinfo = "none",
            marker = list(color = amberPalette[7], line = list(color = "black", width = 1))) %>%
      layout(xaxis = list(fixedrange = T, title = "", range = c(0, totaldays * 24)),
             yaxis = list(fixedrange = T, showticklabels = F),
             annotations = list(x = ~h.left()/2, 
                                y = "1", 
                                text = ~trunc(h.left()), 
                                xanchor = "center",
                                showarrow = F,
                                font = list(size = 15))) %>%
      config(displayModeBar = F, staticPlot = T)
  }) 
  
  output$plotmleft <- renderPlotly({
    plot_ly(x = ~m.left(), y = "1", type = "bar", orientation = "h", hoverinfo = "none",
            marker = list(color = amberPalette[8], line = list(color = "black", width = 1))) %>%
      layout(xaxis = list(fixedrange = T, title = "", range = c(0, totaldays * 24 * 60)),
             yaxis = list(fixedrange = T, showticklabels = F),
             annotations = list(x = ~m.left()/2, 
                                y = "1", 
                                text = ~trunc(m.left()), 
                                xanchor = "center",
                                showarrow = F,
                                font = list(size = 15))) %>%
      config(displayModeBar = F, staticPlot = T)
  })
  
  output$plotsleft <- renderPlotly({
    plot_ly(x = ~s.left(), y = "1", type = "bar", orientation = "h", hoverinfo = "none",
            marker = list(color = amberPalette[9], line = list(color = "black", width = 1))) %>%
      layout(xaxis = list(fixedrange = T, title = "", range = c(0, totaldays * 24 * 60 * 60)),
             yaxis = list(fixedrange = T, showticklabels = F),
             annotations = list(x = ~s.left()/2, 
                                y = "1", 
                                text = ~trunc(s.left()), 
                                xanchor = "center",
                                showarrow = F,
                                font = list(size = 15))) %>%
      config(displayModeBar = F, staticPlot = T)
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
