data = read.delim("input", sep=" ",  stringsAsFactors = FALSE, header=FALSE)

outputs = data[,12:15]

# count characters
for(i in 1:4){
  outputs[,i] = nchar(outputs[,i])
}

# check for unique lengths (2, 4, 3 and 7)
for(i in 1:4){
  outputs[,i] = outputs[,i] %in% c(2, 4, 3, 7)
}

# Count the unique numbers
num_unique = sum(rowSums(outputs))

cat("Number of uniques in outputs is", num_unique, "\n")
