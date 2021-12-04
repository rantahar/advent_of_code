library(comprehenr)

# open the file
connection = file("input", open="r")

# read first line
numbers = readLines(connection, n = 1)
numbers = strsplit(numbers, split = ",")[[1]]

# There is an empty line here
readLines(connection, n = 1)

tables = c()

# Read the tables
while ( TRUE ) {
  
  table = matrix(0, 5, 5)
  for(i in 1:5){
    line = readLines(connection, n = 1)
    if(length(line) == 0){
      break
    }
    line = trimws(line)
    
    split_line = strsplit(line, split = "\\s+")[[1]]
    for(j in 1:5){
      table[i,j] = strtoi(split_line[j]);
    }
  }
  
  if(length(line) == 0){
    break
  }
  
  tables = append(tables, list(table))
  
  # There is an empty line here
  readLines(connection, n = 1)
}

marks = to_list(for(i in 1:length(tables)+1) matrix(0, 5, 5))
winning_tables = matrix(FALSE, 1, length(tables))

# Now run through the list of numbers and check each table
for(n in numbers){
  for(t in 1:length(tables)){
    if(winning_tables[t] == FALSE){
      table = tables[[t]]
      filter = ifelse( table == strtoi(n[[1]]), TRUE, FALSE)
      mark = marks[[t]]
      mark[filter] = 1
      marks[[t]] = mark
      
      wins = sum(colSums(mark) == 5) + sum(rowSums(mark) == 5)
      if(wins > 0){
        filter = ifelse( mark == 0, TRUE, FALSE)
        score = sum(table[filter])*strtoi(n[[1]])
        print(sprintf("table %i wins with score %d", t, score))
        winning_tables[t] = TRUE
      }
    }
  }
}

print(winning_tables[[length(winning_tables)]])
