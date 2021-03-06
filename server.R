source("config.R")


shinyServer(function(input, output, session) {
  
  # Reactive values 
  mydata <- reactiveVal(NULL) # actual data 
  last_plot_call <- reactiveVal(NULL) # last plot call to print the code which produces plot 
  minimize_btn_state <- reactiveVal("up") # state of the minimize button 
  btn_showdata_label <- reactiveVal("Data") # state of the left menu button to change between plot and data 
  updated_layout <- reactiveVal(NULL) # object which stores the plot layout 
  updated_grid_layout <- reactiveVal(NULL) # object which stores the boolean grid layout values
  
  # Logic to load what happens when data is loaded. Elements to show when data is loaded 
  show_stuff_on_load <- function() {
    shinyjs::show(id = "plotPanel")
    shinyjs::show(id = "columnPanel")
    shinyjs::show(id = "setupPanel")
    shinyjs::show(id = "minimizeButton")
    shinyjs::show(id = "btn_row")
  }
  
  observe ({
    if (!is.null(input$datainput)) {
      mydata(as.data.table(read_csv(input$datainput$datapath)))
      show_stuff_on_load()
    }
  })
  
  # Logic for downloading the actual plot 
  observeEvent(input$btn_download, {
    click("btn_download_real")
  })
  
  output$btn_download_real <- downloadHandler(
    filename = function() {
      paste("plot-", Sys.Date(), ".html")
    },
    content = function(file) {
      htmlwidgets::saveWidget(as_widget(render_plot()), file, selfcontained = TRUE, background = "#202020")
    }
  )
  
  
  # Depending of the type of plot, the plot setup panel will be shown. 
  observe({
    if ("selectplottype" %in% names(input)) {
      if (!input$selectplottype %in% c("scatter", "heatmap", "sankey", "bar")) {
        shinyjs::hide(id = "setupPanel")
      } else {
        shinyjs::show(id = "setupPanel")
      }
    }
  })
  
  # Logic for the case that data is selected from list instead of local machine 
  observe ({
    if (input$datainput2 != "None") {
      tmp <- eval(parse(text = input$datainput2))
      mydata(as.data.table(tmp))
      show_stuff_on_load()
    }
  })
  
  # Logic to update layout of plot 
  observe({
    tmp <- isolate(updated_grid_layout())
    if (input$xaxisgrid == TRUE){
      tmp[["xaxis"]] <- list(showgrid = TRUE, gridcolor = "#808080")
    } else {
      tmp[["xaxis"]] <- list(showgrid = FALSE)
    }
    if (input$yaxisgrid == TRUE){
      tmp[["yaxis"]] <- list(showgrid = TRUE, gridcolor = "#808080")
    } else {
      tmp[["yaxis"]] <- list(showgrid = FALSE)
    }
    updated_grid_layout(tmp)
  })
  

  
  
  # Logic to update x and y axis if a new column is selected
  observe({
    tmp <- isolate(updated_layout())
    tmp[["xaxis"]] <- list(title = input$selectcol1)
    updated_layout(tmp)
  })
  observe({
    tmp <- isolate(updated_layout())
    tmp[["yaxis"]] <- list(title = input$selectcol2)
    updated_layout(tmp)
  })
  
  # Logic to hide/show inputs depending on the type of plot
  observe({
    if (length(input$selectplottype) > 0) {
      if (input$selectplottype == "histogram") {
        shinyjs::show("selectcol1")
        shinyjs::hide("selectcol2")
        shinyjs::show("selectcol3")
      } else if (input$selectplottype == "pie") {
        shinyjs::show("selectcol1")
        shinyjs::hide("selectcol2")
        shinyjs::hide("selectcol3")
      } else if (input$selectplottype == "heatmap") {
        shinyjs::show("selectcol1")
        shinyjs::show("selectcol2")
        shinyjs::hide("selectcol3")
      } else if (input$selectplottype == "sankey") {
        shinyjs::hide("selectcol1")
        shinyjs::hide("selectcol2")
        shinyjs::hide("selectcol3")
      }
    }
  })
  
  
  # Logic for minize Button: Hides or show upper panales, changes plot size and its icon 
  observeEvent(input$minimizeButton, {
    if (minimize_btn_state() == "up") {
      shinyjs::hide(id = "filePanel", anim = FALSE)
      shinyjs::hide(id = "columnPanel", anim = FALSE)
      shinyjs::hide(id = "setupPanel", anim = FALSE)
      shinyjs::hide(id = "axisAndTitlePanel", anim = FALSE)
      shinyjs::hide(id = "updateLayoutPanel", anim = FALSE)
      shinyjs::hide(id = "gridPanel", anim = FALSE)
      shinyjs::hide(id = "colorPanel", anim = FALSE)
      updateActionButton(session, "minimizeButton", icon = icon("arrow-down"))
      minimize_btn_state("down")
      runjs(paste0('$("#plotPanel").css("height","', 80, 'vh")'))
    } else {
      shinyjs::show(id = "filePanel", anim = FALSE)
      shinyjs::show(id = "columnPanel", anim = FALSE)
      shinyjs::show(id = "setupPanel", anim = FALSE)
      shinyjs::show(id = "axisAndTitlePanel", anim = FALSE)
      shinyjs::show(id = "updateLayoutPanel", anim = FALSE)
      shinyjs::show(id = "gridPanel", anim = FALSE)
      shinyjs::show(id = "colorPanel", anim = FALSE)
      updateActionButton(session, "minimizeButton", icon = icon("arrow-up"))
      minimize_btn_state("up")
      runjs(paste0('$("#plotPanel").css("height","', 50, 'vh")'))
    }
  })
  
  # Logic for menu navigation
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
  
  # Logic to update layout when layout is updated 
  observeEvent(input$update_layout, {
    layout_args <- list()
    layout_args[["title"]] <- if (!is.null(input$layout_title)) input$layout_title else NULL
    xaxis_title <- if (input$layout_xaxis != "") input$layout_xaxis else input$selectcol1
    yaxis_title <- if (input$layout_yaxis != "") input$layout_yaxis else input$selectcol2
    layout_args[["xaxis"]] <- list(title = xaxis_title)
    layout_args[["yaxis"]] <- list(title = yaxis_title)
    updated_layout(layout_args)
  })
  
  
  # ------------------------------------------------
  # Rendering of elements when data is loaded 
  output$col1 <- renderUI({
    if (!is.null(mydata())) {
      selectInput("selectcol1", "x-column", choices = colnames(mydata()))
    }
  })
  
  output$col2 <- renderUI({
    if (!is.null(mydata())) {
      selectInput("selectcol2", "y-column", choices = setdiff(colnames(mydata()), input$selectcol1))
    }
  })
  
  output$col3 <- renderUI({
    if (!is.null(mydata())) {
      selectInput("selectcol3", "color-column", choices = setdiff(c("None", colnames(mydata())), 
                                                                  c(input$selectcol1, input$selectcol2)))
    }
  })
  
  output$plottype <- renderUI({
    if (!is.null(mydata())) {
      selectInput("selectplottype", "Type of plot", 
                  choices = c("scatter", "bar", "histogram", "pie", "heatmap", "sankey"))
    }
  })
  
  # Render the plot setup panel depending on the selected plot type
  output$plot_setup <- renderUI({
    output = tagList()
    if (length(input$selectplottype) > 0) {
      if (input$selectplottype == "scatter") {
        output[[1]] <- tagList()
        output[[2]] <- tagList()
        output[[1]][[1]] <- selectInput("scatter_mode", "Mode", choices = c("markers", "lines", "lines+markers"))
        output[[1]][[2]] <- selectInput("scatter_size", "Size", choices = c("None", colnames(mydata())))
      } else if (input$selectplottype == "bar") {
        output[[1]] <- tagList()
        output[[1]][[1]] <- selectInput("bar_mode", "Barmode", choices = c("stack", "group"))
      } else if (input$selectplottype == "heatmap") {
        output[[1]] <- tagList()
        output[[1]][[1]] <- selectInput("heatmap_mode", label = "Count mode", choices = c("absolute", "relative"))
      } else if (input$selectplottype == "sankey") {
        output[[1]] <- tagList()
        char_cols <- get_column_types(mydata())$char
        output[[1]][[1]] <- selectInput("sankey_columns", label = "Select columns", 
                                        choices = char_cols, multiple = TRUE, 
                                        selected = char_cols[1:2])
      }
    } 
    output
  })

  output$mainplot <- renderPlotly({
    render_plot()
  })
  
  # output$plot_call <- renderText({
  #   print(last_plot_call())
  # })
  
  # CORE FUNCTION which actually produces the plot based on inputs 
  render_plot <- reactive({
    if (is.null(mydata())) {
      return(NULL)    
    }
    
    minimize_btn_state() # trick to force rerendering of plot when minimizing upper panels to make plot larger
    
    tmp <- mydata()
    
    if (input$select_colorpal %in% c("cybereon")) {
      my_palette <- eval(parse(text = input$select_colorpal))
      single_color <- cybereon[1]
    } else {
      my_palette <- input$select_colorpal
      single_color <- brewer.pal(3, input$select_colorpal)[1]
    }

    # ------------ SCATTER PLOT 
    if (input$selectplottype == "scatter") {
      arg_list <- list(
        x = tmp[[input$selectcol1]],
        y = tmp[[input$selectcol2]], 
        type = "scatter", 
        color = tmp[[input$selectcol3]],
        colors = my_palette,
        mode = input$scatter_mode,
        size = tmp[[input$scatter_size]]
      )
      if (!is.null(input$selectcol3)) {
        if (input$selectcol3 == "None") {
          marker_conf = list(color = single_color)
          line_conf = list(color = single_color)
          if (input$scatter_mode == "lines") {
            arg_list[["line"]] = line_conf
          } else if (input$scatter_mode == "markers") {
            arg_list[["marker"]] = marker_conf
          } else {
            arg_list[["line"]] = line_conf
            arg_list[["marker"]] = marker_conf
          }
        }
      }
      p <- do.call(plot_ly, arg_list)
    
    # ------------ BAR PLOT 
    } else if (input$selectplottype == "bar") {
      arg_list <- list(
        x = tmp[[input$selectcol1]],
        y = tmp[[input$selectcol2]], 
        type = "bar", 
        color = tmp[[input$selectcol3]],
        colors = my_palette
      )
      if (!is.null(input$selectcol3)) {
        if (input$selectcol3 == "None") {
          arg_list[["marker"]] <- list(color = single_color)
        }
      }
      p <- do.call(plot_ly, arg_list) %>% layout(barmode = input$bar_mode)
      
    
    # ------------ HISTOGRAM PLOT 
    } else if (input$selectplottype == "histogram") {
      arg_list <- list(
        x = tmp[[input$selectcol1]],
        type = "histogram", 
        color = tmp[[input$selectcol3]], 
        colors = my_palette
      )
      if (!is.null(input$selectcol3)) {
        if (input$selectcol3 == "None") {
          arg_list[["marker"]] <- list(color = single_color)
        }
      }
      p <- do.call(plot_ly, arg_list)
    
    # ------------ PIE PLOT
    } else if (input$selectplottype == "pie") {
      tmp <- tmp[, .N, c(input$selectcol1)]
      p <- plot_ly(
        labels = tmp[[input$selectcol1]],
        values = tmp$N,
        type = "pie", 
        marker = list(colors = produce_colors_from_palette(input$select_colorpal, nrow(tmp))),
        textinfo = 'label+percent'
      )
      
    # ------------ HEATMAP PLOT
    } else if (input$selectplottype == "heatmap") {
      tmp1 <- tmp[, .N, c(input$selectcol1, input$selectcol2)]
      if (input$heatmap_mode == "percentage") {
        tmp1[, N := N / sum(N)]
      }
      p <- plot_ly(
        x = tmp1[[input$selectcol1]], 
        y = tmp1[[input$selectcol2]], 
        z = tmp1[["N"]], 
        type = "heatmap",
        colors = my_palette
      )
    
    # ------------ SANKEY PLOT
    } else if (input$selectplottype == "sankey") {
      p <- make_sankey(mydata(), input$sankey_columns, colorPal = input$select_colorpal)
    }
    last_plot_call(deparse(expr(p)))
    final_plot <- p %>% add_layout() 
    my_layout <- updated_grid_layout()
    my_layout[["p"]] <- final_plot
    final_plot <- do.call(layout, my_layout)
    my_layout <- updated_layout()
    my_layout[["p"]] <- final_plot
    
    plotly::config(do.call(layout, my_layout), responsive = TRUE)
    
    
  })
  
  # Show raw data 
  output$showdata <- renderDataTable({
    DT::datatable(mydata(), rownames = FALSE, options = list(
      autowidth = F, scrollY = T, searching = T, searchHighlight = T, pageLength = 20
    )) %>% DT::formatStyle(columns = colnames(mydata()), backgroundColor = "#242424", border = "0px")
  })
  
})
