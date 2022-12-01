# Since the hallway always looks the same, it's enough to read the amphipod types
data = readLines("input")
rows = length(data)
cols = nchar(data[1])

# Create a base for the map
map = matrix("", rows, cols)

# extract numbers from the character strings
for(r in 1:rows){
  map[r,] = strsplit(data[r], "")[[1]]
}

nb_down = c(2:rows,1)
nb_right = c(2:cols,1)
nb_up = c(rows, 1:(rows-1))
nb_left = c(cols, 1:(cols-1))

for(step in 1:1000){
  old_map = map
  move_from = map == ">" & map[,nb_right] == "."
  move_to = map == "." & map[,nb_left] == ">"
  map[move_to] = map[move_from]
  map[move_from] = "."
  move_from = map == "v" & map[nb_down,] == "."
  move_to = map == "." & map[nb_up,] == "v"
  map[move_to] = map[move_from]
  map[move_from] = "."
  
  changes =sum(old_map != map)
  if(changes == 0){
    cat("No changes on turn", step, "\n")
    break
  }
}
