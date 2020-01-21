source("config.R")

shinyUI(fluidPage(
  includeCSS("www/styles.css"),
  useShinyjs(),  
  tags$head(tags$style("#mainplot{height:100% !important;}")),
  tags$head(tags$style(HTML('#asd :after, :#asd before{background-color:#bff442;}'))),
  
  fluidRow(
    
    
    column(
      1, 
      fluidRow(
        tags$div("Plotly", style = "font-size: 34px; text-decoration: bold;")
      ), 
      fluidRow(
        tags$div("Viz", style = "font-size: 34px; text-decoration: bold;")
      ),
      fluidRow(
        style = "height: 30%;",
        br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br()
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
            hidden(
              circleButton("btn_layout", "Layout", size = "lg")
            )
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
        fluidRow(
          column(
            12,
            hidden(
              circleButton("btn_download", icon = icon("download"), size = "lg")
            )
          )
        ),
        fluidRow(
          column(
            12,
            downloadButton("btn_download_real", label = "", class = "downloadButton", icon = NULL)
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
                textInput("layout_yaxis", "Y-axis"),
                actionButton("update_layout", "Update", class = "btn_updatelayout")
                
              )
            ),
            column(
              2,
              wellPanel(
                class = "myPanel",
                id = "gridPanel",
                h4("Grid"),
                checkboxInput("xaxisgrid", "X"),
                checkboxInput("yaxisgrid", "Y")
              )
            ),
            column(
              2,
              wellPanel(
                class = "myPanel",
                id = "colorPanel",
                h4("Colors"),
                selectInput("select_colorpal", "Select palette", 
                            choices = c("cybereon", rownames(brewer.pal.info)))
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
              plotlyOutput("mainplot", height = "40vh"),
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
