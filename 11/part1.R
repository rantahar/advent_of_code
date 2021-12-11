# parameters
max_steps = 400

# Read the data and find dimensions
data = readLines("input")
rows = length(data)
cols = nchar(data[1])

# Create a base for the map
energy = matrix(0,rows, cols)

# extract numbers from the character strings
for(r in 1:rows){
  energy[r,] = strtoi(strsplit(data[r], "")[[1]])
}

# For counting the flashes
n_flashes = 0

# Run the simulation
for(i in 1:max_steps){
  # Increase energy by 1
  energy = energy + 1

  # The octopi with enough energy flash
  new_flashes = energy > 9
  flashed = new_flashes
  
  # Check for any flashes and update the neighbours
  changes = sum(new_flashes) > 0
  while(changes){

    # Add 1 for any flashed neighbours in each direction    
    energy[1:(rows-1),1:cols] = energy[1:(rows-1),1:cols] +
      new_flashes[2:rows,1:cols]
    energy[2:rows,1:cols] = energy[2:rows,1:cols] + 
      new_flashes[1:(rows-1),1:cols]
    energy[1:rows,1:(cols-1)] = energy[1:rows,1:(cols-1)] + 
      new_flashes[1:rows,2:cols]
    energy[1:rows,2:cols] = energy[1:rows,2:cols] + 
      new_flashes[1:rows,1:(cols-1)]
    # also diagonals
    energy[1:(rows-1),1:(cols-1)] = energy[1:(rows-1),1:(cols-1)] + 
      new_flashes[2:rows,2:cols]
    energy[2:rows,1:(cols-1)] = energy[2:rows,1:(cols-1)] + 
      new_flashes[1:(rows-1),2:cols]
    energy[1:(rows-1),2:cols] = energy[1:(rows-1),2:cols] + 
      new_flashes[2:rows,1:(cols-1)]
    energy[2:rows,2:cols] = energy[2:rows,2:cols] + 
      new_flashes[1:(rows-1),1:(cols-1)]
    
    
    new_flashes = energy > 9 & !flashed
    changes = sum(new_flashes) > 0  
    flashed = flashed | new_flashes
  }
  
  n_flashes = n_flashes + sum(flashed)
  energy[flashed] = 0
  
  if(i == 100){
    cat("After", steps, "steps there have been", n_flashes, "flashes\n")
  }

  if(sum(flashed) == 100){
    cat("Flashes have synchronized after", i, "steps\n")
    break
  }  
}


