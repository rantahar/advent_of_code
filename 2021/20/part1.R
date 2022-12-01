# read the input lines
data = readLines("input")

enhancement = c()
map = c()

# Read the enhancement line first
reading_enhancement = TRUE
for(line in data){
  if(line==""){
    reading_enhancement = FALSE
    
  } else{
    chars = strsplit(line, "")[[1]]
    segment = ifelse(chars == "#", 1, 0)
    
    if(reading_enhancement){
      enhancement = c(enhancement, segment)
    } else {
      map = c(map, segment)
      map = matrix(map, ncol=length(segment))
    }
  }
}

map = t(map)

enhance = function(map, enhancement, padding){
  # pad the map with 0s
  dims = dim(map)
  rows = dims[1]+4
  cols = dims[2]+4
  padded = matrix(rep(padding, rows*cols), ncol=cols)
  padded[3:(dims[1]+2), 3:(dims[2]+2)] = map
  binary = list(
    padded[1:(rows-2), 1:(cols-2)],
    padded[1:(rows-2), 2:(cols-1)],
    padded[1:(rows-2), 3:cols],
    padded[2:(rows-1), 1:(cols-2)],
    padded[2:(rows-1), 2:(cols-1)],
    padded[2:(rows-1), 3:cols],
    padded[3:rows, 1:(cols-2)],
    padded[3:rows, 2:(cols-1)],
    padded[3:rows, 3:cols]
  )
  nums = matrix(rep(1, (rows-2)*(cols-2)), ncol=(cols-2))
  d = 1
  for(b in length(binary):1){
    nums = nums + d*binary[[b]]
    d = d*2
  }
  new_map = matrix(enhancement[nums], ncol=cols-2)
  return(new_map)
}

cat(sum(map),"pixels lit at start\n")

padding = 0 # padding starts as 0, but depending on the first enhancement byte,
            # may keep switching
for(step in 1:50){
  map = enhance(map, enhancement, padding)
  if(step == 2){
    cat(sum(map),"pixels lit\n")
  }
  if(step == 50){
    cat(sum(map),"pixels lit\n")
  }
  if(enhancement[1]){
    padding = as.integer(!padding)
  }
}



