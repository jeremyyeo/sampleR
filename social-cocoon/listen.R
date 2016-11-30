require(streamR)


load(".httr-oauth")  # load oauth file.

repeat {
  # listen to tweets and write to .json file.
  # get rid of file when it becomes too large.
  # file.remove("tweets.json")
  filterStream(
    file.name = "tweets.json",
    track     = c("@xero", "@myob", "@quickbooks", "@sage"),
    language  = "en",
    timeout   = 0,
    tweets    = 10,
    oauth     = oauth.file
  )
  
}
