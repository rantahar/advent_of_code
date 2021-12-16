# Read the data and find dimensions
data = readLines("input")

rows = length(data)
cols = nchar(data[1])

# Create a base for the map
danger = matrix(0, 5*rows, 5*cols)

# extract numbers from the character strings and generate
# the larger map
for(r in 1:rows){
  value = strtoi(strsplit(data[r], "")[[1]])
  for(x in 0:4){
    for(y in 0:4){
      danger[y*rows + r,(x*cols+1):((x+1)*cols)] = value + x + y
    }
  }
}

danger = (danger-1) %% 9 + 1

rows = 5*rows
cols = 5*cols

# precalculate neighbour indeces
neighbours = list()
allowed = list()

dirs = list(c(1,0), c(-1,0), c(0,1), c(0,-1))
for(d in 1:4){
  nb = dirs[[d]]
  nbs = c()
  alloweds = c()
  for(y in 0:(rows-1)){
    for(x in 0:(cols-1)){
      index = y + rows*x + 1
      nby = y + nb[1]
      nbx = x + nb[2]
      is_allowed = nby >= 0 & nby < rows & nbx >= 0 & nbx < cols
      nbs[index] = nby + rows*nbx + 1
      alloweds[index] = is_allowed
    }
  }
  neighbours[d] = list(nbs)
  allowed[d] = list(alloweds)
}


# we propagate the cost to each direction from every point,
# keeping the lowest cost after each step.
# First, initialize to a large number
costs = matrix(100000, rows, cols)
visited = matrix(FALSE, rows, cols)

# cost at corner starts at 0
costs[1] = 0
consider = c(1)

step = 1
while(length(consider) > 0){
  c = which.min(costs[consider])
  index = consider[c]
  consider = consider[-c]
  
  for(d in 1:4){
    # map back to single index and filter the origin points
    neighbour = neighbours[[d]][index]
    check = allowed[[d]][index] && !visited[neighbour]
    if(check){
      # Update neighbour if the new cost is smaller
      new_cost = danger[neighbour] + costs[index]
      if(new_cost < costs[neighbour]){
        costs[neighbour] = new_cost
      }
      consider = c(neighbour, consider)
    }
  }
  visited[index] = TRUE
  
  consider = unique(consider)
  step = step + 1
}

print(costs[1:10,1:10])
print(costs[rows, cols])

