
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(ggmap)
library(dplyr)

geodata <- read.csv('csv//output.csv')

#data$taken <- strptime(data$taken, format = '%Y/%d/%m %I:%M:%S %p')

#data$Day <- weekdays(data$Date)
#data$Hour <- data$Date$hour

#amsterdam <- get_map(location = 'Amsterdam', zoom = 8)

#trashLocations <- as.data.frame(table(data$longitude, data$latitude))

#names(data) <- c('long', 'lat', 'freq')
geodata$longitude <- (as.numeric(as.character(geodata$longitude)))
geodata$latitude <- (as.numeric(as.character(geodata$latitude)))
geodata <- geodata %>%
  group_by(longitude, latitude)%>%
  filter(longitude > 3.0) %>%
  filter(longitude < 6.0) %>%
  filter(latitude > 50.0)%>%
  filter(latitude < 54.0)


#geodata <- rename(count(geodata, longitude, latitude), freq = n) %>%
  #arrange(desc(freq))
#names(geodata) <- c('long', 'lat', 'freq')


shinyServer(function(input, output) {

  output$trashPlot <- renderPlot({

    ggplot(geodata, aes(x = factor(1), fill = factor(type))) + geom_bar(width = 1) + coord_polar(theta = "y")
    
    #ggmap(amsterdam) + 
     # geom_tile(data = geodata, 
      #          aes(x = longitude, 
       #             y = latitude,
        #            alpha = freq
         #           ),
          #      fill = 'red') + 
      #theme(axis.title.y = element_blank(), 
       #     axis.title.x = element_blank())

  })

})


