library(plyr)
library(dplyr)
library(shiny)
library(streamR)
library(DT)
library(plotly)
library(sentR)


# load lexicon
positive.words <- tail(readLines("positive-words.txt"), -35)
negative.words <- tail(readLines("negative-words.txt"), -35)

shinyServer(function(input, output, session) {
  new.tweets.df <-
    reactiveFileReader(1000, session, filePath = "tweets.json", readFunc = readLines)
  old.tweets.df <-
    reactiveFileReader(1000, session, filePath = "tweets.rds", readFunc = readRDS)
  
  data <- reactive({
    # check parsing.
    check.for.tweets <- tryCatch({
      parseTweets(new.tweets.df())
    }, error = function(e) {
      readRDS("notweets.rds")
    })
    
    # if tweets exists, do stuff.
    if (dim(check.for.tweets)[1] != 0) {
      tweets.df <- check.for.tweets
      tweets.df$text       <- paste0(
        '<a href="https://twitter.com/',
        tweets.df$screen_name,
        '/status/',
        tweets.df$id_str,
        '" target="_blank">',
        tweets.df$text,
        '</a>'
      )
      tweets.df            <- tweets.df[, c("created_at",
                                            "country_code",
                                            "screen_name",
                                            "followers_count",
                                            "text")]
      tweets.df$screen_name <- paste0(
        '<a href="https://twitter.com/',
        tweets.df$screen_name,
        '" target="_blank">',
        tweets.df$screen_name,
        '</a>'
      )
      tweets.df$created_at <-
        strptime(tweets.df$created_at, "%a %b %d %H:%M:%S +0000 %Y", tz = "UTC")
      tweets.df$score      <-
        classify.aggregate(tweets.df$text, positive.words, negative.words)$score
      tweets.df$sentiment  <- as.factor(ifelse(
        tweets.df$score > 0,
        "Positive",
        ifelse(tweets.df$score < 0, "Negative", "Neutral")
      ))
      tweets.df$company    <- NA
      tweets.df$company[grep("xero", tweets.df$text, ignore.case = T)]       <-
        "Xero"
      tweets.df$company[grep("myob", tweets.df$text, ignore.case = T)]       <-
        "MYOB"
      tweets.df$company[grep("quickbooks", tweets.df$text, ignore.case = T)] <-
        "QuickBooks"
      tweets.df$company[grep("sage", tweets.df$text, ignore.case = T)]       <-
        "Sage"
      tweets.df$company <- factor(tweets.df$company,
                                  levels = c("Xero", "MYOB", "QuickBooks", "Sage"))
    }
    
    if (exists("tweets.df")) {
      tweets.df <- rbind.data.frame(old.tweets.df(), tweets.df)
    } else {
      tweets.df <- old.tweets.df()
    }
    tweets.df
  })
  
  output$tweetTable <- DT::renderDataTable({
    datatable(
      data()[nrow(data()):1,],
      escape = F,
      rownames = F,
      filter = "top",
      class = "compact hover"
    ) %>%
      formatDate('created_at', "toLocaleString") %>%
      formatStyle('company',
                  color = "white",
                  backgroundColor = styleEqual(
                    c("Xero", "MYOB", "QuickBooks", "Sage"),
                    c("#13B5EA", "#13B5EA", "#2CA01C", "#007F64")
                  ))
    
  })
  
  output$tweetPlot <- renderPlotly({
    data()[, c("company", "sentiment")] %>%
      dplyr::group_by(company, sentiment) %>%
      tally %>%
      dplyr::group_by(company) %>%
      dplyr::mutate(Perc = n / sum(n)) %>%
      plot_ly(
        x = ~ company,
        y = ~ Perc,
        color = ~ sentiment,
        type = "bar"
      ) %>%
      layout(barmode = "stack", legend = list(orientation = "h")) %>%
      config(displayModeBar = F)
  })
  
  output$dataColSince <- renderText({
    paste0("Data collected since ", min(data()$created_at), " UTC.")
  })
})
