
using Formatting

pairs = readlines("input")
num = 0

for pair in pairs
    global num

    numbers = split(pair, r"[-,]")
    lower_1 = parse(Int, numbers[1])
    upper_1 = parse(Int, numbers[2])
    lower_2 = parse(Int, numbers[3])
    upper_2 = parse(Int, numbers[4])

    is_full_overlap = false
    if lower_1 <= lower_2
        if upper_2 <= upper_1
            is_full_overlap = true
        end
    end
    if lower_2 <= lower_1
        if upper_1 <= upper_2
            is_full_overlap = true
        end
    end

    num += is_full_overlap
end

printfmt("num: {:d}\n", num)

