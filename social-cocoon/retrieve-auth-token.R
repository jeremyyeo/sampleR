# Use this to retrieve oauth.file if it doesn't already exist.
# listen.R does not work without a valid oauth.file.

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
