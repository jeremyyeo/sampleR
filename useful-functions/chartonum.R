# converts text representation of numbers into actual numeric format.
# e.g. "one hundred" to 100, "five thousand and five" to 5005
# source: https://github.com/ghewgill/text2num

small <- 
  c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
    11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
    30, 40, 50, 60, 70, 80, 90)
names(small) <-
  c("zero", "one", "two", "three", "four", "five",
    "six", "seven", "eight", "nine", "ten",
    "eleven", "twelve", "thirteen", "fourteen", "fifteen",
    "sixteen", "seventeen", "eighteen", "nineteen", "twenty",
    "thirty", "fourty", "fifty", "sixty", "seventy", "eighty", "ninety")
magnitude <-
  c(1000,
    1000000,
    1000000000,
    1000000000000,
    1000000000000000,
    1000000000000000000,
    1000000000000000000000,
    1000000000000000000000000,
    1000000000000000000000000000,
    1000000000000000000000000000000,
    1000000000000000000000000000000000)
names(magnitude) <-
  c("thousand",
    "million",
    "billion",
    "trillion",
    "quadrillion",
    "quintillion",
    "sextillion",
    "septillion",
    "octillion",
    "nonillion",
    "decillion")

chartonum <- function(x) {
  a <- unlist(strsplit(x, " "))
  a <- a[a != "and"]
  n <- 0
  g <- 0
  for (i in a) {
    x <- as.numeric(small[match(i, names(small))])
    if (!is.na(x)) {
      g <- g + x
    } else if (i == "hundred" & g != 0) {
      g <- g * 100
    } else {
      x <- as.numeric(magnitude[match(i, names(magnitude))])
      if (!is.na(x)) {
        n <- n + (g * x)
        g <- 0
      } else {
        stop("Unknown number: ", i)
      }
    }
  }
  return(n + g)
}
