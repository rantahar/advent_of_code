# Read the data
data = readLines("input")

# Define system data
starters = c( ")" = "(" ,  "]" = "[", "}" = "{",  ">" = "<")
closers = c( "(" = ")" ,  "[" = "]", "{" = "}",  "<" = ">")
corruption_scores = c(")" = 3, "]" = 57, "}" = 1197,  ">" = 25137)
completion_scores = c("(" = 1, "[" = 2, "{" = 3,  "<" = 4)

# Zero start values for both exercises
corruption_score = 0
completed_line_scores = c()

# run through the rows
for(string_line in data){
  # Extract individual characters
  line = strsplit(string_line, "")[[1]]

  corrupt = FALSE
  
  # list of started blocks
  started = c(line[1])
  
  for( c in line[2:length(line)] ){
    if(c %in% starters){
      # Starting a new block. Just push it in the list
      started = c(started, c)
    }
    if(c %in% closers){
      # Closing a block. Pop a starter from the list
      starter = tail(started, n=1)
      started = head(started, -1)

      # Check for bad matches
      if(starter != starters[c]){
        # Fount a mismatch. Calculate score
        corruption_score = corruption_score + corruption_scores[c]
        corrupt = TRUE
        break
      }
    }
  }
  
  # No corruption found. Any missing parenthesis should close the ones left
  # in started The score for the character is equal to the index
  if(!corrupt){
    score = 0
    for(c in started[length(started):1]){
      score = score * 5
      score = score + completion_scores[c]
    }
    completed_line_scores = c(completed_line_scores, score)
  }
}

cat("part 1 score:", corruption_score, "\n")

# Find the middle score for completed lines
sorted = sort(completed_line_scores)
cat("part 2 score:", sorted[ceiling(length(sorted)/2)])

