
lines = readlines("input")
height = length(lines)
width = length(lines[1])

trees = fill(-1, height+2, width+2)

for (i, line) in enumerate(lines)
    for (j, c) in enumerate(line)
        trees[i+1,j+1] = parse(Int, c)
    end
end

cover_left  = copy(trees)
cover_right = copy(trees)
cover_up    = copy(trees)
cover_down  = copy(trees)
for i in 2:height+1
    for j in 2:height+1
        cover_left[i,j]  = maximum(trees[i,1:j-1])
        cover_right[i,j] = maximum(trees[i,j+1:end])
        cover_up[i,j]    = maximum(trees[1:i-1,j])
        cover_down[i,j]  = maximum(trees[i+1:end,j])
    end
end
visible = trees .> cover_left
visible = visible .|| (trees .> cover_right)
visible = visible .|| (trees .> cover_up)
visible = visible .|| (trees .> cover_down)

visible_count = sum(visible)
println("There are ", visible_count, " visible trees.")

