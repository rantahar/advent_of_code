# Read the positions
data = scan("input", integer(), sep=",")

# So now the cost is (d*(d+1))/2, where d is the distance
cost <- function(target){
  distances = abs(data-target)
  costs = distances*(distances+1)/2
  value = sum(costs)
  return(value)
}

# The cost has a single minimum, so the derivative tells us which direction
# to update

t = 0
c1 = cost(t)
c2 = cost(t+1)
diff = c2-c1

if(diff > 0){
  step = -1
} else {
  step = 1
}

while(step*(c2-c1)<0){
  t = t+step
  c1 = cost(t)
  c2 = cost(t+1)
  cat(t, c1, c2, "\n")
}

cat("Target is", t, "and the cost is", cost(t), "\n")