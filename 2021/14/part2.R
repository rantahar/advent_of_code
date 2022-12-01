library(bit64)

# Read the data
data = readLines("input")

# The polymer template is on the first line
polymer = data[1]

first_letter = polymer[1]
last_letter = polymer[length(polymer)]

cat("template", polymer, "\n")

# make a list of pairs and number them. Each produce 2 new pairs each round
pairs = integer64()

for(c in 1:(nchar(polymer)-1)){
  pair = substr(polymer, c, c+1)
  if(pair %in% names(pairs)){
    pairs[pair] = pairs[pair] + 1
  } else {
    pairs[pair] = 1
  }
}

# Save the rules in a list and index by the pair
rules = list()

# also list characters as we go
chars = strsplit(polymer, "")[[1]]

for( line in data[3:length(data)]){
  pair = substr(line, 1,2)

    # Construct the two new pairs and add to rules
  first = substr(pair, 1, 1)
  second = substr(pair, 2, 2)
  insertion = substr(line, 7,7)
  new_pair1 = paste(first, insertion, sep="")
  new_pair2 = paste(insertion, second, sep="")
  rules[[pair]] = list(new_pair1, new_pair2)
  
  if(!(pair %in% names(pairs))){
    pairs[pair] = 0
  }
  if(!(pair1 %in% names(pairs))){
    pairs[pair1] = 0
  }
  if(!(pair2 %in% names(pairs))){
    pairs[pair2] = 0
  }
  
  if(!(insertion %in% chars)){
    chars[length(chars)+1] = insertion
  }
}  

print(pairs["HH"])

# Each time step apply the rules on each pair
for(i in 1:40){
  new_pairs = integer64()
  for(pair in names(pairs)){
    new_pair1 = rules[[pair]][[1]]
    new_pair2 = rules[[pair]][[2]]
    if(new_pair1 %in% names(new_pairs)){
      new_pairs[new_pair1] = new_pairs[new_pair1] + pairs[pair]
    } else {
      new_pairs[new_pair1] = pairs[pair]
    }
    if(new_pair2 %in% names(new_pairs)){
      new_pairs[new_pair2] = new_pairs[new_pair2] + pairs[pair]
    } else {
      new_pairs[new_pair2] = pairs[pair]
    }
  }
  pairs = new_pairs
  print(pairs["HK"])
}

# Now count both letters in each pair
counts = integer64()
for(c in chars){
  counts[c] = 0
}

# This will count each letter twice, except for the first and the last.
# Easiest way to correct is to add 1 here (for some reason ceiling fails)
counts[first_letter] = 1
counts[last_letter] = 1

for(pair in names(pairs)){
  c1 = substr(pair, 1, 1)
  c2 = substr(pair, 2, 2)
  counts[c1] = counts[c1] + pairs[pair]
  counts[c2] = counts[c2] + pairs[pair]
}

counts=floor(counts/2)

cat("counts:\n")
print(counts, digits=16)
counts = sort(counts)
score = counts[length(counts)] - counts[1]

print("score:")
print(score,  digits = 18)

