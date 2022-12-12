
lines = readlines("input")

monkeys = []

for line in lines
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
        monkeys[end]["operation"] = string(words[4:end]...)
    end

    if words[1] == "Test:"
        monkeys[end]["test"] = parse(Int, words[end])
    end

    if words[2] == "true:"
        monkeys[end]["if_true"] = parse(Int, words[end]) + 1
    end

    if words[2] == "false:"
        monkeys[end]["if_false"] = parse(Int, words[end]) + 1
    end
end


for round in 1:20
    for (m, monkey) in enumerate(monkeys)
        for i in 1:length(monkey["items"])
            old = popfirst!(monkey["items"])
            command = "old="*string(old)*";"*monkey["operation"]
            new = eval(Meta.parse(command))
            new = new ÷ 3
            if mod(new, monkey["test"]) == 0
                throw_to = monkey["if_true"]
            else
                throw_to = monkey["if_false"]
            end
            append!(monkeys[throw_to]["items"], new)
            monkey["times_inspected"] += 1
        end
    end
end


for (m, monkey) in enumerate(monkeys)
    println(m, " ", monkey["times_inspected"])
end

sorted = sort(
    [monkey["times_inspected"] for monkey in monkeys],
    rev=true
)

println("Score: ", sorted[1]*sorted[2])

