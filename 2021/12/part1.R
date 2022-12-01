# Read the data
data = readLines("input")

# for part 2, one small cave can be visited twice. For part 1, this is FALSE
can_revisit_small = TRUE

# List node names and map names to indexes
nodes = c()
index_of = function(name){
  index = which(nodes==name)
  return(index)
}

# mark if node is big
is_big = c()

# List of connections for each node
connections = list()

for(line in data){
  # each line has two nodes and each is connected to the other
  node = strsplit(line, "-")[[1]]
  
  if( !(node[1] %in% nodes) ){
    nodes = c(nodes, node[1])
    is_big = c(is_big,  grepl("^[[:upper:]]+$", node[1]))
    connections[index_of(node[1])] = list(NULL)
  }
  
  if( !(node[2] %in% nodes) ){
    nodes = c(nodes, node[2])
    is_big = c(is_big,  grepl("^[[:upper:]]+$", node[2]))
    connections[index_of(node[2])] = list(NULL)
  }
  
  i1 = index_of(node[1])
  i2 = index_of(node[2])
  connections[[i1]] = c(connections[[i1]], i2)
  connections[[i2]] = c(connections[[i2]], i1)
}



# Now we have a map. Start traversing the connections and building routes.
# It seems big caves are only connected to small ones, so no need to worry
# about infinite paths.

# List of found valid routes
routes = list()

traverse_node = function(route, can_revisit_small){
  node_index = route[length(route)]
  
  if(nodes[node_index] == "end"){
    routes[[length(routes)+1]] <<- nodes[route]
    return()
  }
  
  for(connection in connections[[node_index]]){
    can_visit = nodes[connection] != "start"
    revisiting_small = !is_big[connection] && (connection %in% route)
    can_visit = can_visit && (can_revisit_small || !revisiting_small)
    
    if(can_visit){
      new_route = c(route, connection)
      new_revisit_small = can_revisit_small && !revisiting_small
      traverse_node(new_route, new_revisit_small) 
    }
  }
}

traverse_node(c(index_of("start")), can_revisit_small)


cat("Found", length(routes), "paths\n")
