lines = readlines("input")

numbers = [parse(Int, line) for line in lines]
shuffled = copy(numbers)
indexes = Array(1:length(numbers))

N = length(numbers)

function shuffle(numbers, indexes, N, steps)
  for step in 1:steps
    for n in 1:N
        old_index = indexes[n]
        number = numbers[n]
        for i in 1:N
            if indexes[i] > old_index
                indexes[i] -= 1
            end
        end

        new_index = mod(old_index - 1 + number, N-1) + 1
        for i in 1:N
            if indexes[i] >= new_index
                indexes[i] = mod(indexes[i], N) + 1
            end
        end

        indexes[n] = new_index
    end

    #for n in 1:N
    #    for i in 1:N
    #        if indexes[i] == n
    #            print(numbers[i], ", ")
    #        end
    #    end
    #end
    #println()
  end

  coord_start = 0
  for i in 1:N
      if numbers[i] == 0
          coord_start = indexes[i]
          break
      end
  end

  coord_sum = 0
  for c in [1000, 2000, 3000]
      c = mod(coord_start+c-1, N) + 1
      for i in 1:N
           if indexes[i]==c
               println(numbers[i])
               coord_sum += numbers[i]
           end
      end
  end
  println("sum: ", coord_sum)
end

shuffle(numbers, indexes, N, 1)

for i in 1:N
    numbers[i] *= 811589153
end

indexes = Array(1:length(numbers))
shuffle(numbers, indexes, N, 10)
