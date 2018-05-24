#' Download data from Google Trends
#'
#' This function scraps Google Trends data. Google limits the number of times
#' you can actually do this. Use this after retrieving the urlencodedstring
#' with the \code{\link{get_gt_suggestions}} function.
#'
#' @param term character term to search for.
#' @param region character ISO2 Country Code (e.g. 'NZ').
#'     Does a global search by default.
#' @return Returns a dataframe of dates and one column of trend data per search term.
#' @examples
#' download_gt("xero")
#' download_gt(c("/m/02rsj7z", "/m/08_jjs"), "NZ")
#' @seealso \code{\link{get_gt_suggestions}}
#' @export
download_gt <- function(term, region = NULL) {
  if (missing(term)) {
    stop("term argument is missing.")
  }
  if (length(region) > 0 && nchar(region) > 2) {
    stop("region argument is not in ISO2Code format. E.g. NZ, AU")
  }
  if (length(term) > 1) {
    term <- paste(term, collapse = "%2C")
  }
  geo <- if (is.null(region)) {""} else {paste0("&geo=", region)}
  base_url <- paste0("https://trends.google.com/trends/fetchComponent?q=",
                     term,
                     geo,
                     "&cid=TIMESERIES_GRAPH_0&export=3")
  raw <- RCurl::getURL(base_url)
  trends   <- gsub('\"', '', raw)
  query    <- sub('.*\\{cols:\\[(.*)\\],rows.*', '\\1', trends)
  query    <- unlist(strsplit(query, ','))
  query    <- grep("label", query, value = T)
  query    <- gsub("label:", "", query[2:length(term) + 1])
  timeline <- sub('.*rows:\\[(.*)\\]\\}\\}\\);', '\\1', trends)
  timeline <- unlist(strsplit(timeline, ']},'))
  timeline <- sapply(
    timeline,
    FUN = function(x) {
      paste(unlist(regmatches(
        x, gregexpr("f:[[:alpha:]]*\\s*[[:digit:]]*", x)
      )), collapse = ",")
    }
  )
  timeline <- unname(timeline)
  timeline <- gsub("f:", "", timeline)
  timeline <- read.csv(text = timeline, header = F, col.names = c("date", c(query[1:length(query)])))
  timeline$date <- as.Date(paste0("01 ", timeline$date), format = "%d %B %Y")
  timeline$date <- sapply(timeline$date, FUN = function(x) {seq(x, by = "month", length = 2)[2]})
  timeline$date <- as.Date(timeline$date, origin = "1970-01-01")
  timeline
}
