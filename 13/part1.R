# Read the data
data = readLines("input")

dots = c()
folds = list()

width = 0
height = 0

for(line in data){
  if( startsWith(line, "fold along") ){
    direction = substr(line, 12,12)
    number = substr(line, 14,100)
    folds[length(folds)+1] = list(c(direction, number))
  } else {
    if(nchar(line)>0){
      coords = strsplit(line, ",")
      x = strtoi(coords[[1]][1])+1
      y = strtoi(coords[[1]][2])+1
      dots = c(dots, x, y)
      if(width < x){
        width = x
      }
      if(height<y){
        height = y
      }
    }
  }
}

dots = matrix(dots, nrow=2)

paper = matrix(FALSE, nrow=height, ncol=width)

for(ndot in 1:dim(dots)[2]){
  paper[dots[2,ndot], dots[1,ndot]] = TRUE
}


for(fold in folds){
  if(fold[1] == "y"){
    up = paper[1:fold[2], 1:dim(paper)[2]]
    down = paper[dim(paper)[1]:(strtoi(fold[2])+2), 1:dim(paper)[2]]
    diff = dim(up)[1] - dim(down)[1]
    if(diff > 0){
      ys = (diff+1):dim(up)[1]
      xs = 1:dim(up)[2]
      up[ys, xs] = up[ys, xs] | down
      paper = up 
    } else {
      ys = (-diff+1):dim(down)[1]
      xs = 1:dim(up)[2]
      down[ys, xs] = down[ys, xs] | up
      paper = down
    }
  }

  if(fold[1] == "x"){
    up = paper[1:dim(paper)[1], 1:fold[2]]
    down = paper[1:dim(paper)[1], dim(paper)[2]:(strtoi(fold[2])+2)]
    diff = dim(up)[2] - dim(down)[2]
    if(diff > 0){
      ys = 1:dim(up)[1]
      xs = (diff+1):dim(up)[2]
      up[ys, xs] = up[ys, xs] | down
      paper = up 
    } else {
      ys = 1:dim(up)[1]
      xs = (-diff+1):dim(down)[2]
      down[ys, xs] = down[ys, xs] | up
      paper = down
    }
  }
}

paper[!paper] = "."
paper[paper=="TRUE"] = "0"

print(paper)

