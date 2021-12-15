# Read the data
data = readLines("input")

# The polymer template is on the first line
polymer = data[1]

# Save the rules in a list and index by the pair
rules = c()

# also list characters as we go
chars = strsplit(polymer, "")[[1]]
print(chars)

for( line in data[3:length(data)]){
  pair = substr(line, 1,2)
  insertion = substr(line, 7,7)
  rules[pair] = insertion
  if(!(insertion %in% chars)){
    chars[length(chars)+1] = insertion
  }
}

cat("template", polymer, "\n")

for(i in 1:40){
  new_polymer = ""
  for(c in 1:(nchar(polymer)-1)){
    pair = substr(polymer, c, c+1)
    insertion = rules[pair]
    first = substr(pair, 1, 1)
    new_polymer = paste(new_polymer, first, insertion, sep="")
  }
  last = substr(polymer, nchar(polymer), nchar(polymer))
  polymer = paste(new_polymer, last, sep="")
  cat(i, nchar(polymer), "\n")
}

# split to a vector of characters for counting
polymer = strsplit(polymer, "")[[1]]

counts = c()

for(c in chars){
  counts[c] = sum(polymer == c)
}

cat("counts:\n")
print(counts)

counts = sort(counts)
score = counts[length(counts)] - counts[1]

cat("score:", score, "\n")
