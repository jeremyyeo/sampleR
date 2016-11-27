

# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  title = "Xero Mentions on Twitter Sentiment Analysis",
  titlePanel("Xero Mentions on Twitter Sentiment Analysis"),
  plotlyOutput('tweetPlot'),
  hr(),
  dataTableOutput('tweetTable')
))