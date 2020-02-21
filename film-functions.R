#-----------------------------------------------------------------------------#
# film-functions.R
# - Functions for reading in, summarising, and visualising raw
#   dialogue network data.
#-----------------------------------------------------------------------------#

# Read in the film
qread_film <- function(edge.file, node.file, offset = 0) {
  # First, let's read in the event list and the node list
  lines <- read.csv(edge.file, sep = ',', stringsAsFactors = FALSE)
  # Now, let's read in the node list and add some attributes we'll want later
  chars <- read.csv(node.file, sep = ',', stringsAsFactors = FALSE)
  chars$nlines <- vector("numeric", nrow(chars))
  for (i in 1:nrow(chars)) {
    chars$nlines[i] <- length(which(lines[ , (3 + offset)] == i))
  }
  chars$linesin <- colSums(lines[ , (4 + offset):ncol(lines)])
  chars$gender <- ifelse(chars$char_female == 1, "Female", "Male")
  # This makes sure the code runs with non-numeric input (it's a hacky fix):
  if((FALSE %in% (apply(lines, 2, class) %in% "integer")) == FALSE) {
    lines <- as.matrix(lines)
  }
  
  # Create adjacency matrix from the event list
  adj <- matrix(0, nrow(chars), nrow(chars))
  for (i in 1:nrow(chars)) {
    for (j in 1:nrow(chars)) {
      adj[i,j] <- length(which(lines[ , 3 + offset] == i &
                                 lines[ , j + (3 + offset)] == 1))
    }
  }
  colnames(adj) <- chars$char_name
  rownames(adj) <- chars$char_name
  
  list(event_list = lines, node_list = chars, adjacency = adj)
}

# Check for data entry errors.
check_for_errors <- function(adjacency = NULL, eventlist = NULL, 
                             start.column = 4) {
  if(is.null(adjacency)) {
    stop("Please provide an adjacency matrix via the 'adjacency' argument")
  }
  if(is.null(eventlist)) {
    stop("Please provide an event list via the 'eventlist' argument")
  }
  
  self_ties <- vector("numeric", length = nrow(adjacency))
  # Check diagonal for self-ties
  for (i in 1:nrow(adjacency)){
    if(adjacency[i, i] > 0) {
      self_ties[i] <- 1
    } else {
      self_ties[i] <- 0
    }
  }
  if(length(which(self_ties > 0)) > 0) {
    cat("Characters with self-ties: ", which(self_ties > 0))
  } else {
    cat("No characters with self-ties found.")
  }
  cat("\n")
  # Check for empty rows (no recipients indicated)
  if(length(which(rowSums(eventlist[ , start.column:ncol(eventlist)]) == 0)) > 0)
  {
    cat("Empty rows: ", 
        which(rowSums(eventlist[ , start.column:ncol(eventlist)]) == 0))
  } else {
    cat("No empty rows found.")
  }
  # Check for other data entry errors (cell values not in c(0, 1))
  if(FALSE %in% unique(c(as.matrix(eventlist)[ , start.column:ncol(eventlist)])) 
     %in% c("0", "1")) {
    cat("\nData entry values: ", 
        unique(c(as.matrix(eventlist)[ , start.column:ncol(eventlist)])))
  }
}

# Summarise film-level metadata
film_summary <- function(eventlist = NULL, offset = 0) {
  if(is.null(eventlist)) {
    stop("Please provide an event list via the 'eventlist' argument")
  }
  scenecount <- length(unique(eventlist[ , 2]))
  linecount <- length(unique(eventlist[ , 1]))
  charcount <- length(unique(eventlist[ , 3 + offset]))
  filmsum <- data.frame(scenecount, linecount, charcount)
  colnames(filmsum) <- c("No. scenes", "No. lines", 
                         "No. characters")
  print(filmsum, row.names = FALSE)
}

# Summarise gendered distribution of characters and dialogue
film_summary_gender <- function(nodelist = NULL) {
  if(is.null(nodelist)) {
    stop("Please provide a node list via the 'nodelist' argument")
  }
  # Calculate the proportion of named speaking characters that are female
  numfemales <- length(which(nodelist$char_female == 1))
  nummales <- length(which(nodelist$char_female == 0))
  propfemchars <- (numfemales / (numfemales + nummales)) * 100
  # Calculate the proportion of lines spoken by females
  propfemlines <- (sum(nodelist$nlines[which(nodelist$char_female == 1)]) / 
                     (sum(nodelist$nlines[which(nodelist$char_female == 1)]) + 
                        sum(nodelist$nlines[which(nodelist$char_female == 0)]))) * 100
  # Calculate the proportion of total recipients of dialogue that are female
  propfemlinesin <- (sum(nodelist$linesin[which(nodelist$char_female == 1)]) /
                       (sum(nodelist$linesin[which(nodelist$char_female == 1)]) +
                          sum(nodelist$linesin[which(nodelist$char_female == 0)]))) * 100
  # Return a table summarising each
  filmsumg <- data.frame(round(propfemchars, digits=2), 
                         round(propfemlines, digits=2),
                         round(propfemlinesin, digits=2))
  colnames(filmsumg) <- c("% characters female", 
                          "% lines out female", 
                          "% lines in female")
  print(filmsumg, row.names = FALSE)
}

