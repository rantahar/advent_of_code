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

# cost at corner starts at 0
costs[1] = 0
changed = c(1)

while(length(changed) > 0){
  new_changed = c()
  for(d in 1:4){
    # map back to single index and filter the origin points
    nbs = neighbours[[d]][changed]
    is_allowed = allowed[[d]][changed]
    
    nbs = nbs[is_allowed]
    origins = changed[is_allowed]
    
    if(length(nbs) > 0){
      # Update neighbour if the new cost is smaller
      new_costs = danger[nbs] + costs[origins]
      do_change = new_costs < costs[nbs]
      new_costs = new_costs[do_change]
      nbs = nbs[do_change]
      costs[nbs] = new_costs
      new_changed = c(new_changed, nbs)
    }
  }
  changed = unique(new_changed)
}

print(costs[rows, cols])

