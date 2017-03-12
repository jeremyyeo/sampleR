## ui.R ##

library(shiny)
library(shinydashboard)
library(plotly)

ui <- dashboardPage(
  skin = "red",
  dashboardHeader(title = icon("heart")),
  dashboardSidebar(
    disable = TRUE
    ),
  dashboardBody(
    fluidRow(
        infoBoxOutput("sgTime", width = 6),
        infoBoxOutput("nzTime", width = 6)
    ),
    fluidRow(
      box(width = 12, solidHeader = T, h5("Countdown to Sydney", align = "center"))
    ),
    fluidRow(
      box(title = "Days Left", status = "danger",
          width = 3, solidHeader = T, collapsible = F,
          style = "padding:0px;",
          plotlyOutput("plotdleft", height = "150px")
      ),
      box(title = "Hours Left", status = "danger",
          width = 3, solidHeader = T, collapsible = F,
          style = "padding:0px;",
          plotlyOutput("plothleft", height = "150px")
      ),
      box(title = "Minutes Left", status = "danger",
          width = 3, solidHeader = T, collapsible = F,
          style = "padding:0px;",
          plotlyOutput("plotmleft", height = "150px")
      ),
      box(title = "Seconds Left", status = "danger",
          width = 3, solidHeader = T, collapsible = F,
          style = "padding:0px;",
          plotlyOutput("plotsleft", height = "150px")
      ) 
    ),
    fluidRow(
      box(width = 12, solidHeader = T, h5("Weather Forecast", align = "center"))
    )
  )
)