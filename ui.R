library(plotly)
library(shiny)

shinyUI(fluidPage(
  useShinyjs(),  # Include shinyjs
  
  
  titlePanel("Visualization tool"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("datainput", "Choose file", multiple = FALSE, accept = NULL, width = NULL),
      uiOutput("col1"),
      uiOutput("col2"),
      uiOutput("col3"),
      uiOutput("plottype")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotlyOutput("mainplot"),
       textOutput("plot_call")
    )
  )
))
