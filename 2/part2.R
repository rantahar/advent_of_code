library(dplyr)

# Read the data
data = read.delim("input", sep=" ")

# Add an aim column with negative distances for the up direction
# (the aim is the cumulative sum of this)
data = mutate(data,
              aim=ifelse(
                direction=="down", distance, 
                ifelse(direction=="up", -distance, 0)
              )
)

# take the cumulative sum
data$aim = cumsum(data$aim)

# The horizontal distance is unchanged
forwards = data$distance[data$direction == "forward"]
horizontal_distance = sum(forwards)

# For the vertical distance, this is multiplied by the aim
aims = data$aim[data$direction == "forward"]
depth = sum(forwards*aims)

print(c(depth, horizontal_distance))
print(depth*horizontal_distance)

