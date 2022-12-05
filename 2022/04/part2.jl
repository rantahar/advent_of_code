
using Formatting

pairs = readlines("input")
num = 0

function is_in_range(n, range)
    if n >= range[1]
        if n <= range[2]
            return true
        end
    end
    return false
end

for pair in pairs
    global num

    numbers = split(pair, r"[-,]")
    lower_1 = parse(Int, numbers[1])
    upper_1 = parse(Int, numbers[2])
    lower_2 = parse(Int, numbers[3])
    upper_2 = parse(Int, numbers[4])

    is_partial_overlap = is_in_range(lower_1, [lower_2, upper_2])
    is_partial_overlap |= is_in_range(upper_1, [lower_2, upper_2])
    is_partial_overlap |= is_in_range(lower_2, [lower_1, upper_1])
    is_partial_overlap |= is_in_range(upper_2, [lower_1, upper_1])

    num += is_partial_overlap
end

printfmt("num: {:d}\n", num)

