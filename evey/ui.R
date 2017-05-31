## ui.R ##

library(shiny)
library(shinydashboard)
library(plotly)
library(DT)

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
      box(title = "Countdown to Tai Tai Life", status = "danger",
          width = 12, solidHeader = T, style = "padding:0px;",
          plotlyOutput("plottimeremaining")
      )
    ),
    # fluidRow(
    #   box(title = "Days Left", status = "danger",
    #       width = 3, solidHeader = T, collapsible = F,
    #       style = "padding:0px;",
    #       plotlyOutput("plotdleft", height = "150px")
    #   ),
    #   box(title = "Hours Left", status = "danger",
    #       width = 3, solidHeader = T, collapsible = F,
    #       style = "padding:0px;",
    #       plotlyOutput("plothleft", height = "150px")
    #   ),
    #   box(title = "Minutes Left", status = "danger",
    #       width = 3, solidHeader = T, collapsible = F,
    #       style = "padding:0px;",
    #       plotlyOutput("plotmleft", height = "150px")
    #   ),
    #   box(title = "Seconds Left", status = "danger",
    #       width = 3, solidHeader = T, collapsible = F,
    #       style = "padding:0px;",
    #       plotlyOutput("plotsleft", height = "150px")
    #   ) 
    # ),
    fluidRow(
      box(title = "Holiday Calendar", status = "danger", 
          width = 12, solidHeader = T, 
          DT::dataTableOutput("holidayTable")
      )
    )
  )
)