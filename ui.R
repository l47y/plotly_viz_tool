library(plotly)
library(shiny)
library(shinydashboard)

shinyUI(fluidPage(
  theme = "styles.css",
  useShinyjs(),  # Include shinyjs
  
  fluidRow(
    
    column(
      4, 
      fileInput("datainput", "Choose file", multiple = FALSE, accept = NULL, width = NULL),
      selectInput("datainput2", "Or select from list", choices = c("None", "iris")),
      uiOutput("plottype")     
    ), 
    column(
      4,
      uiOutput("col1"),
      uiOutput("col2"),
      uiOutput("col3")
    ),
    column(
      4,
      uiOutput("plot_setup")
    )
    
  ),
  
  fluidRow(
    plotlyOutput("mainplot"),
    textOutput("plot_call")
  )
  
))
