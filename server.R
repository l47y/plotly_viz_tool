source("config.R")


shinyServer(function(input, output, session) {
  
  mydata <- reactiveVal(NULL)
  last_plot_call <- reactiveVal(NULL)
  plot_height <- reactiveVal("100%")
  minimize_btn_state <- reactiveVal("up")
  btn_showdata_label <- reactiveVal("Data")
  updated_layout <- reactiveVal(NULL)
  
  
  observe ({
    if (!is.null(input$datainput)) {
      mydata(as.data.table(read_csv(input$datainput$datapath)))
    }
   })
  
  observe ({
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
  
  observeEvent(input$minimizeButton, {
    shinyjs::toggle(id = "filePanel", anim = TRUE)
    shinyjs::toggle(id = "columnPanel", anim = TRUE)
    shinyjs::toggle(id = "setupPanel", anim = TRUE)
    if (minimize_btn_state() == "up") {
      updateActionButton(session, "minimizeButton", icon = icon("arrow-down"))
      minimize_btn_state("down")
    } else {
      updateActionButton(session, "minimizeButton", icon = icon("arrow-up"))
      minimize_btn_state("up")
    }
  })
  
  observeEvent(input$btn_basic, {
    shinyjs::show(id = "basicPanelColumn")
    shinyjs::hide(id = "advancedPanelColumn")
  })
  
  observeEvent(input$btn_layout, {
    shinyjs::hide(id = "basicPanelColumn")
    shinyjs::show(id = "advancedPanelColumn")
  })
  
  observeEvent(input$btn_showdata, {
    shinyjs::toggle(id = "plotPanel")
    shinyjs::toggle(id = "showdataPanel")
    newlabel <- if (btn_showdata_label() == "Data") "Plot" else "Data"
    btn_showdata_label(newlabel)
    updateActionButton(session, "btn_showdata", label = newlabel)
  })
  
  observeEvent(input$update_layout, {
    layout_args <- list()
    layout_args[["title"]] <- if (!is.null(input$layout_title)) input$layout_title else NULL
    layout_args[["xaxis"]] <- if (!is.null(input$layout_title)) list(title = input$layout_xaxis) else NULL
    layout_args[["yaxis"]] <- if (!is.null(input$layout_title)) list(title = input$layout_yaxis) else NULL
    updated_layout(layout_args)
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
    final_plot <- eval(p) %>% add_layout() %>% layout(height = "100%") 
    my_layout <- updated_layout()
    my_layout[["p"]] <- final_plot
    do.call(layout, my_layout)
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
  
  output$showdata <- renderDataTable({
    print(head(mydata()))
    DT::datatable(mydata(), rownames = FALSE, options = list(
      autowidth = F, scrollY = T, searching = T, searchHighlight = T, pageLength = 20
    )) %>% DT::formatStyle(columns = colnames(mydata()), backgroundColor = "#242424", border = "0px")

    
  })
  
})
