# read the input line and extract positions
data = readLines("input")[1]
data = substring(data, 16, nchar(data))
xs = strsplit(data, ",")[[1]][1]
xs = strsplit(xs, "..", fixed = TRUE)[[1]]
xs = strtoi(xs)
target_x = xs[1]:xs[2]

y_part = strsplit(data, ",")[[1]][2]
ys = substring(y_part, 4, nchar(y_part))
ys = strsplit(ys, "..", fixed = TRUE)[[1]]
ys = strtoi(ys)
target_y = ys[1]:ys[2]

# First find y-values that will hit
# y-velocity is vy - step  and location is s*vy-s*(s-1)/2
# For a positive vy, the trajectory is symmetric around the high point
# with second 0 at 2*vy + 1. Here the velocity is -(yv+1), so the upper limit
# for vy is the lower edge of the target plus one
max_vy = -min(ys)

#find values below this that will hit
vys = c()
y_hit_steps = c()
vy_hit = c()
for(vy in 1:max_vy){
  upper_bound = -max(ys)
  locations = cumsum(-(vy+1) - 0:upper_bound)
  hit_steps = which(locations %in% min(ys):max(ys))
  hit_steps = hit_steps + 2*vy + 1
  y_hit_steps = c(y_hit_steps, hit_steps)
  vy_hit = c(vy_hit, rep(vy, length(hit_steps)))
}

# For negative y, this is just count from the origin
for(vy in 0:(-max_vy)){
  upper_bound = -max(ys)
  locations = cumsum(vy - 0:upper_bound)
  hit_steps = which(locations %in% min(ys):max(ys))
  y_hit_steps = c(y_hit_steps, hit_steps)
  vy_hit = c(vy_hit, rep(vy, length(hit_steps)))
}

# x and y values are independent. Here we find all x values that hit the target
max_vx = max(xs) # should not go over in one step

max_step = max(y_hit_steps)
x_hit_steps = c()
vx_hit = c()
for(vx in 1:max_vx){
  vxs = pmax(vx-0:max_step, 0)
  locations = cumsum(vxs)
  hit_steps = which(locations %in% target_x)
  x_hit_steps = c(x_hit_steps, hit_steps)
  vx_hit = c(vx_hit, rep(vx, length(hit_steps)))
}

# PART I: of the vy values that hit, find the largest one and calculate the 
# highest point int the trajectory

vys_that_hit = vy_hit[y_hit_steps %in% x_hit_steps]
max_vy = max(vys_that_hit)
height = max_vy*(max_vy+1)/2

cat("maximum height is", height, "\n")

# PART II: Find unique combinations of vy and vx
pairs = list()
for(i in 1:length(x_hit_steps)){
  x_step = x_hit_steps[i]
  vx = vx_hit[i]
  vxs = c(vx, vxs)
  for(j in 1:length(y_hit_steps)){
    y_step = y_hit_steps[j]
    vy = vy_hit[j]
    if(x_step == y_step){
      if(!(list(c(vx,vy)) %in% pairs)){
        pairs[length(pairs)+1] = list(c(vx,vy))
      }
    }
  }
}

cat("number of trajectories", length(pairs), "\n")

