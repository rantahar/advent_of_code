# Read the data and find dimensions
data = readLines("input")
rows = length(data)
cols = nchar(data[1])

# Create a base for the map
danger = matrix(0, rows, cols)

# extract numbers from the character strings
for(r in 1:rows){
  danger[r,] = strtoi(strsplit(data[r], "")[[1]])
}

# we propagate the cost to each direction from every point,
# keeping the lowest cost after each step. These are matrix
# operations so they are relatively fast
# First, initialize to a large number
costs = matrix(1000, rows, cols)

# cost at corner starts at 0
costs[1] = 0
changed = c(1)

step = 1
while(length(changed) > 0){
  new_changed = c()
  for(nb in list(c(1,0), c(-1,0), c(0,1), c(0,-1))){
    y = changed %% rows
    x = floor(changed / rows) + 1
    
    nby = y + nb[1]
    nbx = x + nb[2]
    
    allowed = nby > 0 & nby <= rows & nbx > 0 & nbx <= cols
    nby = nby[allowed]
    nbx = nbx[allowed]
    
    nbs = nby + rows*(nbx-1)
    origins = changed[allowed]
    
    if(length(nbs) > 0){
      new_costs = danger[nbs] + costs[origins]
      do_change = new_costs < costs[nbs]
      new_costs = new_costs[do_change]
      nbs = nbs[do_change]
      costs[nbs] = new_costs
      new_changed = c(new_changed, nbs)
    }
  }
  changed = unique(new_changed)
  
  if(step%%1 == 0){
    cat("step", step, ", num changes", length(changed), "\n")
  }
  step = step + 1
}

print(costs[rows, cols])