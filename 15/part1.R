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

# cost at cornet starts at 0
costs[1,1] = 0

for(step in 1:(10*rows)){
  costs_before = costs
  d = dim(danger)
  
  # y down
  move_cost = costs[1:(d[1]-1), 1:d[2]] + danger[2:d[1], 1:d[2]]
  updates = costs[2:d[1], 1:d[2]] > move_cost
  costs[2:d[1], 1:d[2]][updates] = move_cost[updates]
  
  # y up
  move_cost = costs[2:d[1], 1:d[2]] + danger[1:(d[1]-1), 1:d[2]]
  updates = costs[1:(d[1]-1), 1:d[2]] > move_cost
  costs[1:(d[1]-1), 1:d[2]][updates] = move_cost[updates]
  
  # x down
  move_cost = costs[1:d[1], 1:(d[2]-1)] + danger[1:d[1], 2:d[2]]
  updates = costs[1:d[1], 2:d[2]] > move_cost
  costs[1:d[1], 2:d[2]][updates] = move_cost[updates]
  
  # x up
  move_cost = costs[1:d[1], 2:d[2]] + danger[1:d[1], 1:(d[2]-1)]
  updates = costs[1:d[1], 1:(d[2]-1)] > move_cost
  costs[1:d[1], 1:(d[2]-1)][updates] = move_cost[updates]
  
  diff = costs_before - costs
  if(sum(diff!=0)==0){
    print("done")
    print(costs[rows,cols])
    break
  }
  
}

