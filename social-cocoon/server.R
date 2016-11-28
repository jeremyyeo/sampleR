library(shiny)
library(streamR)
library(DT)
library(plotly)
library(dplyr)
library(sentR)


ReadLastLines <- function(x, n, ...) {
  con <- file(x)
  open(con)
  out <-
    scan(con,
         n,
         what = "char(0)",
         sep = "\n",
         quiet = TRUE,
         ...)
  
  while (TRUE) {
    tmp <- scan(con,
                1,
                what = "char(0)",
                sep = "\n",
                quiet = TRUE)
    if (length(tmp) == 0) {
      close(con)
      break
    }
    out <- c(out[-1], tmp)
  }
  out
}

positive.words <- tail(readLines("positive-words.txt"), -35)
negative.words <- tail(readLines("negative-words.txt"), -35)

# system("Rscript listen.R", wait = F)
shinyServer(function(input, output) {

  data <- reactive({
    invalidateLater(10000)
    tweets.df           <- parseTweets(ReadLastLines("tweets.json", n = 100), verbose = F)
    tweets.df           <- tweets.df[, c("country_code", "screen_name", "followers_count", "text", "created_at")]
    tweets.df$score     <- classify.aggregate(tweets.df$text, positive.words, negative.words)$score
    tweets.df$sentiment <- ifelse(tweets.df$score > 0, "Positive", ifelse(tweets.df$score < 0, "Negative", "Neutral"))
    tweets.df$company   <- NA
    tweets.df$company[grep("@xero", tweets.df$text, ignore.case = T)]       <- "Xero"
    tweets.df$company[grep("@myob", tweets.df$text, ignore.case = T)]       <- "MYOB"
    tweets.df$company[grep("@quickbooks", tweets.df$text, ignore.case = T)] <- "QuickBooks"
    tweets.df$company[grep("@sage", tweets.df$text, ignore.case = T)]       <- "Sage"
    tweets.df
  })
  
  output$tweetTable <- renderDataTable({
    tail(data()[nrow(data()):1, ], 20)
  })
  
  output$tweetPlot <- renderPlotly({
    data()[, c("company", "sentiment")] %>% 
      group_by(company, sentiment) %>%
      tally %>%
      group_by(company) %>%
      mutate(Perc = n/sum(n)) %>%
      plot_ly(x = ~company, y = ~Perc, color = ~sentiment, type = "bar") %>%
      layout(barmode = "stack") %>% 
      config(displayModeBar = F)
  })

})
