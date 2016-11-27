library(ROAuth)
library(streamR)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- ""
consumerSecret <- ""
my_oauth <- OAuthFactory$new(consumerKey = consumerKey, consumerSecret = consumerSecret,
                             requestURL = requestURL, accessURL = accessURL, authURL = authURL)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
save(my_oauth, file = ".httr-oauth")

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


  



  plot_ly(x = ~Company)