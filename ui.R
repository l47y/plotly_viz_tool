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
        id = "filePanelid",
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
        id = "columnPanelid",
        h4("Select columns"),
        uiOutput("col1"),
        uiOutput("col2"),
        uiOutput("col3")
      )
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
