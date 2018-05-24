#' Get suggestions and URL encoded string from Google Trends
#'
#' This function searches the Google Trends API for suggested terms and their
#' URL encoded strings and type. For example, searching for 'xero' in
#' Google Trends will result in the suggestions: (Xero, Software Company, /m/02rsj7z)
#' and (Xerox, Corporation, /m/087c7) among others.
#'
#' @param term character term to search for.
#' @return dataframe Returns a dataframe of suggested terms, type and urlencodedstring.
#' @examples
#' get_google_trends_suggestions("xero")
#' @export
get_gt_suggestions <- function(term) {
  if (missing(term)) {
    stop("term argument is missing.")
  }
  base_url <- paste0("https://trends.google.com/trends/api/autocomplete/", term)
  raw      <- RCurl::getURL(base_url)
  raw      <- gsub(")]}',\n", "", raw)
  raw      <- jsonlite::fromJSON(raw)$default$topics
  colnames(raw) <- c("urlencodedstring", "term", "type")
  raw
}
