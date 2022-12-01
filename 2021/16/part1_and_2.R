# Read the input data and convert to binary
data = readLines("input")

# Last example:
# data = "9C0141080250320F1802104A08"

sequence = c()
for(char in strsplit(data, "")[[1]]){
  number = strtoi(paste("0x", char, sep=""))
  # each hex value encodes 5 bits
  bits = as.integer(intToBits(number))
  bits = bits[4:1]
  sequence = c(sequence, bits)
}

# pad with 0s to simplify handling sequence end
sequence = c(sequence, c(0,0))


# Funtion to convert a bit sequence into a number
bits_to_number = function(bits){
  d = 1
  number = 0
  for(b in bits[length(bits):1]){
    number = number + b*d
    d = d*2
  }
  return(number)
}

# Read the contents of a literal block
skim_literal_block = function(sequence){
  # skim until we find a 5-byte block starting with 0
  number = c()
  while(sequence[1] == 1){
    number = c(number, sequence[2:5])
    sequence = sequence[6:length(sequence)]
  }
  # Read the last block as well
  number = c(number, sequence[2:5])
  sequence = sequence[6:length(sequence)]
  number = bits_to_number(number)
  return(list(sequence, number))
}

# Read on operator. It contains subpacket length and subpackets
read_operator = function(sequence, versions, type){
  # The first bit indicates the sub packet length
  length_byte = sequence[1]
  sequence = sequence[2:length(sequence)]
  
  # Handle the subpackets
  sub_results = c()
  if(length_byte==1){
    # Number of subpackages
    subpackages = bits_to_number(sequence[1:11])
    sequence = sequence[12:length(sequence)]
    
    # Handle the subpackets
    for(s in 1:subpackages){
      sub_data = skim_packet(sequence, versions)
      sequence = sub_data[[1]]
      versions = sub_data[[2]]
      number = sub_data[[3]]
      sub_results = c(sub_results, number)
    }
  } else {
    # Number of bits in the subsequence
    subbits = bits_to_number(sequence[1:15])
    
    # cut out the subsequence
    sequence = sequence[16:length(sequence)]
    subsequence = c(sequence[1:subbits],0,0) # pad with a couple of 0s
    sequence = sequence[(subbits+1):length(sequence)]
    
    # Handle the subpackets
    while(sum(subsequence) > 0){
      sub_data = skim_packet(subsequence, versions)
      subsequence = sub_data[[1]]
      versions = sub_data[[2]]
      number = sub_data[[3]]
      sub_results = c(sub_results, number)
    }
  }
  
  # Apply the operation to the subpacket results
  if(type == 0) {
    number = sum(sub_results)
  }
  if(type == 1) {
    number = prod(sub_results)
  }
  if(type == 2) {
    number = min(sub_results)
  }
  if(type == 3) {
    number = max(sub_results)
  }
  if(type == 5) {
    number = as.integer(sub_results[1] > sub_results[2])
  }
  if(type == 6) {
    number = as.integer(sub_results[1] < sub_results[2])
  }
  if(type == 7) {
    number = as.integer(sub_results[1] == sub_results[2])
  }
  
  return(list(sequence, versions, number))
}


# Read a packet
skim_packet = function(sequence, versions){
  # Starting a new packet, should start with a version
  version = bits_to_number(sequence[1:3])
  sequence = sequence[4:length(sequence)]
  versions = c(versions, version)
  
  type = bits_to_number(sequence[1:3])
  sequence = sequence[4:length(sequence)]
  
  cat("Packet version", version, "and type", type, "\n")
  
  if(type == 4){
    data = skim_literal_block(sequence)
    sequence = data[[1]]
    number = data[[2]]
    cat("Literal", number, "\n")
  } else {
    data = read_operator(sequence, versions, type)
    sequence = data[[1]]
    versions = data[[2]]
    number = data[[3]]
    cat("Operator", number, "\n")
  }
  
  return(list(sequence, versions, number))
}


# Skim through looking for version bits
versions = c()
while(sum(sequence) > 0){
  data = skim_packet(sequence, versions)
  sequence = data[[1]]
  versions = data[[2]]
  number = data[[3]]
}

cat("sum of versions is", sum(versions), "\n")
cat("final number result is", number, "\n")

