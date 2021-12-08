data = read.delim("input", sep=" ",  stringsAsFactors = FALSE, header=FALSE)

N = dim(data)[1]
numbers = data

# count characters
counts = data
for(i in 1:15){
  counts[,i] = nchar(data[,i])
}

# Find the 2 letter string (1)
matches = matrix("", N, 10)
for(i in 1:15){
  matches[,1] = ifelse(counts[,i] == 2, data[,i],matches[,1])
}
# mark it
numbers[counts == 2] = 1

# the 3 letter string (7)
numbers[counts == 3] = 7
for(i in 1:15){
  matches[,7] = ifelse(counts[,i] == 3, data[,i],matches[,7])
}

# the 4 letter string (4)
numbers[counts == 4] = 4
for(i in 1:15){
  matches[,4] = ifelse(counts[,i] == 4, data[,i],matches[,4])
}

# the 7 letter string (8)
numbers[counts == 7] = 8
for(i in 1:15){
  matches[,8] = ifelse(counts[,i] == 7, data[,i],matches[,8])
}


# Find all letters that match 1. This will help matching the rest
matches_1 = data
for(i in 1:15){
  letter1 = sapply(matches[,1], function(x) substr(x, 1,1))
  letter2 = sapply(matches[,1], function(x) substr(x, 2,2))
  matches_1[,i] = mapply(grepl, letter1, data[,i]) & mapply(grepl, letter2, data[,i])
}

# Now we can tell 3 apart from 2 and 5, and 6 apart from 9 and 0
is_3 = counts == 5 & matches_1
is_6 = counts == 6 & !matches_1

numbers[is_3] = 3
numbers[is_6] = 6

for(i in 1:15){
  matches[,3] = ifelse(is_3[,i], data[,i], matches[,3])
  matches[,6] = ifelse(is_6[,i], data[,i], matches[,6])
}


# The top left segment matches 4 and not 3.
top_left = vector("character", N)
for(l in 1:4){
  letter = sapply(matches[,4], function(x) substr(x, l,l))
  filter = !mapply(grepl, letter, matches[,3])
  top_left[filter] = letter[filter]
}

# This gives us 5
has_top_left = data
for(i in 1:15){
  has_top_left[,i] = mapply(grepl, top_left, data[,i])
  matches[,5] = ifelse(has_top_left[,i] & counts[,i] == 5, data[,i], matches[,5])
}
numbers[has_top_left & counts == 5] = 5

# The lower left segment matches 6 and not 5.
lower_left = vector("character", N)
for(l in 1:6){
  letter = sapply(matches[,6], function(x) substr(x, l,l))
  filter = !mapply(grepl, letter, matches[,5])
  lower_left[filter] = letter[filter]
}

# This gives us 9
has_lower_left = data
for(i in 1:15){
  has_lower_left[,i] = mapply(grepl, lower_left, data[,i])
}
numbers[!has_lower_left & counts == 6] = 9

# And this leaves 2 and 0
numbers[counts == 5 & numbers != 5 & numbers != 3] = 2
numbers[counts == 6 & numbers != 6 & numbers != 9] = 0


# Convert outputs to numbers and calculate the sum
outputs = 1000*as.numeric(numbers[,12]) +
           100*as.numeric(numbers[,13]) +
            10*as.numeric(numbers[,14]) +
               as.numeric(numbers[,15])
print(sum(outputs))

