# open the file
connection = file("input", open="r")

# read first line
numbers = readLines(connection, n = 1)
numbers = strsplit(numbers, split = ",")[[1]]

# Read the rest and get the matrix
tables = read.delim(connection, header=FALSE, sep="")
tables = data.matrix(tables)

# the first index contains the rows of all the tables. Restructure here
n_tables = dim(tables)[1]/5
tables = array(tables, dim=c(5,n_tables,5))
tables = aperm(tables, c(1,3,2))

# Now we have the tables as a 5x5x100 array

# Array to remember the marks
marks_mat = array(0, dim=dim(tables))
# Also remember which tables have already won and exclude them
already_won = matrix(FALSE, 1, dim(tables)[3])

# Run through the number
turn=0
for(n in numbers){
  # mark the number
  filter = ifelse( tables == strtoi(n[[1]]), TRUE, FALSE)
  marks_mat[filter] = 1
  
  # Check for fully marked rows and columns
  row_win = apply(marks_mat, MARGIN=c(1, 3), sum) == 5
  col_win = apply(marks_mat, MARGIN=c(2, 3), sum) == 5
  win_count = apply(row_win + col_win, MARGIN=c(2), sum)
  
  winners = win_count>0 & !already_won
  n_winners = sum(winners)

  # mark winners so that they are excluded later
  already_won[win_count>0] = TRUE
  winning_indexes = which(winners)
  
  # calculate scores for each table
  scores = tables
  scores[marks_mat == 1] = 0
  scores = apply(scores, MARGIN=c(3), sum)*strtoi(n[[1]])
  scores = scores[winners]
  
  # print winners 
  if(length(winning_indexes>0)){
    for(i in 1:length(winning_indexes)){
      print(sprintf("%d won on turn %d with score %d", winning_indexes[i], turn, scores[i]))
    }
  }
  turn = turn+1
}
