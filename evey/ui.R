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
      infoBoxOutput("nzTime"),
      infoBoxOutput("sgTime")
    ),
    fluidRow(
      verbatimTextOutput("printleft")
    )
  )
)