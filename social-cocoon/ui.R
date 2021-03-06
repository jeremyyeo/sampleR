library(shiny)
library(plotly)
library(DT)

shinyUI(
  fluidPage(
    title = "Accounting Software Sentiment Analysis",
    
    titlePanel("Accounting Software Sentiment Analysis"),
    
    p("Updates in real time. Note: sentiment analysis wonky at best."),
    
    p("Sentiment Lexicon:",
      a("Hu and Liu, KDD-2004", href = "https://www.cs.uic.edu/~liub/FBS/sentiment-analysis.html"), 
      "."),
    
    textOutput("dataColSince"),
    
    fluidRow(column(12, plotlyOutput("tweetPlot", height = "50%"))),
    
    fluidRow(column(12, DT::dataTableOutput("tweetTable")))
  )
)
