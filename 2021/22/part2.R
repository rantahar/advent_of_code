# read the input lines
data = readLines("input")

# This will be a matrix with 7 rows: mode, xmin, xmax, ymin, ymax, zmin and zmax
routine = c()

for(line in data){
  m = strsplit(line, split = " ")[[1]]
  if(m[1] == "on"){
    routine = c(routine, 1) # 1 for on
  } else {
    routine = c(routine, 0) # 0 for off
  }
  
  # Coordinates
  coords = strsplit(m[2], split = ",")[[1]]
  for(coord in coords){
    values = strsplit(substr(coord, 3,40), split = "..", fixed = TRUE)[[1]]
    routine = c(routine, strtoi(values))
  }
}

routine = matrix(routine, nrow = 7)

min_x = min(routine[2,])
max_x = max(routine[3,])
min_y = min(routine[4,])
max_y = max(routine[5,])
min_z = min(routine[6,])
max_z = max(routine[7,])

add_cube = function(cubes, new_cube){
  for(cube in cubes){
    # find intersecting region
    mins = ifelse(cube[c(1,3,5)] > new_cube[c(1,3,5)], cube[c(1,3,5)], new_cube[c(1,3,5)])
    maxs = ifelse(cube[c(2,4,6)] < new_cube[c(2,4,6)], cube[c(2,4,6)], new_cube[c(2,4,6)])
    overlap = c(rbind(mins, maxs))
    if(sum(maxs >= mins) == 3){
      # overlap found. Counteract it here
      cubes = append(cubes, list(c(overlap, -cube[7])))
    }
  }
  # add the new cube if positve. Any overlap has been turend off.
  if(new_cube[7] == 1)
  cubes = append(cubes, list(new_cube))
  return(cubes)
}

count_dots = function(cube){
  return( cube[7]*(cube[2]-cube[1]+1)*(cube[4]-cube[3]+1)*(cube[6]-cube[5]+1) )
}

run_command = function(cubes, command){
  xrange = command[2]:command[3]
  yrange = command[4]:command[5]
  zrange = command[6]:command[7]
  if(command[1]==1){
    cubes = add_cube(cubes, c(command[2:7], 1))
  } else {
    cubes = add_cube(cubes, c(command[2:7], -1))
  }
  return(cubes)
}

cubes = list()

for(step in 1:dim(routine)[2]){
  cubes = run_command(cubes, routine[,step])
  count = 0
  for(cube in cubes){
    count = count + count_dots(cube)
  }
  print(count, digits=18)
  cat(step, length(cubes), "\n")
}

