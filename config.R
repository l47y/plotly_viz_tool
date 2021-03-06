library(shiny)
library(readr)
library(data.table)
library(plotly)
library(shinydashboard)
library(shinyjs)
library(shinymaterial)
library(magrittr)
library(shinyWidgets)
library(htmlwidgets)
library(DT)
library(RColorBrewer)

# Set some layout and color stuff

plot_axisfontstyle <- list(color = 'white')
plot_axisstyle <- list(tickfont = plot_axisfontstyle, showgrid = FALSE)
plot_titlefont <- list(size = 14, color = 'white')

add_layout <- function(p) {
  p %<>% layout(plot_bgcolor = "transparent", 
                paper_bgcolor = "transparent",
                font = plot_titlefont,
                xaxis = plot_axisstyle,
                yaxis = plot_axisstyle,
                margin = list(l = 40, r = 40, b = 40, t = 40))
  return(p)
}

cybereon <- c("#ff008d", "#ff6666",	"#ffb58c", "#a8fff8", "#16ffd6")

source("helpers.R")




