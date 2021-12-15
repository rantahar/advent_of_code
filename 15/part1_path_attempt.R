# Read the data and find dimensions
data = readLines("example_input")
rows = length(data)
cols = nchar(data[1])

# Create a base for the map
danger_map = matrix(9, rows, cols)

# extract numbers from the character strings
for(r in 1:rows){
  danger_map[r,] = strtoi(strsplit(data[r], "")[[1]])
}

position = c(0,0)
destination = c(rows, cols)

neighbours = list(c(0,1), c(1,0), c(-1,0), c(0,-1))

danger_values = c(0)
paths = list(list(c(1,1)))
visited = list(c(1,1,0))

# Construct paths by traveling to neighbours, updating the path
# with lowest danger level at any time.
# Never revisit a square, that is worse than just continuing from
# there.
done = FALSE
for(step in 1:10){
  # find current minimum
  i = 1
  min_danger = danger_values[1]
  for(p in 1:length(paths)){
    danger = danger_values[i]
    if(danger < min_danger){
      min_danger = danger
      i=p
    }
  }
  
  # Pop the selected path
  path = paths[[i]]
  paths = paths[-i]
  danger = danger_values[[i]]
  danger_values = danger_values[-i]
  
  cat("checking path with danger", danger, ", location ")
  cat(path[[length(path)]][1], path[[length(path)]][2], "\n")
  print(length(paths))
  
  # check each neighbour. If it has not been visited, add to path
  for(nb in neighbours){
    nb_point = path[[length(path)]] + nb
    legal_point = nb_point[1] >= 1 && nb_point[2] >= 1 && 
                  nb_point[1] <= rows && nb_point[2] <= cols
    better_visit = FALSE
    for(v in visited){
      if(nb_point[1] == v[1] && nb_point[2] == v[2] &&
         danger > v[3]){
        better_visit = TRUE
      }
    }
    if( legal_point && !better_visit ){
      new_path = path
      new_path[[length(new_path)+1]] = nb_point
      paths[[length(paths)+1]] = new_path
      new_danger = danger + danger_map[nb_point[1], nb_point[2]]
      danger_values[length(danger_values)+1] = new_danger
      
      visited[length(visited)+1] = list(c(nb_point[1], nb_point[2], danger))

      print(path)
      print(nb_point)
      print(danger)
      print(new_danger)
      
      if(nb_point[1] == destination[1] && nb_point[2] == destination[2]){
        # reached the destination. Since this is the lowest
        # cost path, we have found the best path
        best_path = new_path
        cost = new_danger
        done = TRUE
      }
    }
  }
  if(done){
    print("Best path found:")
    print(best_path)
    cat("danger level", cost, "\n")
    break
  }
}



