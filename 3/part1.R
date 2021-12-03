
# Number of bytes per line
N = 12

# open the file
connection = file("input", open="r")

# count the occurrences of bit "1" and all lines
count = integer(N)
line_count = 0

# read line by line
while ( TRUE ) {
  
  line = readLines(connection, n = 1)
  if(length(line) == 0){
    break
  }
  
  # process line
  for(i in 1:N){
    if(substr(line, i, i)=="1"){
      count[i] = count[i] + 1
    }
  }
  line_count = line_count + 1
  print(count)
}

# Go through the bits and calculate the number
base = 1
gamma_rate = 0
epsilon_rate = 0
for(i in N:1){
  if(count[i] > (line_count / 2.0)){
    gamma_rate = gamma_rate + base
  } else {
    epsilon_rate = epsilon_rate + base
  }
  base = base*2
}

print(gamma_rate)
print(epsilon_rate)
print(gamma_rate*epsilon_rate)

