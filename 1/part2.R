# Read the data
data = read.delim("input")

# Find the number of rows
l = dim(data)[1]

# Calculate 3-step moving sum
moving_sum = data[1:(l-2), 1] + data[2:(l-1), 1] + data[3:l, 1]

# Find rows where the depth grows
l = length(moving_sum) # It's not a data-frame anymore?
d1 = moving_sum[1:(l-1)]
d2 = moving_sum[2:l]
growing = d2-d1 > 0

# Count up and print
print(sum(growing))
