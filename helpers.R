
ed = data.table("a" = sample(c("a", "b", "c"), replace = T, 1000), 
                "b" = sample(c("d", "e", "f"), replace = T, 1000), 
                "c" = sample(c("g", "h", "j"), replace = T, 1000), 
                "d" = sample(c("g", "h", "j"), replace = T, 1000))

make_sankey <- function(data, cols) {
  grouped_list <- list()
  for (i in 1:(length(cols) - 1)) {
    grouped_list[[i]] <- data[, .N, c(cols[i], cols[i + 1])]
  }
  labels <- c()
  for (el in grouped_list) {
    labels <- c(labels, unique(el[[1]]))
  }
  labels <- c(labels, unique(el[[2]]))
  sources <- c()
  targets <- c()
  values <- c()
  for (j in 1:length(grouped_list)) {
    el <- grouped_list[[j]]
    tmp_sources <- c()
    tmp_targets <- c()
    for(i in 1:nrow(el)) {
      tmp_sources[i] <- which(labels == el[[cols[j]]][i])[1] - 1
      tmp_targets[i] <- which(labels == el[[cols[j + 1]]][i])[1] - 1
    }
    values <- c(values, el$N)
    sources <- c(sources, tmp_sources)
    targets <- c(targets, tmp_targets)
  }
  p <- plot_ly(type = "sankey", orientation = "h",
               node = list(
                 label = labels,
                 pad = 10,
                 thickness = 20,
                 line = list(
                   color = "black",
                   width = 0.5
                 )
               ),
               link = list(source = sources, target = targets, value =  values),
               arrangement = "snap"
  ) 
  return(p)
}


get_column_types <- function(data) {
  types <- sapply(data, class)
  numerics <- names(types)[types %in% c("numeric", "double", "integer")]
  factors <- names(types)[types %in% c("factor", "character")]
  return(list("num" = numerics, "char" = factors))
}




