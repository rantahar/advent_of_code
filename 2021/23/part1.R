# Since the hallway always looks the same, it's enough to read the amphipod types
data = readLines("input")

rooms = c(substr(data[3], 4,4), substr(data[4], 4,4))
rooms = c(rooms, substr(data[3], 6,6), substr(data[4], 6,6))
rooms = c(rooms, substr(data[3], 8,8), substr(data[4], 8,8))
rooms = c(rooms, substr(data[3], 10,10), substr(data[4], 10,10))
hallway = rep(0,11)

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
    if(rooms[2*i-1] != i || rooms[2*i] != i){
      return(FALSE)
    }
  }
  return(TRUE)
}

solve = function(rooms, hallway, current_score, level){
  if(animate){
    print(current_score)
    print(hallway)
    print(matrix(rooms, nrow=2))
    Sys.sleep(1)
  }
  if(current_score > min_score){
    # bail
    return(FALSE)
  }
  if(is_solved(rooms, hallway)){
    if(current_score < min_score){
      cat("New minimum solution found with score", current_score, "\n")
      min_score <<- current_score
    }
    return(TRUE)
  }
  for(i in 1:4){
    if(rooms[2*i-1]==0 && rooms[2*i]==0){
      for(j in 1:11) if(hallway[j]==i){
        if((j<(2*i+1) && sum(hallway[(j+1):(2*i+1)]!=0)==0) || 
           (j>(2*i+1) && sum(hallway[(j-1):(2*i+1)]!=0)==0)){
          # cat("move", j, "in to", i, 2, "\n")
          r = rooms
          h = hallway
          r[2*i] = i
          h[j] = 0
          move_cost = amphibian_cost[i]*(abs(2*i+1-j)+2)
          solve(r, h, current_score + move_cost, level+1)
        }
      }
    }
    if(rooms[2*i-1]==0 && rooms[2*i]==i){
      for(j in 1:11) if(hallway[j]==i){
        if((j<(2*i+1) && sum(hallway[(j+1):(2*i+1)]!=0)==0) || 
           (j>(2*i+1) && sum(hallway[(j-1):(2*i+1)]!=0)==0)){
          # cat("move", j, "in to", i, 1, "\n")
          r = rooms
          h = hallway
          r[2*i-1] = i
          h[j] = 0
          move_cost = amphibian_cost[i]*(abs(2*i+1-j)+1)
          solve(r, h, current_score + move_cost, level+1)
        }
      }
    }
    if(rooms[2*i-1] != 0 && (rooms[2*i-1] != i || rooms[2*i] != i)){
      # possible to move out, try it
      for(j in 1:11) if(!(j %in% c(3,5,7,9))) if(sum(hallway[(2*i+1):j]!=0)==0){
        # cat("move out", i, 1, "to", j, "\n")
        a = rooms[2*i-1]
        r = rooms
        h = hallway
        r[2*i-1] = 0
        h[j] = a
        move_cost = amphibian_cost[a]*(abs(2*i+1-j)+1)
        solve(r, h, current_score + move_cost, level+1)
      }
    }
    if(rooms[2*i] != 0 && rooms[2*i] != i && rooms[2*i-1] == 0){
      # possible to move out, try it
      for(j in 1:11) if(!(j %in% c(3,5,7,9))) if(sum(hallway[(2*i+1):j]!=0)==0){
        # cat("move out", i, 2, "to", j, "\n")
        a = rooms[2*i]
        r = rooms
        h = hallway
        r[2*i] = 0
        h[j] = a
        move_cost = amphibian_cost[a]*(abs(2*i+1-j)+2)
        solve(r, h, current_score + move_cost, level+1)
      }
    }
  }
  # print("culdesac, back to previous")
  return(FALSE)
}

min_score = 100000000
solve(rooms, hallway, 0, 0)


