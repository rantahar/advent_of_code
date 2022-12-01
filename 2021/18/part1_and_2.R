# read the input line and extract positions
data = readLines("input")


snail_numbers = list()
for(line in data){
  # Extract individual characters
  line = strsplit(line, "")[[1]]
  
  # store each number and their depth in separate vectors
  snail_number = list(c(), c())
  
  current_depth = 0
  for(c in line){
    if(c == '['){
      current_depth = current_depth + 1
    } else if(c == ']'){
      current_depth = current_depth - 1
    } else if(c == ','){
      # ignore the comma
    }else {
      snail_number[1] = list(c(snail_number[[1]], strtoi(c)))
      snail_number[2] = list(c(snail_number[[2]], current_depth))
    }
  }
  
  snail_numbers[[length(snail_numbers) + 1]] = snail_number
}



explode = function(i, snail_number){
  numbers = snail_number[[1]]
  depth = snail_number[[2]]
  if(i > 1){
    numbers[i-1] = numbers[i-1] + numbers[i]
  }
  numbers[i] = 0
  depth[i] = depth[i] - 1
  
  i=i+1 # move to the number on the right
  if(length(numbers) > i){
    numbers[i+1] = numbers[i] + numbers[i+1]
  }
  numbers = numbers[-i]
  depth = depth[-i]
  return(list(numbers, depth))
}

split = function(i, snail_number){
  numbers = snail_number[[1]]
  depth = snail_number[[2]]
  number = numbers[i]
  numbers[i] = floor(number/2)
  depth[i] = depth[i]+1
  numbers = append(numbers, ceiling(number/2), after=i)
  depth = append(depth, depth[i], after=i)
  return(list(numbers, depth))
}

reduce = function(snail_number){
  made_change = TRUE
  while(made_change){
    made_change = FALSE
    numbers = snail_number[[1]]
    depth = snail_number[[2]]
    # look for explotions
    for(i in 1:length(numbers)){
      if(depth[i]>4){
        snail_number = explode(i, snail_number)
        made_change = TRUE
        break
      }
    }
    # look for splits
    if(!made_change) for(i in 1:length(numbers)){
      if(numbers[i]>9){
        snail_number = split(i, snail_number)
        made_change = TRUE
        break
      }
    }
  }
  return(snail_number)
}

add = function(snail_number_1, snail_number_2){
  # The numbers get concatenated and the depth increases by 1
  numbers = c(snail_number_1[[1]], snail_number_2[[1]])
  depth = c(snail_number_1[[2]] + 1, snail_number_2[[2]] + 1)
  
  return(list(numbers, depth))
}

magnitude = function(snail_number){
  numbers = snail_number[[1]]
  depth = snail_number[[2]]
  
  # reduce highest level pairs until only one number is left
  while(length(numbers) > 1){
    for(i in 1:(length(numbers)-1)){
      if(depth[i+1] == depth[i]){
        numbers[i] = numbers[i]*3 + numbers[i+1]*2
        numbers = numbers[-(i+1)]
        depth[i] = depth[i] - 1
        depth = depth[-(i+1)]
        break
      }
    }
  }
  return(numbers[1])
}

# PART I

number = snail_numbers[[1]]
to_add = snail_numbers[-1]
for(add_number in to_add){
  number = add(number, add_number)
  number = reduce(number)
}

cat("The magnitude of the sum is ", magnitude(number))


# PART II

max_magnitude = 0

for(i in 1:length(snail_numbers)){
  for(j in 1:length(snail_numbers)){
    added = add(snail_numbers[[i]], snail_numbers[[j]])
    added = reduce(added)
    mag = magnitude(added)
    if(mag > max_magnitude){
      cat("New maximum,", mag, i, j, "\n")
      max_magnitude = mag
    }
  }
}

cat("The maximum magnitude is ", max_magnitude)

