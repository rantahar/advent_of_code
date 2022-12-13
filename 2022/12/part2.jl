
lines = readlines("input")

height = length(lines)
width = length(lines[1])

map = fill(0, height, width)
start = (0,0)
dest = (0,0)

for (i, line) in enumerate(lines)
    for (j, c) in enumerate(line)
        global start, dest
        if c == 'S'
            map[i,j] =  1 + 'a' - 'a'
            start = (i,j)
        elseif c == 'E'
            map[i,j] = 1 + 'z' - 'a'
            dest = (i,j)
        else
            map[i,j] = 1 + c - 'a'
        end
    end
end

display(map)
println()
println(start)
println(dest)

queue = [dest]
distances = [0]
distance_map = fill(-1, size(map))
distance_map[start...] = 0
while length(queue) > 0
    global distances, queue, distance_map
    indexes = sortperm(distances)
    distances = distances[indexes]
    queue = queue[indexes]
    this = popfirst!(queue)
    distance = popfirst!(distances)

    if map[this...] == 1
        println("done in ", distance, " steps")
        break
    end

    neighbours = [
        (this[1]+1, this[2]),
        (this[1]-1, this[2]),
        (this[1], this[2]+1),
        (this[1], this[2]-1),
    ]
    for next in neighbours
        if next[1] < 1 || next[1] > height || next[2] < 1 || next[2] > width
            continue
        end
        if distance_map[next...] == -1 && (map[next...] - map[this...]) > -2
            distance_map[next...] = distance + 1
            append!(queue, [next])
            append!(distances, [distance + 1])
        end
    end

    #display(distance_map)
    #println()
end

