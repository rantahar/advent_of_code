# read the input lines
data = readLines("input")

# parse the input, which this time means reading from position 29
position1 = strtoi(substr(data[1],29,50))
position2 = strtoi(substr(data[2],29,50))

next_die = 1
roll = function(){
  result = next_die
  next_die <<- (next_die %% 100) + 1
  return(result)
}

score1 = 0
score2 = 0

for(turn in 1:10000){
  # player 1
  dies = c(roll(), roll(), roll())
  position1 = (position1 + sum(dies) - 1) %% 10 + 1
  score1 = score1 + position1
  # cat("turn", turn, "player 1 position", position1, "and score", score1, "\n")
  if(score1 >= 1000){
    cat("Player 1 wins on turn", turn, "with score", score1, "\n")
    losing_score = score2
    dies_cast = 6*turn - 3
    break
  }
  
  # player 2
  dies = c(roll(), roll(), roll())
  position2 = (position2 + sum(dies) - 1) %% 10 + 1
  score2 = score2 + position2
  # cat("turn", turn, "player 2 position", position2, "and score", score2, "\n")
  if(score2 >= 1000){
    cat("Player 2 wins on turn", turn, "with score", score2, "\n")
    losing_score = score1
    dies_cast = 6*turn
    break
  }
}

cat("Die cast", dies_cast, "times and losing score is", losing_score,".\n")
cat("Product", dies_cast*losing_score, "\n")

