messageslack <- function(message, verbose = F) {
  # Sends a character string to specific slack channel.
  # Requires a slack webhook token
  if (!is.character(message)) {
    stop("message argument is not of type: character.")
  }

  request <-
    httr::POST(url    = readLines(".slackwebhooktoken"),
               body   = list(text = message),
               encode = "json")

  if (verbose == T) {
    print(request)
  }
}
