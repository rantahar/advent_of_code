
using Formatting

food_items = readlines("input")

current_sum = 0
max = 0

for item in food_items
    global current_sum, max
    if item == ""
        if current_sum > max
            max = current_sum
        end
        current_sum = 0
    else
        current_sum += parse(Int64, item)
    end
end

if current_sum > max
    max = current_sum
end


printfmt("Max = {:d}\n", max)

