## app.R ##
library(shinydashboard)
library(shiny)
library(DT)

shinyUI(dashboardPage(
  skin = "red",
  
  dashboardHeader(title = "Have Burger, Will Travel"),
  
  dashboardSidebar(),
  
  dashboardBody(# Boxes need to be put in a row (or column)
    fluidRow(
      box(plotOutput("plot1", height = 250)),
      
      box(
        title = "Controls",
        sliderInput("slider", "Number of observations:", 1, 100, 50)
      )
    ),
    
    fluidRow(
      box(width = 12, dataTableOutput('testtable'))
    ))
))
