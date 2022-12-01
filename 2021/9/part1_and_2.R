# Read the data and find dimensions
data = readLines("input")
rows = length(data)
cols = nchar(data[1])

# Create a base for the map
depth = matrix(9,rows, cols)

# extract numbers from the character strings
for(r in 1:rows){
  depth[r,] = strtoi(strsplit(data[r], "")[[1]])
}

## Part 1
# We will check each direction and for a lower value. So mark every point
# low first, and change to false when a lower neighbour is found
is_low = matrix(TRUE, rows, cols)

# Take the differences in both directions and mark the higher one as not 
# a low point. For equal values we arbitrarily choose the lower index
diff = depth[1:(rows-1),] - depth[2:rows,]
is_low[1:(rows-1),][diff>=0] = FALSE
is_low[2:rows,][diff<0] = FALSE

diff = depth[,1:(cols-1)] - depth[,2:cols]
is_low[,1:(cols-1)][diff>=0] = FALSE
is_low[,2:cols][diff<0] = FALSE

# Calculate and sum risk levels
risk_levels = depth[is_low]+1
risk_level = sum(risk_levels)
cat("Risk level is", risk_level, "\n")

## Part 2
# Each low point has a basin and they are surrounded by walls of height 9.
# For each point run a simple search, crossing of indexes on the map

basins = depth
basins[depth==9] = 1
basins[depth!=9] = 0

# First number the basins
low_points = which(is_low)
basin_size = c()
for(i in 1:length(low_points)){
  cat(i, low_points[i], "\n")
  basin_size[i] = 0
  check_points = c(low_points[i])
  j=1
  while( length(check_points) > 0 ){
    point = check_points[1]
    check_points = check_points[-1]
    y = floor((point-1)/rows)+1
    x = (point-1)%%rows+1
    if(depth[point] < 9){
      depth[point] = 9
      basin_size[i] = basin_size[i] + 1
      # add neighbour indeces to the list
      if(x > 1){
        check_points = c(check_points, (y-1)*rows + x-2 + 1)
      }
      if(x < rows){
        check_points = c(check_points, (y-1)*rows + x + 1)
      }
      if(y > 1){
        check_points = c(check_points, (y-2)*rows + x-1 + 1)
      }
      if(y < cols){
        check_points = c(check_points, (y)*rows + x-1 + 1)
      }
    }
    j = j+1
  }
}

basin_size=sort(basin_size, decreasing=TRUE)

result = basin_size[1] * basin_size[2] * basin_size[3]

cat("Part 2 result:", result, "\n")
