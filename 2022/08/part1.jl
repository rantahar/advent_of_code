
lines = readlines("input")
height = length(lines)
width = length(lines[1])

trees = fill(-1, height+2, width+2)

for (i, line) in enumerate(lines)
    for (j, c) in enumerate(line)
        trees[i+1,j+1] = parse(Int, c)
    end
end

visible = fill(0, height+2, width+2)

for i in 2:height+1
    current_max = -1
    for j in 2:height+1
        if trees[i,j] > current_max
            visible[i,j] = 1
            current_max = trees[i,j]
        end
    end
    current_max = -1
    for j in height+1:-1:2
        if trees[i,j] > current_max
            visible[i,j] = 1
            current_max = trees[i,j]
        end
    end
    current_max = -1
    for j in 2:height+1
        if trees[j,i] > current_max
            visible[j,i] = 1
            current_max = trees[j,i]
        end
    end
    current_max = -1
    for j in height+1:-1:2
        if trees[j,i] > current_max
            visible[j,i] = 1
            current_max = trees[j,i]
        end
    end
end

visible_count = sum(visible)
println("There are ", visible_count, " visible trees.")
