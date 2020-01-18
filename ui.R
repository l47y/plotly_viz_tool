source("config.R")

shinyUI(fluidPage(
  includeCSS("www/styles.css"),
  useShinyjs(),  
  fluidRow(
    

    title = "Basic",
    column(
      4, 
      wellPanel(
        class = "myPanel",
        id = "filePanel",
        h4("Choose data", class = "panelHeader"),
        fileInput("datainput", "Choose file", multiple = FALSE, accept = NULL, width = NULL),
        selectInput("datainput2", "Or select from list", choices = c("None", "iris")),
        uiOutput("plottype")   
      )
    ), 
    column(
      4,
      wellPanel(
        class = "myPanel", 
        id = "columnPanel",
        h4("Select columns"),
        uiOutput("col1"),
        uiOutput("col2"),
        uiOutput("col3")
      )
    ),
    column(
      3,
      wellPanel(
        h4("Setup for plot"),
        class = "myPanel",
        id = "setupPanel",
        uiOutput("plot_setup")
      )
    ),
    column(
      1,
      circleButton(
        inputId = "minimizeButton", 
        label = "minimize",
        icon = icon("arrow-up"),
        class = "minButton"
      )
    )
      
    
  ),
    
  
  fluidRow(
    wellPanel(
      class = "myPanel",
      plotlyOutput("mainplot", width = "100%", height = "100%"),
      textOutput("plot_call")
    )
  )
  
))
