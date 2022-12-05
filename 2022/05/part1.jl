crates = []

for line in readlines("input")
    # Check if the line describes the starting stack
    # and process it
    if occursin("[", line)
        for (i, crate) in enumerate(Iterators.partition(line, 4))
            if crate[2] != ' '
                while length(crates) < i
                    append!(crates, [[]])
                end
                append!(crates[i], crate[2])
            end
        end
    end

    # Check for move commands and execute
    if occursin("move", line)
        words = split(line, " ")
        count = parse(Int, words[2])
        from = parse(Int, words[4])
        to = parse(Int, words[6])

        for i in 1:count
            crate = popfirst!(crates[from])
            pushfirst!(crates[to], crate)
        end
    end
end

print("Message: ")
for stack in crates
    print("", stack[1])
end
println()


