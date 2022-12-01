library(gmp)
DAYS = 256

# read the fish ages
fish = scan("input", integer(), sep=",")

# count fish in each age group
for(t in 1:9){
  fish_by_age[t] = sum(fish==(t-1))
}
# Use big integers to avoid overflow
fish_by_age = as.bigz(fish_by_age)


# Run for given number of days
for(d in 1:DAYS){
  # Circular shift: update ages and add age 0 fish to age 8
  fish_by_age = c(fish_by_age[2:9],fish_by_age[1])
  
  # The fish at age 0 are also added to age 6
  fish_by_age[7] = fish_by_age[7] + fish_by_age[9]
}

print(sum(fish_by_age))

