# Since the hallway always looks the same, it's enough to read the amphipod types
monad = readLines("input")

# There are 4 registers. Initial value should not matter, make it zero
registers = c("w" = 0, "x" = 0, "y" = 0, "z" = 0)

blocks = list()
block = c()
for(op in monad){
  if(grepl("inp ", op)){
    blocks[length(blocks)+1] = list(block)
    block=c()
  }
  block = c(block, op)
}
blocks[length(blocks)] = list(block)

run_op = function(opstr, input){
  op = strsplit(opstr, split=" ")[[1]]
  if(op[1] == "inp"){
    registers[op[2]] <<- input[1]
    input = input[-1]
  }
  if(op[1] == "add"){
    if(op[3] %in% c("w", "x", "y", "z")){
      registers[op[2]] <<- registers[op[2]] + registers[op[3]]
    } else {
      registers[op[2]] <<- registers[op[2]] + strtoi(op[3])
    }
  }
  if(op[1] == "mul"){
    if(op[3] %in% c("w", "x", "y", "z")){
      registers[op[2]] <<- registers[op[2]] * registers[op[3]]
    } else {
      registers[op[2]] <<- registers[op[2]] * strtoi(op[3])
    }
  }
  if(op[1] == "div"){
    if(op[3] %in% c("w", "x", "y", "z")){
      registers[op[2]] <<- floor(registers[op[2]] / registers[op[3]])
    } else {
      registers[op[2]] <<- floor(registers[op[2]] / strtoi(op[3]))
    }
  }
  if(op[1] == "mod"){
    if(op[3] %in% c("w", "x", "y", "z")){
      registers[op[2]] <<- registers[op[2]] %% registers[op[3]]
    } else {
      registers[op[2]] <<- registers[op[2]] %% strtoi(op[3])
    }
  }
  if(op[1] == "eql"){
    if(op[3] %in% c("w", "x", "y", "z")){
      registers[op[2]] <<- registers[op[2]] == registers[op[3]]
    } else {
      registers[op[2]] <<- registers[op[2]] == strtoi(op[3])
    }
  }
  return(input)
}


parse_op = function(opstr, state, input_index){
    op = strsplit(opstr, split=" ")[[1]]
    if(op[1] == "inp"){
      state[op[2]] = sprintf("i[%d]", input_index)
    }
    if(op[1] == "add"){
      if(op[3] %in% c("w", "x", "y", "z")){
        rhs = state[op[3]]
      } else {
        rhs = op[3]
      }
      if(rhs != "0" && state[op[2]] != "0"){
        state[op[2]] = sprintf("%s + %s", state[op[2]], rhs)
      } else if(rhs != "0"){
        state[op[2]] = sprintf("%s", rhs)
      }
    }
    if(op[1] == "mul"){
      if(op[3] %in% c("w", "x", "y", "z")){
        rhs = state[op[3]]
      } else {
        rhs = op[3]
      }
      if(rhs == "0" || state[op[2]] == "0"){
        state[op[2]] = sprintf("0")
      } else {
        state[op[2]] = sprintf("(%s) * (%s)", state[op[2]], rhs)
      }
    }
    if(op[1] == "div"){
      if(op[3] %in% c("w", "x", "y", "z")){
        rhs = state[op[3]]
      } else {
        rhs = op[3]
      }
      if(rhs != "1"){
        state[op[2]] = sprintf("(%s) / (%s)", state[op[2]], rhs)
      }
    }
    if(op[1] == "mod"){
      if(op[3] %in% c("w", "x", "y", "z")){
        state[op[2]] = sprintf("(%s) %s (%s)", state[op[2]], "%%", state[op[3]])
      } else {
        state[op[2]] = sprintf("(%s) %s (%s)", state[op[2]], "%%", op[3])
      }
    }
    if(op[1] == "eql"){
      if(op[3] %in% c("w", "x", "y", "z")){
        state[op[2]] = sprintf("(%s) == (%s)", state[op[2]], state[op[3]])
      } else {
        state[op[2]] = sprintf("(%s) == (%s)", state[op[2]], op[3])
      }
    }
    return(state)
}


run_monad = function(input, monad){
  for(opstr in monad){
    print(opstr)
    input = run_op(opstr, input)
  }
}

run_to_next_input = function(input, place){
  for(i in place:length(monad)){
    run_op(monad[place], input)
    place = place+1
    if(grepl("inp ", monad[place])){
      break
    }
  }
  return(place)
}


test_inputs = function(input, i, place){
  if(i < 13){
    cat(paste(input, sep=""), "\n")
  }
  for(v in 9:1){
    input[i] = v
    new_place = run_to_next_input(c(v), place)
    if(new_place < length(monad)){
      done = test_inputs(input, i+1, new_place)
      if(done){
        return(TRUE)
      }
    } else {
      # last place, check for 0
      if(registers['z'] == 0){
        cat("value", paste(input, sep=""), "result", registers['z'], "\n")
        return(TRUE)
      }
    }
  }
  return(FALSE)
}


state = c("w" = "0", "x" = "0", "y" = "0", "z" = "0")
parse_block = function(block, block_index, state){
  for(i in 1:length(block)){
    state = parse_op(block[i], state, block_index)
  }
  return(state)
}



