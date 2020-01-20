source("config.R")

shinyUI(fluidPage(
  includeCSS("www/styles.css"),
  useShinyjs(),  
  fluidRow(
    
    
    column(
      1, 
      fluidRow(
        style = "height: 30%;",
        br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br()
      ),
      fluidRow(
        fluidRow(
          column(
            12,
            circleButton("btn_basic", "Basic", size = "lg")
          )
        ),
        fluidRow(
          column(
            12,
            circleButton("btn_layout", "Layout", size = "lg")
          )
        ),
        fluidRow(
          column(
            12,
            circleButton("btn_showdata", "Data", size = "lg")
          )
        ),
        align = "center",
        style = "height: 100%;"
      )
    ),
    column(
      11,
      fluidRow(
        column(
          11,
          id = "basicPanelColumn",
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
          )
        ),
        
        hidden(
          column(
            11,
            id = "advancedPanelColumn", 
            selectInput("aosidj", "asipodj", choices = "aosidj")
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
        column(
          12,      
          wellPanel(
            class = "myPanel",
            id = "plotPanel",
            plotlyOutput("mainplot", width = "100%", height = "100%"),
            textOutput("plot_call")
          )
        ),
        column(
          12,
          hidden(
            wellPanel(
              class = "myPanel", 
              id = "showdataPanel",
              DT::dataTableOutput("showdata")
            )
          )
        )
      )
    )
  )
  
))
