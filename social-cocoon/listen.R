require(streamR)
require(sentR)

load(".httr-oauth")  # load oauth file.

# load lexicon for sentiment
positive.words <- tail(readLines("positive-words.txt"), -35)
negative.words <- tail(readLines("negative-words.txt"), -35)

repeat {
  # listen to tweets and write to .json file.
  # get rid of file when it becomes too large.
  # file.remove("tweets.json")  # enable this on server.
  filterStream(
    file.name = "tweets.json",
    track     = c("@xero", "@myob", "@quickbooks", "@sage"),
    language  = "en",
    timeout   = 0,
    tweets    = 10,
    oauth     = oauth.file
  )
  
  # get old tweets if exist, if not build empty old.tweets.df
  if (file.exists("tweets.rds")) {
    old.tweets.df <- readRDS("tweets.rds")
  } else {
    old.tweets.df <- readRDS("notweets.rds")
  }
  
  # try parsing new tweets.
  # on error, read blank rds file.
  check.for.tweets <- tryCatch({
    parseTweets("tweets.json")
  }, error = function(e) {
    readRDS("notweets.rds")
  })
  
  # if tweets exists, do stuff.
  if (dim(check.for.tweets)[1] != 0) {
    new.tweets.df <- check.for.tweets
    new.tweets.df$text       <- paste0(
      '<a href="https://twitter.com/',
      new.tweets.df$screen_name,
      '/status/',
      new.tweets.df$id_str,
      '" target="_blank">',
      new.tweets.df$text,
      '</a>'
    )
    
    new.tweets.df            <- new.tweets.df[, c("created_at",
                                                  "country_code",
                                                  "screen_name",
                                                  "followers_count",
                                                  "text")]
    new.tweets.df$screen_name <- paste0(
      '<a href="https://twitter.com/',
      new.tweets.df$screen_name,
      '" target="_blank">',
      new.tweets.df$screen_name,
      '</a>'
    )
    new.tweets.df$created_at <-
      strptime(new.tweets.df$created_at, "%a %b %d %H:%M:%S +0000 %Y", tz = "UTC")
    new.tweets.df$score      <-
      classify.aggregate(new.tweets.df$text, positive.words, negative.words)$score
    new.tweets.df$sentiment  <- as.factor(ifelse(
      new.tweets.df$score > 0,
      "Positive",
      ifelse(new.tweets.df$score < 0, "Negative", "Neutral")
    ))
    new.tweets.df$company    <- NA
    new.tweets.df$company[grep("xero", new.tweets.df$text, ignore.case = T)]       <-
      "Xero"
    new.tweets.df$company[grep("myob", new.tweets.df$text, ignore.case = T)]       <-
      "MYOB"
    new.tweets.df$company[grep("quickbooks", new.tweets.df$text, ignore.case = T)] <-
      "QuickBooks"
    new.tweets.df$company[grep("sage", new.tweets.df$text, ignore.case = T)]       <-
      "Sage"
    new.tweets.df$company <- factor(new.tweets.df$company,
                                    levels = c("Xero", "MYOB", "QuickBooks", "Sage"))
  }
  
  if (exists("new.tweets.df")) {
    old.tweets.df <- rbind.data.frame(old.tweets.df, new.tweets.df)
  } else {
    old.tweets.df <- old.tweets.df
  }
  
  saveRDS(old.tweets.df, "tweets.rds")
  
}
