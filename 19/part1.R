# read the input lines
data = readLines("example_3d")

# Extract scanners and the beacon positions for each
scanners = list()
scanner = c()
for(line in data){
  if(grepl("---", line)){
    # next scanner
    if(length(scanner) > 0){
      scanner = t(matrix(strtoi(scanner), nrow = 3))
      scanners[length(scanners)+1] = list(scanner)
    }
    scanner = c()
  } else if(line == ""){
    # empty line, skip
  } else {
    # this is a beacon position
    position = strsplit(line, ",")[[1]]
    scanner = c(scanner, position)
  }
}

# Add the last one
if(length(scanner) > 0){
  scanner = t(matrix(strtoi(scanner), nrow = 3))
  scanners[length(scanners)+1] = list(scanner)
}


# I guess we assume that any matches are actual overlaps?
# Construct the rotations from 2 elementary rotations
z_rotation = matrix(
  c(0,1,0,  -1,0,0,  0,0,1),
  nrow = 3,
  ncol = 3
)
y_rotation = matrix(
  c(0,0,1,  0,1,0,  -1,0,0),
  nrow = 3,
  ncol = 3
)
x_rotation = matrix(
  c(1,0,0,  0,0,1,  0,-1,0),
  nrow = 3,
  ncol = 3
)
unit = matrix(
  c(1,0,0,  0,1,0,  0,0,1),
  nrow = 3,
  ncol = 3
)

rotation = unit
rotations = list()
for(d1 in 1:4){ # four x-y faces may face up (z-faces later)
  rotation = rotation %*% z_rotation
  for(d2 in 1:4){ # other direction may be rotated up to 3 times
    rotation = rotation %*% y_rotation
    rotations[length(rotations)+1] = list(rotation)
  }
}

# The other 2 possible up directions
rotation = rotation %*% x_rotation
for(d1 in c(1,3)){ 
  rotation = rotation %*% x_rotation
  rotation = rotation %*% x_rotation
  for(d2 in 1:4){ # other direction may be rotated up to 3 times
    rotation = rotation %*% y_rotation
    rotations[length(rotations)+1] = list(rotation)
  }
}

# sanity check
for(m1 in 1:24){
  for(m2 in 1:24){
    if(m1 != m2){
      if(all(rotations[[m1]] == rotations[[m2]])){
        cat("NOT GOOD", m1, m2, "\n")
      }  
    }
  }
}


compare_scanners = function(scanner1, scanner2){
  # Try all possible rotations
  for(rot in rotations){
    # rotate the second one
    rotated2 = scanner2 %*% rot

    # Check for 12 matching beacons
    for(i in 1:(dim(scanner1)[1])){
      # find distances to this point
      point1 = scanner1[i,]
      for(j in 1:(dim(rotated2)[1])){
        point2 = rotated2[j,]
        translated = rotated2 - point2[col(rotated2)] + point1[col(rotated2)]
        matches = 0
        for(p1 in 1:dim(scanner1)[1]){
          comps = (translated == scanner1[p1,][col(translated)])
          rowcomps = rowSums(comps) == 3
          match = sum(rowcomps) > 0
          if(match){
            matches = matches + 1
          }
          if(matches > 11){
            print(point1-point2)
            break
          }
        }
        if(matches > 11){
          break
        }
      }
      if(matches > 11){
        break
      }
    }
    if(matches > 11){
      break
    }
  }
  if(matches > 11){
    return(translated)
  }
  return(c())
}

found_scanners = c(1)
checked = list()
for(j in 1:length(scanners)){
  checked[j] = list(c())
}

while(length(found_scanners) < length(scanners)){
  for(j in 1:length(scanners)){
    if(!(j %in% found_scanners)){
      for(i in found_scanners){
        if(i != j && !(i %in% checked[[j]])){
          cat(i,j,"\n")
          res = compare_scanners(scanners[[i]], scanners[[j]])
          if(length(res)>0){
            scanners[j] = list(res)
            found_scanners = c(found_scanners, j)
            cat("found", j, "next to", i, "\n")
          }
          checked[j] = list(c(checked[[j]], i))
        }
      }
    }
  }
}


# Now unify the scanner list and count unique scanners
points = c()
for(scanner in scanners){
  points = rbind(points, scanner)
}

points = unique(points)

cat("There are", dim(points)[1], "points\n")

