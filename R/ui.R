shinyUI(
  fluidPage(
    
    includeCSS("www/custom.css"),
    
    div(
      class = "map",
      leafletOutput("map")
    ),
    sidebarPanel(
      width = 2,
      class = "filter",
      dateRangeInput("daterange", NULL, start = "2015-05-31", end = "2016-03-11"),
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
