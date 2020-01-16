library(shinyjs)
library(shiny)
library(readr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  mydata <- reactiveVal(NULL)
  last_plot_call <- reactiveVal(NULL)
  
  observe ({
    if (!is.null(input$datainput)) {
      mydata(read_csv(input$datainput$datapath))
    }
   })
  
  observe({
    if (length(input$selectplottype) > 0) {
      if (input$selectplottype %in% c("histogram", "pie")) {
        shinyjs::hide("selectcol2")
      } else {
        shinyjs::show("selectcol2")
      }
    }
  })
  
  
  output$col1 <- renderUI({
    if (!is.null(input$datainput)) {
      selectInput("selectcol1", "x-column", choices = colnames(mydata()))
    }
  })
  
  output$col2 <- renderUI({
    if (!is.null(input$datainput)) {
      selectInput("selectcol2", "y-column", choices = colnames(mydata()))
    }
  })
  
  output$col3 <- renderUI({
    if (!is.null(input$datainput)) {
      selectInput("selectcol3", "color-column", choices = c("None", colnames(mydata())))
    }
  })
  
  output$plottype <- renderUI({
    if (!is.null(input$datainput)) {
      selectInput("selectplottype", "Type of plot", choices = c("scatter", "bar", "histogram", "pie"))
    }
  })
  
  output$mainplot <- renderPlotly({
    if (is.null(input$datainput)) {
      return(NULL)    
    }
    tmp <- mydata()
    
    if (input$selectplottype == "scatter") {
      p <- expr(plot_ly(
        x = tmp[[input$selectcol1]],
        y = tmp[[input$selectcol2]], 
        type = "scatter", 
        color = tmp[[input$selectcol3]],
        mode = input$scatter_mode
      ))
    } else if (input$selectplottype == "bar") {
      p <- expr(plot_ly(
        x = tmp[[input$selectcol1]],
        y = tmp[[input$selectcol2]], 
        type = "bar", 
        color = tmp[[input$selectcol3]]
      ))
    } else if (input$selectplottype == "histogram") {
      p <- expr(plot_ly(
        x = tmp[[input$selectcol1]],
        type = "histogram", 
        color = tmp[[input$selectcol3]]
      ))
    } else if (input$selectplottype == "pie") {
      p <- expr(plot_ly(
        labels = tmp[[input$selectcol1]],
        values = tmp[[input$selectcol1]],
        type = "pie"
      ))
    }
    last_plot_call(deparse(p))
    eval(p)
    
  })
  
  output$plot_call <- renderText({
    print(last_plot_call())
  })
  
  output$plot_setup <- renderUI({
    
    output = tagList()
    
    if (length(input$selectplottype) > 0) {
      if (input$selectplottype == "scatter") {
        output[[1]] <- tagList()
        output[[1]][[1]] <- selectInput("scatter_mode", "Mode", choices = c("lines", "markers", "lines+markers"))
      }
    }
      
    output
  })
  
})
