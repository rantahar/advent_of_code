library(bit64)

# read the input lines
data = readLines("input")

# parse the input, which this time means reading from position 29
position1 = strtoi(substr(data[1],29,50))
position2 = strtoi(substr(data[2],29,50))

# Now we count the different board positions with a nonzero amplitude. There
# are no superpositions, so a real number is sufficient. The only interaction
# is when a player wins, and the other player can be at any possible state at
# that point.
# So we enumerate these states independently.
# The index of a state is 10*position + score

states1 = matrix(integer64(310), nrow=10)
states2 = matrix(integer64(310), nrow=10)
states1[position1] = 1
states2[position2] = 1

# The time evolution operator: move each point forward according to the
# multiplicity of die rolls and to the right according to the 
take_turn = function(states){
  moved = matrix(integer64(310), nrow=10)
  # First add states according to die roll multiplicities
  die_mul = c(0,0,1,3,6,7,6,3,1)
  for(d in 3:9){
    moved[(d+1):10,] = moved[(d+1):10,] + die_mul[d]*states[1:(10-d),]
    moved[1:d,] = moved[1:d,] + die_mul[d]*states[(10-d+1):10,]
  }
  # shift to the right according to the number of points
  shifted = matrix(integer64(310), nrow=10)
  for(r in 1:10){
    shifted[r,r+1:21] = moved[r,1:21]
  }
  return(shifted)
}

count_wins = function(states1, states2){
  multiplicity = sum(states2[,0:21])
  wins = sum(states1[,22:31])
  return(multiplicity*wins)
}

wins = integer64(2)

for(turn in 1:10){
  states1 = take_turn(states1)
  wins[1] = wins[1] + count_wins(states1, states2)
  states2 = take_turn(states2)
  wins[2] = wins[2] + count_wins(states2, states1)
  print(wins, digits=16)
}



