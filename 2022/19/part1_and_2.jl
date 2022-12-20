lines = readlines("input")


function run_path(robot_costs, max_cost, min_ore_cost, bots, materials, time)
    best_geodes = materials[end]
    should_not_build = fill(false, 4)
    for i in 1:3
        if bots[i] >= max_cost[i]
            should_not_build[i] = true
        end
    end
    for t in time:-1:1
        if materials[1] >= min_ore_cost
            for i in 4:-1:1
               if should_not_build[i]
                   continue
               end
               cost = robot_costs[i]
               if all(materials .>= cost)
                   new_materials = materials .- cost .+ bots
                   bots[i] += 1
                   geodes = run_path(
                      robot_costs, max_cost, min_ore_cost,
                      bots, new_materials, t-1
                   )
                   bots[i] -= 1
                   best_geodes = max(best_geodes, geodes)
                   should_not_build[i] = true
               end
           end
        end
        materials = materials .+ bots
    end
    return max(best_geodes, materials[end])
end

sum = 0
for line in lines
    global sum
    words = split(line, " ")
    id = parse(Int, words[2][1:end-1])
    blueprint = [words[w] for w in [7,13,19,22,28,31]]
    blueprint = [parse(Int, w) for w in blueprint]

    robot_costs = [
        (blueprint[1], 0, 0, 0),
        (blueprint[2], 0, 0, 0),
        (blueprint[3], blueprint[4], 0, 0),
        (blueprint[5], 0, blueprint[6], 0)
    ]

    materials = [0, 0, 0, 0]
    bots = [1, 0, 0, 0]

    max_cost = [maximum([c[i] for c in robot_costs]) for i in 1:4]
    min_ore_cost = minimum([c[1] for c in robot_costs])
    geodes = run_path(robot_costs, max_cost, min_ore_cost, bots, materials, 24)
    println("geodes: ", geodes)
    sum += geodes * id
end

println("quality sum: ", sum)


product = 1
for i in 1:3
    global product
    words = split(lines[i], " ")
    blueprint = [words[w] for w in [7,13,19,22,28,31]]
    blueprint = [parse(Int, w) for w in blueprint]

    robot_costs = [
        (blueprint[1], 0, 0, 0),
        (blueprint[2], 0, 0, 0),
        (blueprint[3], blueprint[4], 0, 0),
        (blueprint[5], 0, blueprint[6], 0)
    ]

    materials = [0, 0, 0, 0]
    bots = [1, 0, 0, 0]

    max_cost = [maximum([c[i] for c in robot_costs]) for i in 1:4]
    min_ore_cost = minimum([c[1] for c in robot_costs])
    geodes = run_path(robot_costs, max_cost, min_ore_cost, bots, materials, 32)
    println("geodes: ", geodes)
    product *= geodes
end

println("product: ", product)
