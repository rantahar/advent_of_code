lines = readlines("input")
height = length(lines)
width = maximum([length(l) for l in lines])

map = fill(' ', width, height)

function transpose(m::Matrix{Char})
    m2 = fill(' ', size(m)[2], size(m)[1])
    for i in 1:size(m)[2]
        for j in 1:size(m)[1]
            m2[i,j] = m[j,i]
        end
    end
    return(m2)
end

for (y, line) in enumerate(lines[1:end-2])
    global map
    for (x,c) in enumerate(line)
        map[x,y] = c
    end
end


function print_map(map, location = [-1,-1])
    for y in 1:height
        for x in 1:width
            if x == location[1] && y == location[2]
                print('X')
            else
                print(map[x,y])
            end
        end
        println()
    end
    println()
end

instructions = lines[end]
println(instructions)

function wrap_around(location, direction)
    new_location = copy(location)
    if new_location[1] < 1
        new_location[1] = width
    elseif new_location[1] > width
        new_location[1] = 1
    elseif new_location[2] < 1
        new_location[2] = height
    elseif new_location[2] > height
        new_location[2] = 1
    end
    while map[new_location...] == ' '
        new_location .+= direction
        if new_location[1] < 1
            new_location[1] = width
        elseif new_location[1] > width
            new_location[1] = 1
        elseif new_location[2] < 1
            new_location[2] = height
        elseif new_location[2] > height
            new_location[2] = 1
        end
    end
    return new_location
end


function step(location, heading, n, map)
    for s in 1:n
        new_location = copy(location)
        if heading == 'R'
            new_location[1] += 1
            if new_location[1] > width || map[new_location...] == ' '
                #println("Wrap")
                new_location = wrap_around(new_location, (1, 0))
            end
        elseif heading == 'L'
            new_location[1] -= 1
            if new_location[1] < 1 || map[new_location...] == ' '
                new_location = wrap_around(new_location, (-1, 0))
            end
        elseif heading == 'U'
            new_location[2] += 1
            if new_location[2] > height || map[new_location...] == ' '
                new_location = wrap_around(new_location, (0, 1))
            end
        elseif heading == 'D'
            new_location[2] -= 1
            if new_location[2] < 1 || map[new_location...] == ' '
                new_location = wrap_around(new_location, (0, -1))
            end
        end
        #println(heading, " ", new_location, " ", location)

        if map[new_location...] == '#'
            #println("back ", location)
            break
        end
        location = new_location
    end
    return location
end


location = [1,1]
for x in width:-1:1
    global location
    if map[x, 1] != ' '
        location[1] = x
    end
end
#println(location)
#print_map(map, location)

number = ""
heading = 1
headings = ['R','U','L','D']
for c in instructions
    global number, heading, headings, location
    if c == 'R'
        n = parse(Int, number)
        location = step(location, headings[heading], n, map)
        heading = mod(heading-1+4+1, 4) + 1
        number = ""
        #print_map(map, location)
    elseif c == 'L'
        n = parse(Int, number)
        location = step(location, headings[heading], n, map)
        heading = mod(heading-1+4-1, 4) + 1
        number = ""
        #print_map(map, location)
    else
        number *= c
    end
end

if number != ""
    n = parse(Int, number)
    location = step(location, headings[heading], n, map)
end

println(location, " ", heading)

println("password = ", 1000*location[2] + 4*location[1] + (heading-1))

