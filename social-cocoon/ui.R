library(shiny)
library(plotly)

shinyUI(
  fluidPage(
    title = "Accounting Software Sentiment Analysis",
    # titlePanel("Xero Mentions on Twitter Sentiment Analysis"),
    plotlyOutput("tweetPlot"),
    hr(),
    dataTableOutput("tweetTable")
  )
)
