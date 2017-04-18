library(shiny)
library(ggmap)

ui <- fluidPage(
  mainPanel(
    plotOutput("map")
  )
)