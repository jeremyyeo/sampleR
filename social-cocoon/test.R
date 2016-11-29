library(ROAuth)
library(streamR)


requestURL     <- "https://api.twitter.com/oauth/request_token"
accessURL      <- "https://api.twitter.com/oauth/access_token"
authURL        <- "https://api.twitter.com/oauth/authorize"
consumerKey    <- ""
consumerSecret <- ""

oauth.file <-
  OAuthFactory$new(
    consumerKey = consumerKey,
    consumerSecret = consumerSecret,
    requestURL = requestURL,
    accessURL = accessURL,
    authURL = authURL
  )

oauth.file$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

if (!file.exists(".httr-oauth")) {
  save(oauth.file, file = ".httr-oauth")
}

# file.remove("tweets.json")
# filterStream("tweets2.json", timeout = 60, track = "DietCoke",  oauth = my_oauth)
# system("Rscript listen.R", wait = F)
# # filterStream("tweets.json", track = "@Coke", timeout = 120, oauth = my_oauth)
# 
# tweets.df <- parseTweets("tweets.json", verbose = FALSE)
# tweets.df <- tweets.df[grep("@coke", tweets.df$text, ignore.case = TRUE), ]

x <- data.frame(Company = c("Xero", "Xero", "Xero", "MYOB", "MYOB", "MYOB"),
                Sentiment = c("Positive", "Negative", "Positive", "Positive", "Neutral", "Neutral"))

x %>%
  group_by(Company, Sentiment) %>%
  tally %>%
  group_by(Company) %>%
  mutate(Perc = n/sum(n)) %>%
  plot_ly(x = ~Company, y = ~Perc, color = ~Sentiment, type = "bar") %>%
  layout(barmode = "stack")

tweets.df           <- parseTweets(ReadLastLines("tweets.json", n = 100), verbose = F)
tweets.df           <- tweets.df[, c("country_code", "screen_name", "followers_count", "text", "created_at")]
tweets.df$score     <- classify.aggregate(tweets.df$text, positive.words, negative.words)$score
tweets.df$sentiment <- ifelse(tweets.df$score > 0, "Positive", ifelse(tweets.df$score < 0, "Negative", "Neutral"))
tweets.df$company   <- NA
tweets.df$company[grep("@xero", tweets.df$text, ignore.case = T)]       <- "Xero"
tweets.df$company[grep("@myob", tweets.df$text, ignore.case = T)]       <- "MYOB"
tweets.df$company[grep("@quickbooks", tweets.df$text, ignore.case = T)] <- "QuickBooks"
tweets.df$company[grep("@sage", tweets.df$text, ignore.case = T)]       <- "Sage"



# Not run: ------------------------------------
# Per-session reactive file reader
function(input, output, session) {
  fileData <- reactiveFileReader(1000, session, 'data.csv', read.csv)
  
  output$data <- renderTable({
    fileData()
  })
}

# Cross-session reactive file reader. In this example, all sessions share
# the same reader, so read.csv only gets executed once no matter how many
# user sessions are connected.
fileData <- reactiveFileReader(1000, session, 'data.csv', read.csv)
function(input, output, session) {
  output$data <- renderTable({
    fileData()
  })
}
# ---------------------------------------------