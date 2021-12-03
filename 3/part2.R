# open the file
connection = file("input", open="r")
N = 12

# Read the whole thing to memory
data = readLines(connection)

# Create copies for oxygen and CO2 ratings
oxygen_data = data
CO2_data = data

find_count <- function(data) {
  count = 0
  for(line in data){
    if(substr(line, i, i)=="1"){
      count = count + 1
    }
  }
  return(count)
}

# Run through oxygen data and filter
for(i in 1:N){
  # First find the most common value
  line_count = length(oxygen_data)
  count = find_count(oxygen_data)
  
  # Now filter
  if(count >= (line_count / 2)){
    filter = ifelse(substr(oxygen_data, i, i)=="1", TRUE, FALSE)
  } else {
    filter = ifelse(substr(oxygen_data, i, i)=="0", TRUE, FALSE)
  }
  oxygen_data = oxygen_data[filter]
  
  # break if there is only one line left
  if(length(oxygen_data)==1){
    break
  }
}

# Same for CO2_data
for(i in 1:N){
  # First find the most common value
  line_count = length(CO2_data)
  count = find_count(CO2_data)
  
  # Now filter
  if(count < (line_count / 2)){
    filter = ifelse(substr(CO2_data, i, i)=="1", TRUE, FALSE)
  } else {
    filter = ifelse(substr(CO2_data, i, i)=="0", TRUE, FALSE)
  }
  CO2_data = CO2_data[filter]
  
  # break if there is only one line left
  if(length(CO2_data)==1){
    break
  }
}

print(oxygen_data)
print(CO2_data)

# Interpret as numbers
base = 1
oxygen_rating = 0
CO2_rating = 0
for(i in N:1){
  if(substr(oxygen_data, i, i)=="1"){
    oxygen_rating = oxygen_rating + base
  }
  if(substr(CO2_data, i, i)=="1"){
    CO2_rating = CO2_rating + base
  }
  base = base*2
}

print(oxygen_rating)
print(CO2_rating)

print(oxygen_rating*CO2_rating)
