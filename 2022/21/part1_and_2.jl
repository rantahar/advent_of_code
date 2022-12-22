
numbers = Dict()
monkeys = []

for line in readlines("input")
    words = split(line, " ")
    name = words[1][1:end-1]
    operation = words[2:end]
    if length(operation) > 1
        append!(monkeys, [[name, operation...]])
    else
        numbers[name] = parse(BigInt, operation[1])
    end
end

function run(starting_monkeys, starting_numbers, root_compare = false)
    monkeys = copy(starting_monkeys)
    numbers = copy(starting_numbers)

    m = 1
    while length(monkeys) > 0
        monkey = monkeys[m]
        if haskey(numbers, monkey[2]) && haskey(numbers, monkey[4])
            if monkey[1] == "root" && root_compare
                return numbers[monkey[2]] - numbers[monkey[4]]
            end
            if monkey[3] == "+"
                numbers[monkey[1]] = numbers[monkey[2]] + numbers[monkey[4]]
            elseif monkey[3] == "-"
                numbers[monkey[1]] = numbers[monkey[2]] - numbers[monkey[4]]
            elseif monkey[3] == "*"
                numbers[monkey[1]] = numbers[monkey[2]] * numbers[monkey[4]]
            elseif monkey[3] == "/"
                numbers[monkey[1]] = numbers[monkey[2]] / numbers[monkey[4]]
            end
            if monkey[1] == "root"
                return numbers[monkey[1]]
            end
            deleteat!(monkeys, m)
        end
        m = mod(m, length(monkeys)) + 1
    end
end

println("part 1 root = ", BigInt(run(monkeys, numbers)))
println()

function run(n)
    global monkeys, numbers
    numbers["humn"] = n
    run(monkeys, numbers, true)
end

range = [-1000,1000]
vals = run.(range)
while vals[1]*vals[2] > 0
    global vals, range
    range .*= 10
    vals = run.(range)
end

function bisect(range)
    vals = run.(range)
    while vals[1]*vals[2] < 0
        mid = (range[1] + range[2])÷2
        midval = run(mid)
        if midval == 0
            return mid
        end
        if midval*vals[1] < 0
            range[2] = mid
            vals[2] = midval
        else
            range[1] = mid
            vals[1] = midval
        end
    end
end

zero = bisect(range)
println("You should shout ", zero)


