
lines = readlines("input")
height = length(lines)
width = length(lines[1])

trees = fill(-1, height+2, width+2)

for (i, line) in enumerate(lines)
    for (j, c) in enumerate(line)
        trees[i+1,j+1] = parse(Int, c)
    end
end

visibility_left  = fill(0, height+2, width+2)
visibility_right = fill(0, height+2, width+2)
visibility_up    = fill(0, height+2, width+2)
visibility_down  = fill(0, height+2, width+2)
for i in 2:height+1
    for j in 2:width+1
        for d in 1:width+1-j
            visibility_right[i,j] = d
            if trees[i,j] <= trees[i,j+d]
                break
            end
        end
        for d in 1:j-2
            visibility_left[i,j] = d
            if trees[i,j] <= trees[i,j-d]
                break
            end
        end
        for d in 1:height+1-i
            visibility_up[i,j] = d
            if trees[i,j] <= trees[i+d,j]
                break
            end
        end
        for d in 1:i-2
            visibility_down[i,j] = d
            if trees[i,j] <= trees[i-d,j]
                break
            end
        end
    end
end

scenic_score = visibility_right .* visibility_left .* visibility_up .* visibility_down

println("The best scenic score is ", maximum(scenic_score))
