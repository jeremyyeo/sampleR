messageslack <- function(message, verbose = F) {
  # Sends a character string to specific slack channel.
  # Requires a slack webhook token: https://api.slack.com/incoming-webhooks
  if (!is.character(message)) {
    stop("message argument is not of type: character.")
  }

  if (!file.exists(".slackwebhooktoken")) {
    stop("webhook token does not exist.")
  }

  request <-
    httr::POST(url    = readLines(".slackwebhooktoken"),
               body   = list(text = message),
               encode = "json")

  if (verbose == T) {
    print(request)
  }
}
