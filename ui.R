library(plotly)
library(shiny)
library(shinydashboard)

shinyUI(fluidPage(
  useShinyjs(),  # Include shinyjs
  
  
  titlePanel("Visualization tool"),
  
  sidebarLayout(
    sidebarPanel(
      box(title = "asoidj", sliderInput("aoidj", "asoidjaodij", min = 100, max = 1000, value = 123)),
      fileInput("datainput", "Choose file", multiple = FALSE, accept = NULL, width = NULL),
      uiOutput("plottype"),
      uiOutput("col1"),
      uiOutput("col2"),
      uiOutput("col3"),
      uiOutput("plot_setup")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotlyOutput("mainplot"),
       textOutput("plot_call")
    )
  )
))
