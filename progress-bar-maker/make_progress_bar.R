suppressMessages(require(ggplot2))
suppressMessages(require(grid))
# plot with stuff to see

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  cat("Please enter some numbers to generate your progress bar.\nTry 'rscript make_progress_bar.R 90' or 'rscript make_progress_bar.R 40 60'\n")
} else {
  for (i in 1:length(args)) {
    print(as.numeric(args[[i]]))
    num <- as.numeric(args[[i]])
    perc.text <- paste(as.character(args[[i]]), "%", sep = "")
    
    # plot without stuff
    d <- data.frame(x1=c(0,num), x2=c(num,100), y1=c(0,0), y2=c(20,20), t=c('a','b'), r = c(perc.text,''))
    p <- ggplot() + 
      scale_x_continuous(name="x", expand = c(0,0)) + 
      scale_y_continuous(name="y", expand = c(0,0)) +
      coord_cartesian(xlim=c(0,100), ylim=c(0,100)) +
      coord_fixed() +
      geom_rect(data=d, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2, fill = t), color="black", alpha=1) +
      geom_text(data=d, aes(x=x1+(x2-x1)/2, y=y1+(y2-y1)/2, label=r), color="white", size=20) +
      theme(
        axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank(),
        plot.margin=unit(c(0,0,0,0), "cm"),
        panel.margin=unit(c(0,0,0,0), "cm"),
        legend.position="none")
    
    ggsave(paste("progressbar", as.character(num), ".png", sep = ""), width = 12, height = 2.5)
  }
}




