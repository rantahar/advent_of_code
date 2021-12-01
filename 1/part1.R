
# Read the data
data = read.delim("input")

# Find the number of rows
l = dim(data)[1]

# Calculate the difference each pair of rows
d1 = data[1:(l-1), 1]
d2 = data[2:l, 1]

# Find rows where the depth grows
growing = d2-d1 > 0

# Count up and print
print(sum(growing))
