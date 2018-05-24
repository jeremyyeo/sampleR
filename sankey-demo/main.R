require(googleVis)

df <- read.csv("data2.csv")

plot(
  gvisSankey(
    df,
    from    = "from",
    to      = "to",
    weight  = "count",
    options = list(
      # height = "2000", 
      # width = "2000",
      sankey = "{iterations: 0, 
                 link: {colorMode: 'none'}, 
                 node: {nodePadding: 80, interactivity: true}}"
    )
  )
)
