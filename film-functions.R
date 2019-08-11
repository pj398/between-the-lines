#-----------------------------------------------------------------------------#
# film-functions.R
# - Functions for reading in, summarising, and visualising raw
#   dialogue network data.
#-----------------------------------------------------------------------------#

# Read in the film
read.film <- function(edge.file, node.file, eventlist="lines", 
                      nodelist="chars", adjacency = "adj", offset=0) {
  # First, let's read in the event list and the node list
  lines <- read.csv(edge.file, sep=',', stringsAsFactors = FALSE)
  lines <- as.matrix(lines)
  # Now, let's read in the node list and add some attributes we'll want later
  chars <- read.csv(node.file, sep=',', stringsAsFactors = FALSE)
  chars$nlines <- vector("numeric", nrow(chars))
  for (i in 1:nrow(chars)) {
    chars$nlines[i] <- length(which(lines[,(3+offset)]==i))
  }
  chars$linesin <- colSums(lines[,(4+offset):ncol(lines)])
  chars$gender <- ifelse(chars$charfem==1,"Female","Male")
  # Create adjacency matrix from the event list
  adj <- matrix(0,nrow(chars),nrow(chars))
  for (i in 1:nrow(chars)) {
    for (j in 1:nrow(chars)) {
      adj[i,j] <- length(which(lines[,3+offset]==i&lines[,j+3+offset]==1))
    }
  }
  colnames(adj) <- chars$character.name
  rownames(adj) <- chars$character.name
  
  # Assign the output objects to the global environment
  assign(eventlist, lines, pos = ".GlobalEnv")
  assign(nodelist, chars, pos = ".GlobalEnv")
  assign(adjacency, adj, pos = ".GlobalEnv")
}

# Check for data entry errors.
check.for.errors <- function(adjacency = adj, eventlist = lines, rec=4){
  self.ties <- vector("numeric", length = nrow(adjacency))
  # Check diagonal for self-ties
  for (i in 1:nrow(adjacency)){
    if(adjacency[i,i]>0){
      self.ties[i] <- 1
    } else {
      self.ties[i] <- 0
    }
  }
  if(length(which(self.ties>0))>0){
    cat("Characters with self-ties: ", which(self.ties>0))
  } else {
    cat("No characters with self-ties found.")
  }
  cat("\n")
  # Check for empty rows (no recipients indicated)
  if(length(which(rowSums(eventlist[,rec:ncol(eventlist)])==0))>0){
    cat("Empty rows: ", which(rowSums(eventlist[,rec:ncol(eventlist)])==0))
  } else {
    cat("No empty rows found.")
  }
  # Check for other data entry errors (cell values not in c(0, 1))
  if(length(which(lines[,rec:ncol(lines)] %in% 0:1 == FALSE))>0){
    cat("\nData entry errors: ", which(lines[,rec:ncol(lines)] %in% 0:1==FALSE))
  }
}

# Summarise film-level metadata
film.summary <- function(eventlist = lines) {
  scenecount <- length(unique(eventlist[,2]))
  linecount <- length(unique(eventlist[,1]))
  charcount <- length(unique(eventlist[,3]))
  filmsum <- data.frame(scenecount,linecount,charcount)
  colnames(filmsum) <- c("No. scenes","No. lines","No. characters")
  print(filmsum, row.names = FALSE)
}

# Summarise gendered distribution of characters and dialogue
film.summary.gender <- function(nodelist = chars) {
  # Calculate the proportion of named speaking characters that are female
  numfemales <- length(which(nodelist$charfem==1))
  nummales <- length(which(nodelist$charfem==0))
  propfemchars <- (numfemales/(numfemales+nummales))*100
  # Calculate the proportion of lines spoken by females
  propfemlines <- (sum(nodelist$nlines[which(nodelist$charfem==1)])/
                     (sum(nodelist$nlines[which(nodelist$charfem==1)])+
                        sum(nodelist$nlines[which(nodelist$charfem==0)])))*100
  # Calculate the proportion of total recipients of dialogue that are female
  propfemlinesin <- (sum(nodelist$linesin[which(nodelist$charfem==1)])/
                       (sum(nodelist$linesin[which(nodelist$charfem==1)])+
                          sum(nodelist$linesin[which(nodelist$charfem==0)])))*100
  # Return a table summarising each
  filmsumg <- data.frame(round(propfemchars, digits=2), 
                         round(propfemlines, digits=2),
                         round(propfemlinesin, digits=2))
  colnames(filmsumg) <- c("% characters female","% lines out female",
                          "% lines in female")
  print(filmsumg, row.names=FALSE)
}

# Plot the network using plot.network
plot.film.basic <- function(nodelist=chars, my.adj=adj, filmtitle="", 
                            legend=FALSE) {
  library(network, quietly = TRUE)
  # Create network object from adjacency matrix
  filmnet <- network(my.adj)
  # Plot the network
  plot(filmnet, label=nodelist$character.name, edge.col='lightpink1', 
       vertex.cex=sqrt(nodelist$nlines)/3, label.pos=3, arrowhead.cex=0.7,
       vertex.col=ifelse(nodelist$charfem==1, "#ded649", "#55467a"), 
       label.cex=0.7, main=paste0("Character interactions in ", filmtitle))
  if (legend==TRUE) {
    legend(x="right", c("Male","Female"), pch=21, y.intersp=0.8, 
           pt.bg=c('#55467a','#ded649'), pt.cex=2.5, cex=1.2, 
           bty="n", ncol=1)
  }
}

