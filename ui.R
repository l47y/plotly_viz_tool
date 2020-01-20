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
            circleButton("btn_basic", icon = icon("home"), size = "lg")
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
            hidden(
              circleButton("btn_showdata", "Data", size = "lg")
            )
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
            hidden(
              wellPanel(
                class = "myPanel", 
                id = "columnPanel",
                h4("Select columns"),
                uiOutput("col1"),
                uiOutput("col2"),
                uiOutput("col3")
              )
            )
          ),
          column(
            4,
            hidden(
              wellPanel(
                h4("Setup for plot"),
                class = "myPanel",
                id = "setupPanel",
                uiOutput("plot_setup")
              )
            )
          )
        ),
        
        hidden(
          column(
            11,
            id = "advancedPanelColumn", 
            column(
              4,
              wellPanel(
                class = "myPanel",
                id = "axisAndTitlePanel",
                h4("Axis and title"),
                textInput("layout_title", "Title"),
                textInput("layout_xaxis", "X-axis"),
                textInput("layout_yaxis", "Y-axis")
              )
            ),
            column(
              4,
              wellPanel(
                class = "myPanel", 
                id = "updateLayoutPanel",
                actionButton("update_layout", "Update", class = "btn_updatelayout")
              )
              
            )
          )
        ),
        
        column(
          1,
          hidden(
            circleButton(
              inputId = "minimizeButton", 
              label = "minimize",
              icon = icon("arrow-up"),
              class = "minButton"
            )
          )
        )
      ),
    
      fluidRow(
        column(
          12,  
          hidden(
            wellPanel(
              class = "myPanel",
              id = "plotPanel",
              plotlyOutput("mainplot", width = "100%", height = "100%"),
              textOutput("plot_call")
            )
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
