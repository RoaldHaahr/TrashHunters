library(shiny)
library(ggmap)
library(maps)

trash <- read.csv("../Data/output.csv")

# https://www.r-bloggers.com/visualising-thefts-using-heatmaps-in-ggplot2/
## Removing empty locations
# trash <- na.omit(trash)

## Splitting location into latitude and longitude
# chicagoMVT % extract(Location, c('Latitude', 'Longitude'), '\(([^,]+), ([^)]+)\)')
trash$longitude <- round(as.numeric(trash$longitude), 2)
trash$latitude <- round(as.numeric(trash$latitude), 2)

# chicagoMVT <- extract(chicagoMVT, Location, c('Latitude', 'Longitude'), '\(([^,]+), ([^)]+)\)')

amsterdam <- get_map(location = 'Amsterdam', zoom = 12)

trashLocation <- as.data.frame(table(trash$longitude, trash$latitude))
names(trashLocation) <- c('long', 'lat', 'freq')
trashLocation$long <- as.numeric(as.character(trashLocation$long))
trashLocation$lat <- as.numeric(as.character(trashLocation$lat))
trashLocation <- subset(trashLocation, freq > 1 & long > 1 & lat > 1)

server <- function(input, output, session) {
  output$map <- renderPlot({
    mapPoints <- ggmap(amsterdam) + geom_tile(data = trashLocation, aes(x = long, y = lat, alpha = freq),
                    fill = "blue")
    mapPoints
    # + theme(axis.title.y = element_blank(), axis.title.x = element_blank())
  })
}
