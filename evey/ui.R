## ui.R ##

library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(),
  dashboardSidebar(
    disable = TRUE
    ),
  dashboardBody(
    fluidRow(
      infoBoxOutput("nzTime"),
      infoBoxOutput("sgTime")
    )
  )
)