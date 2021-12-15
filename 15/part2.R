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
  print(value)
  print(length(value))
  print(length((x*cols+1):((x+1)*cols)))
  for(x in 0:4){
    for(y in 0:4){
      danger[y*rows + r,(x*cols+1):((x+1)*cols)] = value + x + y
    }
  }
}

danger = (danger-1) %% 9 + 1

rows = 5*rows
cols = 5*cols

# we propagate the cost to each direction from every point,
# keeping the lowest cost after each step. These are matrix
# operations so they are relatively fast
# First, initialize to a large number
costs = matrix(100000, rows, cols)

# cost at corner starts at 0
costs[1,1] = 0

while(TRUE){
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
  
  if(step%%10 == 0){
    cat("step", step, ", num changes", sum(diff!=0), "\n")
  }
  
  if(sum(diff!=0)==0){
    print("done")
    print(costs[rows,cols])
    break
  }
}

