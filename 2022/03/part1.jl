
using Formatting

rucksacks = readlines("input")
sum=0

for rucksack in rucksacks
    global sum
    priorities = []
    for item in rucksack
        if islowercase(item)
            append!(priorities, item - 'a' + 1)
        else
            append!(priorities, item - 'A' + 27)
        end
    end
    repeated = intersect(priorities[1:end÷2],priorities[end÷2+1:end])
    sum += repeated[1]
end

printfmt("sum: {:d}\n", sum)

