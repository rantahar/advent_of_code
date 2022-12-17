lines = readlines("input")

shapes = [
    [1 1 1 1;],
    [0 1 0 ; 1 1 1 ; 0 1 0],
    [1 1 1 ; 0 0 1 ; 0 0 1],
    reshape([1 ; 1 ; 1 ; 1], :, 1), # force this to be 2D
    [1 1 ; 1 1]
]

wind_pattern = lines[1]
wind_pattern = [w=='<' ? -1 : 1 for w in wind_pattern]

println(length(wind_pattern))

function print_pattern(pattern, shape, x, y)
    pattern = copy(pattern)
    for i in 1:size(shape)[1]
        for j in 1:size(shape)[2]
            if shape[i, j] == 1
                pattern[y+i-1, x+j-1] = 2
            end
        end
    end
    for i in 1:size(pattern)[1]
        print("|")
        for j in 1:size(pattern)[2]
            if pattern[size(pattern)[1]+1-i, j] == 1
                print("#")
            elseif pattern[size(pattern)[1]+1-i, j] == 2
                print("@")
            else
                print(".")
            end
        end
        println("|")
    end
    println()
end


function run(N, find_period = false)
    global shapes, wind_pattern
    rock_pattern = [1 1 1 1 1 1 1 ; 0 0 0 0 0 0 0 ; 0 0 0 0 0 0 0 ; 0 0 0 0 0 0 0]
    rock_pattern = transpose(rock_pattern)
    height = 1
    previous_height = 0
    wind = 0
    if find_period
        after_first_cycle = fill(0, (7, 50))
    end
    for s in 0:N-1
        x = 3
        y = height + 4
        shape = shapes[mod(s,length(shapes))+1]
        if y + size(shape)[1] > size(rock_pattern)[2]
            rock_pattern = hcat(rock_pattern, fill(0, size(rock_pattern)))
        end
        #print_pattern(rock_pattern, shape, x, y)
        while true
            w = wind_pattern[mod(wind, length(wind_pattern))+1]
            wind += 1
            if 0 < x+w && x+w+size(shape)[2]-1 < 8
                can_move = true
                for xs in 1:size(shape)[2]
                    for ys in 1:size(shape)[1]
                        if shape[ys, xs] == 1 && rock_pattern[x+w+xs-1, y+ys-1] == 1
                            can_move = false
                            break
                        end
                    end
                    if can_move == false
                        break
                    end
                end
                if can_move
                    x += w
                end
            end
            #print_pattern(rock_pattern, shape, x, y)
            touches = false
            for xs in 1:size(shape)[2]
                for ys in 1:size(shape)[1]
                    if shape[ys, xs] == 1 && rock_pattern[x+xs-1, y+ys-2] == 1
                        touches = true
                        break
                    end
                end
                if touches
                    break
                end
            end
            if touches
                for ys in 1:size(shape)[1]
                    for xs in 1:size(shape)[2]
                        if shape[ys, xs] == 1
                            rock_pattern[x+xs-1, y+ys-1] = 1
                        end
                    end
                end
                height = max(height, y + size(shape)[1] - 1)
                break
            else
                y -= 1
                #print_pattern(rock_pattern, shape, x, y)
            end
        end

        if find_period && mod(s, length(wind_pattern)*5) == 0
            if s == length(wind_pattern)*5
                after_first_cycle = copy(rock_pattern[:, height-50:height])
                previous_height = height
            elseif s > 0
                println("cycle ", s÷(length(wind_pattern)*5))
                if rock_pattern[:, height-50:height] == after_first_cycle
                    # pattern found
                    println("pattern_found at ", s, " height = ", height-1, ", diff = ", height-previous_height)
                    println("steps in cycle:", s-length(wind_pattern)*5)
                    return s-length(wind_pattern)*5, height-previous_height
                end
            end
        end
    end
    if find_period
        return height-1, 0
    else
        return height-1
    end
end

height = run(2022)
println("height after 2022 steps: ", height) # Account for the floor with the -1

# Test the simulation for periodicity
input_period = 5*length(wind_pattern)
(steps_per_cycle, cycle_height) = run(1000000000000, true)

if cycle_height == 0
    # no period
    println("height after 1000000000000 steps: ", steps_per_cycle)

else

    # Use the periodicity to remove intermediate simulation steps
    cycles = 1000000000000÷steps_per_cycle
    remainder = mod(1000000000000-input_period, steps_per_cycle)
    height = cycles*cycle_height + run(input_period+remainder)


    println("height after 1000000000000 steps: ", height) # Account for the floor with the -1
end
