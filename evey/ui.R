## ui.R ##

library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  skin = "red",
  dashboardHeader(),
  dashboardSidebar(
    disable = TRUE
    ),
  dashboardBody(
    fluidRow(
        infoBoxOutput("nzTime", width = 6),
        infoBoxOutput("sgTime", width = 6)
    ),
    fluidRow(
      verbatimTextOutput("printleft")
    )
  )
)