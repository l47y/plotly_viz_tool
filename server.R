source("config.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  mydata <- reactiveVal(NULL)
  last_plot_call <- reactiveVal(NULL)
  
  observe ({
    if (!is.null(input$datainput)) {
      mydata(as.data.table(read_csv(input$datainput$datapath)))
    }
    if (input$datainput2 != "None") {
      tmp <- eval(parse(text = input$datainput2))
      mydata(as.data.table(tmp))
    }
   })
  
  observe({
    if (length(input$selectplottype) > 0) {
      if (input$selectplottype %in% c("histogram", "pie")) {
        shinyjs::hide("selectcol2")
      } else {
        shinyjs::show("selectcol2")
      }
      if (input$selectplottype == "heatmap") {
        shinyjs::hide("selectcol3")
      } else {
        shinyjs::show("selectcol3")
      }
      
    }
  })
  
  
  output$col1 <- renderUI({
    if (!is.null(mydata())) {
      selectInput("selectcol1", "x-column", choices = colnames(mydata()))
    }
  })
  
  output$col2 <- renderUI({
    if (!is.null(mydata())) {
      selectInput("selectcol2", "y-column", choices = colnames(mydata()))
    }
  })
  
  output$col3 <- renderUI({
    if (!is.null(mydata())) {
      selectInput("selectcol3", "color-column", choices = c("None", colnames(mydata())))
    }
  })
  
  output$plottype <- renderUI({
    if (!is.null(mydata())) {
      selectInput("selectplottype", "Type of plot", 
                  choices = c("scatter", "bar", "histogram", "pie", "heatmap"))
    }
  })
  
  output$mainplot <- renderPlotly({
    if (is.null(mydata())) {
      return(NULL)    
    }
    tmp <- mydata()
    
    if (input$selectplottype == "scatter") {
      p <- expr(plot_ly(
        x = tmp[[input$selectcol1]],
        y = tmp[[input$selectcol2]], 
        type = "scatter", 
        color = tmp[[input$selectcol3]],
        mode = input$scatter_mode,
        size = tmp[[input$scatter_size]]
      ))
    } else if (input$selectplottype == "bar") {
      p <- expr(plot_ly(
        x = tmp[[input$selectcol1]],
        y = tmp[[input$selectcol2]], 
        type = "bar", 
        barmode = input$bar_mode,
        color = tmp[[input$selectcol3]]
      ) %>% layout(barmode = input$bar_mode))
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
    } else if (input$selectplottype == "heatmap") {
      tmp1 <- tmp[, .N, c(input$selectcol1, input$selectcol2)]
      if (input$heatmap_mode == "percentage") {
        tmp1[, N := N / sum(N)]
      }
      p <- expr(plot_ly(
        x = tmp1[[input$selectcol1]], 
        y = tmp1[[input$selectcol2]], 
        z = tmp1[["N"]], 
        type = "heatmap"
      ))
    }
    last_plot_call(deparse(p))
    eval(p) %>% add_layout()
    
  })
  
  output$plot_call <- renderText({
    print(last_plot_call())
  })
  
  output$plot_setup <- renderUI({
    
    output = tagList()
    
    if (length(input$selectplottype) > 0) {
      if (input$selectplottype == "scatter") {
        output[[1]] <- tagList()
        output[[2]] <- tagList()
        output[[1]][[1]] <- selectInput("scatter_mode", "Mode", choices = c("lines", "markers", "lines+markers"))
        output[[1]][[2]] <- selectInput("scatter_size", "Size", choices = c("None", colnames(mydata())))
      } else if (input$selectplottype == "bar") {
        output[[1]] <- tagList()
        output[[1]][[1]] <- selectInput("bar_mode", "Barmode", choices = c("stack", "group"))
      } else if (input$selectplottype == "heatmap") {
        output[[1]] <- tagList()
        output[[1]][[1]] <- selectInput("heatmap_mode", label = "Count mode", choices = c("absolute", "relative"))
      }
    } 
      
    output
  })
  
})
