# This application requires the following packages ggplot2, ggmap, maps and shiny
library(shiny)
library(ggmap)
library(maps)

trash <- read.csv("../Data/output.csv")

# https://www.r-bloggers.com/visualising-thefts-using-heatmaps-in-ggplot2/

trash$longitude <- round(as.numeric(trash$longitude), 3)
trash$latitude <- round(as.numeric(trash$latitude), 3)

amsterdam <- get_map(location = 'Amsterdam', zoom = 14)

trashLocation <- as.data.frame(table(trash$longitude, trash$latitude))
names(trashLocation) <- c('long', 'lat', 'freq')
trashLocation$long <- as.numeric(as.character(trashLocation$long))
trashLocation$lat <- as.numeric(as.character(trashLocation$lat))
trashLocation <- subset(trashLocation, freq > 1 & long > 1 & lat > 1)

server <- function(input, output, session) {
  output$map <- renderPlot({
    mapPoints <- ggmap(amsterdam) + geom_tile(data = trashLocation, aes(x = long, y = lat, alpha = freq),
                    fill = "blue") + theme(axis.title.y = element_blank(), axis.title.x = element_blank())
    mapPoints
  })
}
