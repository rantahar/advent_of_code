# read the file
data = read.delim("input", header=FALSE, sep=" ", stringsAsFactors = F)

start = sapply(data[,1], function(x) strsplit(x, ",")[[1]])
end = sapply(data[,3], function(x) strsplit(x, ",")[[1]])

data$start_x = sapply(start[1,], strtoi)
data$start_y = sapply(start[2,], strtoi)
data$end_x = sapply(end[1,], strtoi)
data$end_y = sapply(end[2,], strtoi)

# Take only the entries with start_x == end_x or start_y == end_y
data = data[(data$start_y == data$end_y) | (data$start_x == data$end_x),]

# Matrix for the sea floor
floor = matrix(0,1000,1000)

# Loop over the entries and add to the map
for(r in 1:dim(data)[1]){
  y1 = data$start_y[r]+1
  x1 = data$start_x[r]+1
  y2 = data$end_y[r]+1
  x2 = data$end_x[r]+1
  
  floor[y1:y2, x1:x2] = floor[y1:y2, x1:x2] + 1
}

# count points

points = sum(floor>1)
print(points)

