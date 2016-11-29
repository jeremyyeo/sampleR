library(plyr)
library(dplyr)
library(shiny)
library(streamR)
library(DT)
library(plotly)
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

# data <- reactiveFileReader(1000, session, filePath = "tweets.json", readFunc = readLines)

# system("Rscript listen.R", wait = F)
shinyServer(function(input, output, session) {
  tweets.df <- reactiveFileReader(1000, session, filePath = "tweets.json", readFunc = parseTweets)
  
  data <- reactive({
    # invalidateLater(10000)
    # tweets.df           <- parseTweets(ReadLastLines("tweets.json", n = 100), verbose = F)
    tweets.df           <- tweets.df()
    tweets.df$text      <- paste0('<a href="https://twitter.com/', 
                                  tweets.df$screen_name, 
                                  '/status/',
                                  tweets.df$id_str,
                                  '" target="_blank">',
                                  tweets.df$text,
                                  '</a>')
    tweets.df           <- tweets.df[, c("created_at", "country_code", "screen_name", "followers_count", "text")]
    tweets.df$created_at <- strptime(tweets.df$created_at, "%a %b %d %H:%M:%S +0000 %Y", tz = "UTC")
    tweets.df$score     <- classify.aggregate(tweets.df$text, positive.words, negative.words)$score
    tweets.df$sentiment <- as.factor(ifelse(tweets.df$score > 0, "Positive", ifelse(tweets.df$score < 0, "Negative", "Neutral")))
    tweets.df$company   <- NA
    tweets.df$company[grep("@xero", tweets.df$text, ignore.case = T)]       <- "Xero"
    tweets.df$company[grep("@myob", tweets.df$text, ignore.case = T)]       <- "MYOB"
    tweets.df$company[grep("@quickbooks", tweets.df$text, ignore.case = T)] <- "QuickBooks"
    tweets.df$company[grep("@sage", tweets.df$text, ignore.case = T)]       <- "Sage"
    tweets.df$company <- factor(tweets.df$company, levels = c("Xero", "MYOB", "QuickBooks", "Sage"))
    tweets.df
  })
  
  output$tweetTable <- renderDataTable({
    
    datatable(data()[nrow(data()):1, ], escape = F, rownames = F, filter = "top") %>%
      formatDate('created_at', "toLocaleString") %>%
      formatStyle('company', 
                  color = "white", 
                  backgroundColor = styleEqual(c("Xero", "MYOB", "QuickBooks", "Sage"), 
                                               c("#13B5EA", "#13B5EA", "#2CA01C", "#007F64")))
    
  })
  
  output$tweetPlot <- renderPlotly({
    data()[, c("company", "sentiment")] %>% 
      dplyr::group_by(company, sentiment) %>%
      tally %>%
      dplyr::group_by(company) %>%
      dplyr::mutate(Perc = n/sum(n)) %>%
      plot_ly(x = ~company, y = ~Perc, color = ~sentiment, type = "bar") %>%
      layout(barmode = "stack", legend = list(orientation = "h")) %>% 
      config(displayModeBar = F)
  })

})
