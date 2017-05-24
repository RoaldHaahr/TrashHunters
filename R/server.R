# In order to install rMaps
# install.packages("devtools")
# require(devtools)
# install_github('ramnathv/rCharts@dev')
# install_github('ramnathv/rMaps')

# -----------------------Attempt using leaflet---------------------------------- 

server <- function(input, output) {
  library(shiny)
  library(ggmap)
  library(leaflet)
  library(dplyr)
  
  trash <- read.csv("../Data/output.csv")
  trash <- trash %>% filter(latitude != 0, latitude != 1, longitude != 0, longitude != 1)
  
  output$map <- renderLeaflet({
    leaflet() %>%
      setView(lng = 4.897670745849609, lat = 52.37151193297624, zoom = 14) %>%
      addProviderTiles(
        providers$Stamen.TonerLite,
        options = providerTileOptions(noWrap = TRUE)
      )
  })
  
  filtered_data <- reactive({
    filtered_trash <- trash
    if (!is.null(input$type) && as.character(input$type) != "All") {
      filtered_trash <- subset(filtered_trash, trash$type == input$type)
    }
    if (!is.null(input$brand) && as.character(input$brand) != "All") {
      filtered_trash <- subset(filtered_trash, trash$brand == input$brand)
    }
    if (!is.null(input$daterange)) {
      filtered_trash <- subset(filtered_trash, as.Date(trash$taken) >= as.Date(input$daterange[1]) 
                      & as.Date(trash$taken) <= as.Date(input$daterange[2]))
    }
    return (filtered_trash)
  })
  
  observe({
    map <<- leafletProxy("map", data = filtered_data()) %>%
      removeMarkerCluster('trash') %>%
      addMarkers(
        clusterId = 'trash',
        clusterOptions = markerClusterOptions(), 
        popup =~ paste( sep = '<br />',
          type,
          brand,
          paste("Found ", as.Date(taken))
      )
    ) 
  })
  
  
  
  output$type <- renderUI({
    names <- distinct(trash, type)
    selectInput("type", label = "Choose type", c("All", as.character(names$type)))
  })
  
  output$brand <- renderUI({
    names <- distinct(trash, brand)
    selectInput("brand", label = "Choose brand", c("All", as.character(names$brand)))
  })
  
  # observeEvent(input$type, {
  #   filtered_data()
  # })
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
