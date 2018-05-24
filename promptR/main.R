args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  cat("Please type an email address:\n")
  a <- readLines("stdin", n = 1)
  cat("You entered '")
  cat(as.character(a))
  cat(paste("' which has", nchar(as.character(a)), "characters.\n"))
} else {
  cat("You entered '")
  cat(as.character(args))
  cat(paste("' which has", nchar(as.character(args)), "characters.\n"))
}

