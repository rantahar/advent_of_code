using BenchmarkTools

function range(first, last)
    if first < last
        step = 1
    else
        step = -1
    end
    return first:step:last
end

function read()
    lines = readlines("input")

    grid = fill(0, (1000, 1000))

    floor = 1
    for line in lines
        points = split(line, "->")
        start = split(points[1], ",")
        start = [parse(Int, coord) for coord in start]
        for point in points[1:end]
            point = split(point, ",")
            point = [parse(Int, coord) for coord in point]
            for x in range(start[1], point[1])
                grid[start[2]+1, x] = 1
            end
            if start[1] < point[1]
                step = 1
            else
                step = -1
            end
            for y in range(start[2], point[2])
                grid[y+1, start[1]] = 1
            end
            start = point
            if point[2] > floor-3
                floor = point[2] + 3
            end
        end
    end
    return grid, floor
end

grid, floor = read()
@btime read()

function printgrid(grid)
    println()
    for x in 1:10
        for y in 490:510
            if grid[x, y] == 2
                print("o")
            elseif grid[x, y] == 1
                print("#")
            else
                print(".")
            end
        end
        println()
    end
end

function simulate(grid)
    grid = copy(grid)
    notdone = true
    count = 0
    path = []
    while notdone
        if length(path) == 0
            sand = (1, 500)
        else
            sand = pop!(path)
        end
        while true
            if sand[1] > floor
                notdone = false
                break
            end
            if grid[sand[1]+1, sand[2]] == 0
                append!(path, [sand])
                sand = [sand[1]+1, sand[2]]
            elseif grid[sand[1]+1, sand[2]-1] == 0
                append!(path, [sand])
                sand = [sand[1]+1, sand[2]-1]
            elseif grid[sand[1]+1, sand[2]+1] == 0
                append!(path, [sand])
                sand = [sand[1]+1, sand[2]+1]
            else
                grid[sand...] = 2
                count += 1
                if sand[1] == 1 && sand[2] == 500
                    notdone = false
                end
                break
            end
        end
        #printgrid(grid)
    end
    return count
end

grid1 = copy(grid)
count = simulate(grid1)
@btime simulate(grid1)
println("number of sand grains: ", count)

for x in 1:1000
    grid[floor, x] = 1
end

count = simulate(grid)
@btime simulate(grid)
println("number of sand grains: ", count)
