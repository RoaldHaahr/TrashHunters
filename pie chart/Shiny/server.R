
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


geodata$longitude <- (as.numeric(as.character(geodata$longitude)))
geodata$latitude <- (as.numeric(as.character(geodata$latitude)))
geodata <- geodata %>%
  group_by(longitude, latitude)%>%
  filter(longitude > 3.0) %>%
  filter(longitude < 6.0) %>%
  filter(latitude > 50.0)%>%
  filter(latitude < 54.0)




shinyServer(function(input, output) {

  output$trashPlot <- renderPlot({

    ggplot(geodata, aes(x = factor(1), fill = factor(type))) 
    + geom_bar(width = 1) + coord_polar(theta = "y")
    
 

  })

})


