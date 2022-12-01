# Since the hallway always looks the same, it's enough to read the amphipod types
data = readLines("example_input")

rooms = c(substr(data[3], 4,4), "D", "D", substr(data[4], 4,4))
rooms = c(rooms, substr(data[3], 6,6), "C", "B", substr(data[4], 6,6))
rooms = c(rooms, substr(data[3], 8,8), "B", "A", substr(data[4], 8,8))
rooms = c(rooms, substr(data[3], 10,10), "A", "C", substr(data[4], 10,10))
hallway = rep(0,11)

# Any amphipods in the wrong room need to move

rooms = ifelse(rooms=="A", 1, rooms)
rooms = ifelse(rooms=="B", 2, rooms)
rooms = ifelse(rooms=="C", 3, rooms)
rooms = ifelse(rooms=="D", 4, rooms)
rooms = strtoi(rooms)
rooms = matrix(rooms,nrow=4)
original = rooms

amphibian_cost = c(1,10,100,1000)

score = 0
print(hallway)
print(rooms)

move = function(i, j, k){
  print(k)
  a = hallway[[k]]
  b = rooms[[i,j]]
  hallway[k] <<- b
  rooms[i,j] <<- a
  move_cost = amphibian_cost[max(a,b)]*(abs(2*i+1-k)+j+1)
  score <<- score + move_cost
  print(score)
  print(hallway)
  print(rooms)
}

run = function(moves){
  rooms <<- original
  hallway <<- rep(0,11)
  score <<- 0
  for(m in 1:(length(moves)/3)){
    move(moves[3*m-2],moves[3*m-1],moves[3*m])
  }
}


