
using Formatting

rucksacks = readlines("input")
sum=0

for group in Iterators.partition(rucksacks, 3)
    global sum
    common = intersect(group[1],group[2])
    common = intersect(common,group[3])
    badge = common[1]
    if islowercase(badge)
        priority = badge - 'a' + 1
    else
        priority = badge - 'A' + 27
    end
    sum += priority
end

printfmt("sum: {:d}\n", sum)

