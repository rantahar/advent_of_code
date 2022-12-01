
using Formatting

food_items = readlines("input")

current_sum = 0
max_elves = [0, 0, 0]

for item in food_items
    global current_sum, max
    if item == ""
        for (i, max) in enumerate(max_elves)
            if current_sum > max
                max_elves[i] = current_sum
                sort!(max_elves)
                break
            end
        end
        current_sum = 0
    else
        current_sum += parse(Int64, item)
    end
end

for (i, max) in enumerate(max_elves)
    if current_sum > max
        max_elves[i] = current_sum
        sort!(max_elves)
    end
end


println(max_elves)
printfmt("Calories on elves with most calories: {:d}, {:d} and {:d}\n",
      max_elves[1], max_elves[2], max_elves[3])

printfmt("All togeher this is {:d}\n", sum(max_elves))