# Plot the network using ggraph
plot.film.gg <- function(my.adj=adj, nodelist=chars,  filmtitle="") {
  library(igraph, warn.conflicts = FALSE, quietly = TRUE)
  library(ggraph, quietly = TRUE)
  library(graphlayouts, quietly = TRUE)
  library(extrafont, quietly = TRUE)
  library(scales, quietly = TRUE)
  # Create the igraph object
  g <- graph_from_adjacency_matrix(my.adj, weighted=TRUE, diag=FALSE)
  V(g)$gender <- nodelist$gender
  V(g)$name <- nodelist$character.name
  V(g)$size <- rescale(nodelist$nlines, to=c(2,15))
  g <- reorder_edges(g, "weight", desc = FALSE)
  # Create the ggraph plot
  p <-  ggraph(g, layout = "stress") +
    geom_edge_link(aes(colour=weight, 
                       start_cap=circle(node1.size*1.1, unit="pt"),
                       end_cap=circle(node2.size*1.1, unit="pt")), n=2, 
                   arrow = arrow(angle=20,length=unit(0.14, "inches"), 
                                 ends="last", type="closed")) +
    geom_node_point(aes(fill=gender), size = V(g)$size, shape=21, stroke=0.5,
                    colour="black") +
    geom_node_text(aes(label=name), size=4.5, 
                   nudge_y=rescale(V(g)$size, to=c(0.06,0.15))) +
    scale_fill_manual(values = c("Male"="#55467a","Female"="#ded649"), 
                      aesthetics = c("fill")) +
    scale_edge_color_gradient(low="grey85", high="grey25",trans="sqrt") +
    labs(title = paste0("Character interactions in ", filmtitle)) +
    scale_x_continuous(expand = c(0.1, 0.1)) +
    theme_graph() +
    theme(legend.position="none", plot.title=element_text(size=16, hjust=0.5))
  # And plot it!
  plot(p)
}

# Plot the network using visNetwork
plot.film.html <- function(my.adj = adj, nodelist = chars, savenet = FALSE, 
                           filmtitle = "", edgelabs = FALSE, 
                           filename = "My visnet.html") {
  library(igraph, warn.conflicts = FALSE, quietly = TRUE)
  library(visNetwork, quietly = TRUE)
  g <- graph_from_adjacency_matrix(my.adj, weighted=TRUE, diag=FALSE)
  eg <- get.edgelist(g, names = FALSE)
  
  # To create 'Links'
  numchars <- nrow(nodelist)
  ew <- vector("numeric", nrow(eg))
  for (i in 1:numchars)
  {
    for (j in 1:numchars)
    {
      for (k in 1:nrow(eg))
        if (eg[k,1]==i & eg[k,2]==j){
          ew[k] <- sqrt(my.adj[i,j])/10
        } else { next } }
  }
  vislinks <- cbind.data.frame(eg, ew)
  if(edgelabs==TRUE){
    colnames(vislinks) <- c("from", "to", "title")} else {
      colnames(vislinks) <- c("from", "to", "Strength")
    }
  
  # To create 'Nodes'
  nodetitle <- vector("character", max(nodelist$characterID))
  for (c in 1:nrow(nodelist)) {
    nodetitle[c] <- paste0("Character: ", nodelist$character.name[c],
                           "<br />Gender: ", nodelist$gender[c], 
                           "<br />No. lines: ", nodelist$nlines[c], 
                           "<br />No. times spoken to: ", nodelist$linesin[c])
  }
  visnodes <- cbind.data.frame("id" = nodelist$characterID, 
                               "label" = nodelist$character.name,
                               "value" = nodelist$nlines, "title" = nodetitle,
                               "group" = nodelist$gender)
  
  #Generate the network object
  visnet <- visNetwork(nodes = visnodes, edges = vislinks,  
                       main=list(text=paste0("Character interactions in ", 
                                             filmtitle), 
                                 style="font-family:palatino;font-size:20px; 
                                  text-align:center;")) %>%
    visInteraction(hover = TRUE, hoverConnectedEdges = TRUE, 
                   multiselect = TRUE) %>%
    visGroups(groupname = "Female", color = 
                list(background="#F0D72A", border="#9A9158", 
                     highlight="#EDC825", hover="#FBD738")) %>%
    visGroups(groupname = "Male", color = 
                list(background="#075EC3", border="#172C76", 
                     highlight="#1075EA", hover="#2586F6")) %>%
    visEdges(arrows = list(to = list(enabled = TRUE, scaleFactor = 0.5)))
  if (savenet==TRUE) {
    visSave(visnet, file = filename)
  }
  visnet
}