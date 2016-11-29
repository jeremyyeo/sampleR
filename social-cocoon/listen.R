require(streamR)
# print("test")
load(".httr-oauth")
file.remove("tweets.json")
filterStream(
  file.name = "tweets.json",
  track = c("@xero", "@myob", "@quickbooks", "@sage"),
  language = "en",
  timeout = 0,
  oauth = my_oauth
)
