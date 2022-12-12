
lines = readlines("input")

monkeys = []
modder = 1

for line in lines
    global modder
    words = split(line, " ")
    words = [w for w in words if w != ""]
    if length(words) == 0
        continue
    end
    if words[1] == "Monkey"
        monkey = Dict{String, Any}("times_inspected" => 0)
        append!(monkeys, [monkey])
    end

    if words[1] == "Starting"
        monkeys[end]["items"] = []
        for item in words[3:end]
            item = replace.(item, "," => "")
            item = parse(Int, item)
            append!(monkeys[end]["items"], item)
        end
    end

    if words[1] == "Operation:"
        if words[4] == "old" && words[5] == "*" && words[6] == "old"
            monkeys[end]["operation"] = "square"
        elseif words[5] == "+"
            monkeys[end]["operation"] = "add"
            monkeys[end]["operand"] = parse(Int, words[6])
        elseif words[5] == "*"
            monkeys[end]["operation"] = "mult"
            monkeys[end]["operand"] = parse(Int, words[6])
        end
    end

    if words[1] == "Test:"
        monkeys[end]["test"] = parse(Int, words[end])
        modder *= monkeys[end]["test"]
    end

    if words[2] == "true:"
        monkeys[end]["if_true"] = parse(Int, words[end]) + 1
    end

    if words[2] == "false:"
        monkeys[end]["if_false"] = parse(Int, words[end]) + 1
    end
end

function run(monkeys, modder)
    for round in 1:10000
        for (m, monkey) in enumerate(monkeys)
            for i in 1:length(monkey["items"])
                old = popfirst!(monkey["items"])
                if monkey["operation"] == "square"
                    new = old * old
                elseif monkey["operation"] == "mult"
                    new = old * monkey["operand"]
                elseif monkey["operation"] == "add"
                    new = old + monkey["operand"]
                end
                new = mod(new, modder)
                if mod(new, monkey["test"]) == 0
                    throw_to = monkey["if_true"]
                else
                    throw_to = monkey["if_false"]
                end
                modder
                append!(monkeys[throw_to]["items"], new)
                monkey["times_inspected"] += 1
            end
        end

        if mod(round, 1000) == 0
            println("# ", round)
            for (m, monkey) in enumerate(monkeys)
                println(m, " ", monkey["times_inspected"])
            end
        end
    end

    return monkeys
end

monkeys = run(monkeys, modder)

sorted = sort(
    [monkey["times_inspected"] for monkey in monkeys],
    rev=true
)

println("Score: ", sorted[1]*sorted[2])

