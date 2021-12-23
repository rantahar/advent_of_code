# Since the hallway always looks the same, it's enough to read the amphipod types
data = readLines("input")

# Insert the extra lines here
rooms = c(substr(data[3], 4,4), "D", "D", substr(data[4], 4,4))
rooms = c(rooms, substr(data[3], 6,6), "C", "B", substr(data[4], 6,6))
rooms = c(rooms, substr(data[3], 8,8), "B", "A", substr(data[4], 8,8))
rooms = c(rooms, substr(data[3], 10,10), "A", "C", substr(data[4], 10,10))
hallway = rep(0,11)
spaces = 4

# Any amphipods in the wrong room need to move

rooms = ifelse(rooms=="A", 1, rooms)
rooms = ifelse(rooms=="B", 2, rooms)
rooms = ifelse(rooms=="C", 3, rooms)
rooms = ifelse(rooms=="D", 4, rooms)
rooms = strtoi(rooms)

amphibian_cost = c(1,10,100,1000)
animate = FALSE

# move one amphipod at a time, first from top

is_solved = function(rooms, hallway){
  if(sum(hallway != 0) > 0){
    return(FALSE)
  }
  for(i in 1:4){
    for(layer in 1:spaces){
      if(rooms[spaces*(i-1)+layer] != i){
        return(FALSE)
      }      
    }
  }
  return(TRUE)
}

rooms_stack = list(rooms)
hallway_stack = list(hallway)
scores = c(0)
min_score = 10000000

step = 0
while(TRUE){
  step = step + 1
  if(length(scores) == 0){
    print("Done!")
    break
  }
  
  # pop the stack
  index = length(scores)
  score = scores[index]
  rooms = rooms_stack[[index]]
  hallway = hallway_stack[[index]]
  scores = scores[-index]
  rooms_stack = rooms_stack[-index]
  hallway_stack = hallway_stack[-index]
  
  if(animate){
    print(hallway)
    print(matrix(rooms, nrow=spaces))
    Sys.sleep(0.1)
  }
  if(is_solved(rooms, hallway)){
    if(score < min_score){
      cat("New minimum solution found with score", score, "\n")
      min_score = score
    }
  }
  jumped = FALSE
  if(FALSE) for(i in 1:4){
    # find last zero layer
    layer = spaces
    for(l in 1:spaces){
      if(rooms[spaces*(i-1)+l] != 0){
        layer = l-1
        break
      }
    }
    can_move_to = TRUE
    if(layer < spaces) for(l in (layer+1):spaces){
      if(rooms[spaces*(i-1)+l]!=i){
        can_move_to = FALSE
        break
      }
    }
    # jump directly to target if possible
    for(i2 in 1:i) if(i!=i2){
      layer2 = spaces+1
      for(l in 1:spaces){
        if(rooms[spaces*(i2-1)+l] != 0){
          layer2 = l
          break
        }
      }
      if(can_move_to && layer > 0 && layer2 < spaces &&
         rooms[spaces*(i2-1)+layer2] == i && sum(hallway[(2*i2+1):(2*i+1)]!=0)==0){
        # cat(i, "jumping from", i2, layer2, "to",i,layer,"\n")
        r = rooms
        h = hallway
        r[spaces*(i-1)+layer] = i
        r[spaces*(i2-1)+layer2] = 0
        move_cost = amphibian_cost[i]*(abs(2*(i-i2))+layer+layer2)
        scores = c(scores, score+move_cost)
        rooms_stack = append(rooms_stack, list(r))
        hallway_stack = append(hallway_stack, list(h))
        jumped = TRUE
      }
    }
    if(jumped){
      break
    }
  }
  # otherwise try moving an amphibian in or out
  if(!jumped) for(i in 1:4){
    # find last zero layer
    layer = spaces
    for(l in 1:spaces){
      if(rooms[spaces*(i-1)+l] != 0){
        layer = l-1
        break
      }
    }
    can_move_to = TRUE
    if(layer < spaces) for(l in (layer+1):spaces){
      if(rooms[spaces*(i-1)+l]!=i){
        can_move_to = FALSE
        break
      }
    }
    if(can_move_to && layer > 0) {
      for(j in 1:11) if(hallway[j]==i){
        if((j<(2*i+1) && sum(hallway[(j+1):(2*i+1)]!=0)==0) || 
           (j>(2*i+1) && sum(hallway[(j-1):(2*i+1)]!=0)==0)){
          # cat("move", j, "in to", i, layer, "\n")
          r = rooms
          h = hallway
          r[spaces*(i-1)+layer] = i
          h[j] = 0
          move_cost = amphibian_cost[i]*(abs(2*i+1-j)+layer)
          scores = c(scores, score+move_cost)
          rooms_stack = append(rooms_stack, list(r))
          hallway_stack = append(hallway_stack, list(h))
        }
      }
    }

    # try moving out the first nonzero layer
    layer = layer + 1
    if(!jumped)  if(!can_move_to && layer <= spaces) {
      # if column cannot be moved to, it can be moved from
      
      for(j in 1:11) if(!(j %in% c(3,5,7,9))) if(sum(hallway[(2*i+1):j]!=0)==0){
        # cat("move out", i, layer, "to", j, "\n")
        a = rooms[spaces*(i-1)+layer]
        r = rooms
        h = hallway
        r[spaces*(i-1)+layer] = 0
        h[j] = a
        move_cost = amphibian_cost[a]*(abs(2*i+1-j)+layer)
        scores = c(scores, score+move_cost)
        rooms_stack = append(rooms_stack, list(r))
        hallway_stack = append(hallway_stack, list(h))
      }
    }
  }
}



