## server.R ##

library(shiny)
library(lubridate)
library(plotly)
library(DT)

server <- function(input, output, session) {
  amberPalette <- c("#FFF8E1", "#FFECB3", "#FFE082", "#FFD54F", "#FFCA28", 
                    "#FFC107", "#FFB300", "#FFA000", "#FF8F00", "#FF6F00")
  
  # d.left <- reactive({
  #   invalidateLater(1000*60*60*24, session)
  #   as.numeric(
  #     ymd_hms("2017-04-26 11:30:00", tz = "Australia/Sydney") - 
  #     with_tz(Sys.time(), tzone = "Australia/Sydney")
  #   )
  # })
  # h.left <- reactive({
  #   invalidateLater(1000*60*60, session)
  #   as.numeric(
  #     ymd_hms("2017-04-26 11:30:00", tz = "Australia/Sydney") - 
  #       with_tz(Sys.time(), tzone = "Australia/Sydney")
  #   ) * 24
  # })
  # m.left <- reactive({
  #   invalidateLater(1000*60, session)
  #   as.numeric(
  #     ymd_hms("2017-04-26 11:30:00", tz = "Australia/Sydney") - 
  #       with_tz(Sys.time(), tzone = "Australia/Sydney")
  #   ) * 24 * 60
  # })
  # s.left <- reactive({
  #   invalidateLater(1000, session)
  #   as.numeric(
  #     ymd_hms("2017-04-26 11:30:00", tz = "Australia/Sydney") - 
  #       with_tz(Sys.time(), tzone = "Australia/Sydney")
  #   ) * 24 * 60 * 60
  # })
  
  time.remaining <- reactive({
    invalidateLater(1000, session)
    seconds <- 
      as.numeric(
        ymd_hms("2017-07-29 14:45:00", tz = "Pacific/Auckland") - 
          with_tz(Sys.time(), tzone = "Pacific/Auckland")
      ) * 24 * 60 * 60
    seconds_to_period(seconds)
    })
  
    
  # output$printleft <- renderPrint({
  #   data.frame(days    = round(d.left(), 0),
  #              hours   = round(h.left(), 0),
  #              minutes = round(m.left(), 0),
  #              seconds = s.left())
  # })
  
  # totaldays <- as.numeric(
  #   ymd_hms("2017-04-26 11:30:00", tz = "Australia/Sydney") - 
  #     ymd_hms("2017-02-26 06:40:00", tz = "Pacific/Auckland") 
  # )
 
  output$plottimeremaining <- renderPlotly({
    plot_ly(x = "Days", y = time.remaining()@day, type = "bar", 
            marker = list(line = list(color = "black", width = 1))) %>%
      add_trace(x = "Hours", y = time.remaining()@hour) %>%
      add_trace(x = "Minutes", y = time.remaining()@minute) %>%
      add_trace(x = "Seconds", y = time.remaining()@.Data) %>%
      layout(xaxis = list(fixedrange = T),
             yaxis = list(fixedrange = T, range = c(0, 60)),
             showlegend = F,
             annotations = list(x = c("Days", "Hours", "Minutes", "Seconds"),
                                y = c(time.remaining()@day, time.remaining()@hour, time.remaining()@minute, time.remaining()@.Data),
                                text = c(time.remaining()@day, time.remaining()@hour, time.remaining()@minute, trunc(time.remaining()@.Data)),
                                yanchor = "bottom",
                                showarrow = F,
                                font = list(size = 15))) %>%
      config(displayModeBar = F, staticPlot = T)
  })
  
  # output$plotdleft <- renderPlotly({
  #   plot_ly(x = ~d.left(), y = "1", type = "bar", orientation = "h", hoverinfo = "none",
  #           marker = list(color = amberPalette[6], line = list(color = "black", width = 1))) %>%
  #     layout(xaxis = list(fixedrange = T, title = "", range = c(0, totaldays)),
  #            yaxis = list(fixedrange = T, showticklabels = F),
  #            annotations = list(x = ~d.left()/2, 
  #                               y = "1", 
  #                               text = ~trunc(d.left()), 
  #                               xanchor = "center",
  #                               showarrow = F,
  #                               font = list(size = 15))) %>%
  #     config(displayModeBar = F, staticPlot = T)
  # }) 
  # 
  # output$plothleft <- renderPlotly({
  #   plot_ly(x = ~h.left(), y = "1", type = "bar", orientation = "h", hoverinfo = "none",
  #           marker = list(color = amberPalette[7], line = list(color = "black", width = 1))) %>%
  #     layout(xaxis = list(fixedrange = T, title = "", range = c(0, totaldays * 24)),
  #            yaxis = list(fixedrange = T, showticklabels = F),
  #            annotations = list(x = ~h.left()/2, 
  #                               y = "1", 
  #                               text = ~trunc(h.left()), 
  #                               xanchor = "center",
  #                               showarrow = F,
  #                               font = list(size = 15))) %>%
  #     config(displayModeBar = F, staticPlot = T)
  # }) 
  # 
  # output$plotmleft <- renderPlotly({
  #   plot_ly(x = ~m.left(), y = "1", type = "bar", orientation = "h", hoverinfo = "none",
  #           marker = list(color = amberPalette[8], line = list(color = "black", width = 1))) %>%
  #     layout(xaxis = list(fixedrange = T, title = "", range = c(0, totaldays * 24 * 60)),
  #            yaxis = list(fixedrange = T, showticklabels = F),
  #            annotations = list(x = ~m.left()/2, 
  #                               y = "1", 
  #                               text = ~trunc(m.left()), 
  #                               xanchor = "center",
  #                               showarrow = F,
  #                               font = list(size = 15))) %>%
  #     config(displayModeBar = F, staticPlot = T)
  # })
  # 
  # output$plotsleft <- renderPlotly({
  #   plot_ly(x = ~s.left(), y = "1", type = "bar", orientation = "h", hoverinfo = "none",
  #           marker = list(color = amberPalette[9], line = list(color = "black", width = 1))) %>%
  #     layout(xaxis = list(fixedrange = T, title = "", range = c(0, totaldays * 24 * 60 * 60)),
  #            yaxis = list(fixedrange = T, showticklabels = F),
  #            annotations = list(x = ~s.left()/2, 
  #                               y = "1", 
  #                               text = ~trunc(s.left()), 
  #                               xanchor = "center",
  #                               showarrow = F,
  #                               font = list(size = 15))) %>%
  #     config(displayModeBar = F, staticPlot = T)
  # }) 

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
    Country = c(rep("New Zealand", 7))
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
  holidays <- holidays[holidays$DaysLeft >= 0, ]
  
  output$holidayTable <- 
    DT::renderDataTable(
      datatable(
        holidays,
        filter = "top",
        class = "hover",
        options  = list(pageLength = 5,
                        lengthMenu = c(5, 10, 15, 20),
                        order = list(3, 'asc')),
        rownames = FALSE,
        extensions = "Responsive"
      ) %>%
        formatDate("Date", "toLocaleDateString") %>%
        formatStyle("Country", 
                    fontWeight = 'bold',
                    color = styleEqual(c("New Zealand", "Singapore"), c("#00a65a", "#dd4b39"))) %>%
        formatStyle("DaysLeft",
                    background = styleColorBar(c(0, holidays$DaysLeft), amberPalette[9]),
                    backgroundSize = "100% 90%",
                    backgroundRepeat = "no-repeat",
                    backgroundPosition = "center")
    )
}
