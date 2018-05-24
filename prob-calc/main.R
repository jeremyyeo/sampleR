deck_size              <- 60
resource_to_deck_ratio <- 1 / 3
resource_count         <- deck_size * resource_to_deck_ratio
resource_draw_cut_off  <- 3
max_hand_size          <- 7
min_hand_size          <- 6

sample_max   <- 1000000
sample_sizes <- seq(1, sample_max, by = 10000)

deck <- c(
  rep(0, deck_size - resource_count),
  rep(1, resource_count)
)

play <- function() {
  draw <- sample(deck, max_hand_size, replace = F)
  
  if (sum(draw) <= resource_draw_cut_off) {
    max_hand_size <- max_hand_size - 1
    
    if (max_hand_size >= min_hand_size) {
      draw <- sample(deck, max_hand_size, replace = F)
    }
    
  }
  # print(draw)
  perc <- sum(draw) / max_hand_size
  perc
}

simulate <- function(x) {
  var(replicate(x, play()))
}

variances <- sapply(sample_sizes, simulate)

plot(sample_sizes, variances, type = "l")