# Plot the network using plot.network
plot_film_basic <- function(adjacency = NULL, nodelist = NULL, 
                            filmtitle = "", legend = FALSE) {
  if(is.null(adjacency)) {
    stop("Please provide an adjacency matrix via the 'adjacency' argument")
  }
  if(is.null(nodelist)) {
    stop("Please provide a node list via the 'nodelist' argument")
  }
  
  # Create network object from adjacency matrix
  filmnet <- network(adjacency)
  # Plot the network
  plot(filmnet, label = nodelist$char_name, edge.col = 'lightpink1', 
       vertex.cex = sqrt(nodelist$nlines)/3, label.pos = 3, arrowhead.cex = 0.7,
       vertex.col = ifelse(nodelist$char_female == 1, "#ded649", "#55467a"), 
       main = paste0("Character interactions in ", filmtitle))
  if (legend == TRUE) {
    legend(x = "right", c("Male", "Female"), pch = 21, y.intersp = 0.8, 
           pt.bg = c('#55467a','#ded649'), pt.cex = 2.5, cex = 1.2, 
           bty = "n", ncol = 1)
  }
}

# Plot the network using ggraph
plot_film_gg <- function(adjacency = NULL, nodelist = NULL,  
                         filmtitle = "") {
  if(is.null(adjacency)) {
    stop("Please provide an adjacency matrix via the 'adjacency' argument")
  }
  if(is.null(nodelist)) {
    stop("Please provide a node list via the 'nodelist' argument")
  }
  
  # Create the igraph object
  g <- igraph::graph_from_adjacency_matrix(adjacency, weighted = TRUE, 
                                           diag = FALSE)
  V(g)$gender <- nodelist$gender
  V(g)$name <- nodelist$char_name
  V(g)$size <- scales::rescale(nodelist$nlines, to = c(2, 15))
  g <- graphlayouts::reorder_edges(g, "weight", desc = FALSE)
  # Create the ggraph plot
  p <-  ggraph(g, layout = "stress") +
    geom_edge_link(aes(colour = weight, 
                       start_cap = circle(node1.size*1.1, unit = "pt"),
                       end_cap = circle(node2.size*1.1, unit = "pt")), n = 2, 
                   arrow = arrow(angle = 20,length = unit(0.14, "inches"), 
                                 ends = "last", type = "closed")) +
    geom_node_point(aes(fill = gender), size = V(g)$size, shape = 21, 
                    stroke = 0.5, colour = "black") +
    geom_node_text(aes(label = name), size = 4.5, 
                   nudge_y = scales::rescale(V(g)$size, to = c(0.06, 0.15))) +
    scale_fill_manual(values = c("Male" = "#55467a", "Female" = "#ded649"), 
                      aesthetics = c("fill")) +
    scale_edge_color_gradient(low = "grey85", high = "grey25", trans = "sqrt") +
    labs(title = paste0("Character interactions in ", filmtitle)) +
    scale_x_continuous(expand = c(0.1, 0.1)) +
    theme_graph() +
    theme(legend.position = "none", 
          plot.title = element_text(size = 16, hjust = 0.5))
  # And plot it!
  plot(p)
}

# Plot the network using visNetwork
plot_film_html <- function(adjacency = NULL, nodelist = NULL, savenet = FALSE, 
                           filmtitle = "", edgelabs = FALSE, 
                           filename = "My visnet.html") {
  g <- igraph::graph_from_adjacency_matrix(adjacency, weighted = TRUE, 
                                           diag = FALSE)
  eg <- igraph::get.edgelist(g, names = FALSE)
  
  # To create 'Links'
  numlines <- nrow(nodelist)
  ew <- vector("numeric", nrow(eg))
  for (i in 1:numlines) {
    for (j in 1:numlines) {
      for (k in 1:nrow(eg)) {
        if (eg[k, 1] == i & eg[k, 2] == j) {
          ew[k] <- sqrt(adjacency[i, j]) / 10
        } else { next } 
      }
    }
  }
  vislinks <- cbind.data.frame(eg, ew)
  if(edgelabs == TRUE) {
    colnames(vislinks) <- c("from", "to", "title") 
  } else { colnames(vislinks) <- c("from", "to", "Strength") }
  
  # To create 'Nodes'
  nodetitle <- vector("character", max(nodelist$char_ID))
  for (c in 1:nrow(nodelist)) {
    nodetitle[c] <- paste0("Character: ", nodelist$char_name[c],
                           "<br />Gender: ", nodelist$gender[c], 
                           "<br />No. lines: ", nodelist$nlines[c], 
                           "<br />No. times spoken to: ", nodelist$linesin[c])
  }
  visnodes <- cbind.data.frame("id" = nodelist$char_ID, 
                               "label" = nodelist$char_name,
                               "value" = nodelist$nlines, "title" = nodetitle,
                               "group" = nodelist$gender)
  
  #Generate the network object
  visnet <- visNetwork(nodes = visnodes, edges = vislinks,  
                       main = list(text = paste0("Character interactions in ", 
                                                 filmtitle), 
                                   style = "font-family:palatino;font-size:20px; 
                                  text-align:center;")) %>%
    visInteraction(hover = TRUE, hoverConnectedEdges = TRUE, 
                   multiselect = TRUE) %>%
    visGroups(groupname = "Female", color = list(background="#F0D72A", 
                                                 border="#9A9158", 
                                                 highlight="#EDC825", 
                                                 hover="#FBD738")) %>%
    visGroups(groupname = "Male", color = list(background="#075EC3", 
                                               border="#172C76", 
                                               highlight="#1075EA", 
                                               hover="#2586F6")) %>%
    visEdges(arrows = list(to = list(enabled = TRUE, scaleFactor = 0.5)))
  if (savenet == TRUE) {
    visSave(visnet, file = filename)
  }
  visnet
}