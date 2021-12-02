# Read the data
data = read.delim("input", sep=" ")

# Select distances with direction up
ups = data$distance[data$direction == "up"]
# and down
downs = data$distance[data$direction == "down"]

# the sum of these is the final depth location

depth = sum(downs) - sum(ups)


# Same for x direction, sum forward distances
forwards = data$distance[data$direction == "forward"]

# the sum of these is the final depth location
horizontal_position = sum(forwards) - sum(backwards)
print(c(depth, horizontal_distance))

# Multiply these to get the answer

print(depth * horizontal_position)
