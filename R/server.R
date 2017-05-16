# In order to install rMaps
# install.packages("devtools")
# require(devtools)
# install_github('ramnathv/rCharts@dev')
# install_github('ramnathv/rMaps')

# -----------------------Attempt using rMaps---------------------------------- 

trash <- read.csv("../Data/output.csv")
trash <- trash %>% filter(latitude != 0, latitude != 1, longitude != 0, longitude != 0)

library(rMaps)
library(leaflet)

server <- function(input, output) {
  output$map <- renderLeaflet({
    leaflet() %>%
      setView(lng = 4.897670745849609, lat = 52.37151193297624, zoom = 14) %>%
      addProviderTiles(
        providers$Stamen.TonerLite,
        options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(
        data = trash,
        clusterOptions = markerClusterOptions()
      )
  })
  
  filter_data <- reactive({
    if (!is.null(input$typeInput) && input$typeInput != 'All') {
      trash <- subset(trash, trash$type == input$typeInput)
    }
    if (!is.null(input$brandInput) && input$brandInput != 'All') {
      trash <- subset(trash, trash$brand == input$brandInput)
    }
    return (trash)
  })
  
  output$typeInput <- renderUI({
    names <- distinct(trash, type)
    selectInput("type", label = "Choose type", c("All", as.character(names$type)))
  })
  
  output$brandInput <- renderUI({
    names <- distinct(trash, brand)
    selectInput("brand", label = "Choose brand", c("All", as.character(names$brand)))
  })
  
  observeEvent(input$typeInput, {
    filter_data()
  })
}

# -----------------------Attempt using leaflet---------------------------------- 

# trash <- read.csv("../Data/output.csv")
# library(leaflet)
# 
# r_colors <- rgb(t(col2rgb(colors()) / 255))
# names(r_colors) <- colors()
# 
# server <- function(input, output, session) {
#   
#   # points <- eventReactive(input$recalc, {
#   #   cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
#   # }, ignoreNULL = FALSE)
#   # 
#   # points <- trash[,c("latitude", "longitude")]
#   
#   output$map <- renderLeaflet({
#     leaflet() %>%
#       addProviderTiles(providers$Stamen.TonerLite,
#                        options = providerTileOptions(noWrap = TRUE)
#       ) %>%
#       addMarkers(lng = trash[,"longitude"], lat = trash[,"latitude"])
#   })
# }

# -----------------------Attempt using ggplot (failed)---------------------------------- 
# 
# # This application requires the following packages ggplot2, ggmap, maps and shiny
# library(shiny)
# library(ggmap)
# library(maps)

# trash <- read.csv("../Data/output.csv")

# # https://www.r-bloggers.com/visualising-thefts-using-heatmaps-in-ggplot2/
# 
# trash$longitude <- round(as.numeric(trash$longitude), 3)
# trash$latitude <- round(as.numeric(trash$latitude), 3)
# 
# amsterdam <- get_map(location = 'Amsterdam', zoom = 13)
# 
# trashLocation <- as.data.frame(table(trash$longitude, trash$latitude))
# names(trashLocation) <- c('long', 'lat', 'freq')
# trashLocation$long <- as.numeric(as.character(trashLocation$long))
# trashLocation$lat <- as.numeric(as.character(trashLocation$lat))
# trashLocation <- subset(trashLocation, freq > 1 & long > 1 & lat > 1)
# 
# server <- function(input, output, session) {
#   output$map <- renderPlot({
#     mapPoints <- ggmap(amsterdam) + geom_tile(data = trashLocation, aes(x = long, y = lat, alpha = freq),
#                     fill = "red") + theme(axis.title.y = element_blank(), axis.title.x = element_blank())
#     mapPoints
#   })
# }
