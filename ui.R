source("config.R")

shinyUI(fluidPage(
 
  # Initial settings of app 
  includeCSS("www/styles.css"),
  useShinyjs(),  
  tags$head(tags$style("#mainplot{height:100% !important;}")),

  fluidRow(
    # --------------------
    # One column for the left menu and logo
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
        br(), br(), br(), br(), br(), br(), br(), br()
      ),
      hidden(
        fluidRow(
          id = "btn_row", 
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
              circleButton("btn_showdata", "Data", size = "lg")
            )
          ),
          fluidRow(
            column(
              12,
              circleButton("btn_download", icon = icon("download"), size = "lg")
            )
          ),
          fluidRow(
            column(
              12,
              # Trick to use another "transparent" thus invisible button which is clicked, because
              # hidden elements cant be clicked (or at least I found no way to do it). This is done
              # because I want all the left buttons to be equally styled and the download button per se
              # looks very different from the others. 
              downloadButton("btn_download_real", label = "", class = "downloadButton", icon = NULL)
            )
          ),
          align = "center",
          style = "height: 100%;"
        )
      )
    ),
    # --------------------
    # 11 columns for the rest of the app 
    column(
      11,
      # -------------------
      # First row contains the settings panels and will be divided again in 11 / 1 columns
      fluidRow(
        # -----------------------
        # Using 11 columns for the actual panels  
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
          # -----------------------
          # Using 1 columm for the minimize button 
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
    
      #-----------------------
      # ----- Row for plot and table 
      
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
