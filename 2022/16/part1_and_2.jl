using Combinatorics

lines = readlines("input")

N_rooms = length(lines)

room_numbers = Dict()
room_names = fill("", N_rooms)
timings = fill(1000, (N_rooms, N_rooms))
rates = fill(0, N_rooms)

# Read room labels, keeping "AA" as 1
room = 2
for line in lines
    global room
    words = split(line, " ")
    room_label = words[2]
    if room_label == "AA"
        room_numbers[room_label] = 1
        room_names[1] = "AA"
    else
        room_numbers[room_label] = room
        room_names[room] = room_label
        room += 1
    end
end

# Read flow rates and routes
for line in lines
    global rates, timings
    local room
    words = split(line, " ")
    room_label = words[2]
    room = room_numbers[room_label]

    rate = split(words[5], "=")[2]
    rate = parse(Int, rate[1:end-1])
    rates[room] = rate

    routes = words[10:end]
    routes = replace.(routes, "," => "")
    for route in routes
        route = room_numbers[route]
        timings[room, route] = 1
    end
end


# Find all to all timings
for k in 1:N_rooms
    for i in 1:N_rooms
        for j in 1:N_rooms
            timings[i,j] = min(timings[i,j], timings[i,k] + timings[k,j])
        end
    end
end

# Drop rooms with rate 0 except for room "AA"
i=2
while i < length(rates)
    global i, timings, rates
    if rates[i] == 0
        deleteat!(rates, i)
        deleteat!(room_names, i)
        timings = timings[1:end .!= i, 1:end .!= i]
    else
        i += 1
    end
end

#################
# part 1


# Just a depth first search
function find_path(position, closed_valves, start_time)
    max_score = 0
    best_path = []
    if length(closed_valves) == 0
        return [], 0
    end
    for valve in closed_valves
        time = start_time - timings[position, valve] - 1
        if time < 0
            continue
        end
        score = rates[valve]*time
        still_closed = setdiff(closed_valves, Set([valve]))
        path, path_score = find_path(valve, still_closed, time)
        score += path_score
        if score > max_score
            max_score = score
            best_path = prepend!(path, [(room_names[valve], time, rates[valve])])
        end
    end
    return best_path, max_score
end

path, score = find_path(1, Set(2:length(rates)), 30)
println(path)
println("score: ", score)

#################
# part 2

# In part 1 I could get 7 out of 16 valves. With help, we migth get
# all of them. So try splitting the 16 evenly, in any comibation.
valves = 2:length(rates)
best_score = 0
for n_comb in length(valves)÷2:length(valves)÷2+1
    global best_score
    combs = [c for c in combinations(valves, n_comb)]
    for i in 1:length(combs)
        local score, path
        my_valves = combs[i]
        if mod(i,100) == 0
            println((100*i)÷length(combs), "%")
        end
        #println(my_valves)
        their_valves = setdiff(valves, Set(my_valves))
        #println(their_valves)
        #println()
        path, score1 = find_path(1, Set(my_valves), 26)
        path, score2 = find_path(1, their_valves, 26)
        score = score1 + score2
        if score > best_score
            best_score = score
        end
    end
end

println("score with help: ", best_score)
