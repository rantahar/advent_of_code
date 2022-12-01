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

routine = routine[,routine[2,] >= -50 & routine[3,] <= 50]
routine = routine[,routine[4,] >= -50 & routine[5,] <= 50]
routine = routine[,routine[6,] >= -50 & routine[7,] <= 50]


run_command = function(cubes, command){
  xrange = 51 + command[2]:command[3]
  yrange = 51 + command[4]:command[5]
  zrange = 51 + command[6]:command[7]
  cubes[xrange, yrange, zrange] = command[1]
  return(cubes)
}

cubes = array(0, dim=c(101,101,101))

for(step in 1:dim(routine)[2]){
  cubes = run_command(cubes, routine[,step])
}

