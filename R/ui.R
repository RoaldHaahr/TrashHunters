library(leaflet)
library(scales)
shinyUI(
  
  navbarPage(
    
    
    includeCSS("www/custom.css"),
    
    
    tabPanel(
      title = "Map",
      class = "map",
      leafletOutput("map")
    ),
    
    tabPanel(
      title = "Chart",
      class = "chart",
      plotOutput("trashPlot")
    ),
    
    sidebarPanel(
      width = 2,
      class = "filter",
      dateRangeInput("daterange", NULL, start = "2015-06-01", end = Sys.Date()
),
      uiOutput("brand"),
      uiOutput("type")
    )
    
    
  )
)
  # fluidPage(
  #   tags$style(type = "text/css", "#map {height: 100vh !important;}"),
  #   fluidRow(
  #     column(
  #       width = 12,
  #       style = 'padding:0',
  #     )
  #   ),
  #   fixedRow(
  #     column(
  #       width = 2,
  #       dateInput("date1", "Date:", value = "2012-02-29"),
  #       
  #       # Default value is the date in client's time zone
  #       dateInput("date2", "Date:")
  #       
  #     )
  #   )
  # )
