lines = readlines("input")
test_y = 2000000
min_c = 0
max_c = 4000000

boundaries = [0,0,0,0]

sensors = []

for line in lines
    words = split(line, r"[ ]")
    sensor_x = parse(Int, words[3][3:end-1])
    sensor_y = parse(Int, words[4][3:end-1])
    beacon_x = parse(Int, words[9][3:end-1])
    beacon_y = parse(Int, words[10][3:end])
    distance = abs(sensor_x - beacon_x) + abs(sensor_y - beacon_y)
    append!(sensors, [(sensor_x, sensor_y, distance)])
end


function reduce_ranges(ranges)
    changed = false
    i = 1
    while i <= length(ranges)
        i_changed = false
        for j in 1:length(ranges)
            if i != j
                if ranges[j][1]-1 <= ranges[i][1] <= ranges[j][2]+1
                    if ranges[i][2] > ranges[j][2]
                        ranges[j][2] = ranges[i][2]
                    end
                    i_changed = true
                end
                if ranges[j][1]-1 <= ranges[i][2] <= ranges[j][2]+1
                    if ranges[i][1] < ranges[j][1]
                        ranges[j][1] = ranges[i][1]
                    end
                    i_changed = true
                end
            end
        end
        if i_changed
            deleteat!(ranges, i)
            changed = true
        else
            i += 1
        end
    end
    return changed
end

function find_ranges(sensors, test_y)
    ranges = []
    for sensor in sensors
        row_dist = sensor[3] - abs(test_y - sensor[2])
        if row_dist > 0
            first = sensor[1] - row_dist
            last = sensor[1] + row_dist
            append!(ranges, [[first, last]])
            changed = true
            while changed
                changed = reduce_ranges(ranges)
            end
        end
    end
    return ranges
end

ranges = find_ranges(sensors, test_y)

len = 0
for range in ranges
    global len
    len += range[2] - range[1]
end

println("Blocked cols on line ", test_y, ": ", len)


for y in min_c:max_c
    local ranges
    if mod(y,40000)==0
        println(Int(100*y/max_c),"%")
    end
    ranges = find_ranges(sensors, y)
    for range in ranges
        if range[1] < min_c && range[2] < max_c
            println("Free point at ", (range[2]+1, y))
            println("score ", (range[2]+1)*4000000 + y)
        end
    end
end



