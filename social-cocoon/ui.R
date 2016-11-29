library(shiny)
library(plotly)

shinyUI(
  fluidPage(
    title = "Accounting Software Sentiment Analysis",
    titlePanel("Xero vs Competitor Mentions on Twitter Sentiment Analysis"),
    p("Updates in real time. Note: sentiment analysis wonky at best."),
    p("Sentiment Lexicon:",
      a("Hu and Liu, KDD-2004", 
        href = "https://www.cs.uic.edu/~liub/FBS/sentiment-analysis.html"), "."),
    plotlyOutput("tweetPlot"),
    hr(),
    dataTableOutput("tweetTable")
  )
)
