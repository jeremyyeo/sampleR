library("TSP")
data("USCA312")
tsp <- insert_dummy(USCA312, label = "cut")
tsp
tour <- solve_TSP(tsp, method="farthest_insertion")
tour
path <- cut_tour(tour, "cut")

library("maps")
library("sp")
library("maptools")
data("USCA312_map")
plot_path <- function(path){
plot(as(USCA312_coords, "Spatial"), axes = TRUE)
plot(USCA312_basemap, add = TRUE, col = "gray")
points(USCA312_coords, pch = 3, cex = 0.4, col = "red")

path_line <- SpatialLines(list(Lines(list(Line(USCA312_coords[path,])),
                                     ID="1")))
plot(path_line, add=TRUE, col = "black")
points(USCA312_coords[c(head(path,1), tail(path,1)),], pch = 19,
       col = "black")
}
plot_path(path)
