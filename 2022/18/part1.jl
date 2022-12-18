lines = readlines("input")

grid = fill(0,(50,50,50))

faces = 0

for line in lines
    global faces
    x,y,z = split(line, ",")
    x = parse(Int, x) + 2
    y = parse(Int, y) + 2
    z = parse(Int, z) + 2
    coord = [x,y,z]

    grid[x,y,z] = 1
    faces += 6

    for dir in 1:3
        for sign in [-1,1]
            nb = copy(coord)
            nb[dir] += sign
            if nb[dir] > 0 &&  grid[nb...] == 1
                faces -= 2
            end
        end
    end
end

println("number of faces: ", faces)

faces = 0
queue = [[50,50,50]]
while length(queue) > 0
    global faces
    coord = pop!(queue)
    for dir in 1:3
        for sign in [-1,1]
            nb = copy(coord)
            nb[dir] += sign
            if nb[dir] > 0 &&  nb[dir] <= 50
                if grid[nb...] == 1
                    faces += 1
                elseif grid[nb...] == 0
                    append!(queue, [nb])
                    grid[nb...] = 2
                end
            end
        end
    end
end

println("Out facing faces: ", faces)
