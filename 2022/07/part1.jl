
directories = Dict()
current_path = ["/", "home", "myhome"]

for line in readlines("input")
    global directories, current_path
    words = split(line, " ")

    if words[1] == "\$"
        if words[2] == "cd"
            if words[3] == ".."
                current_path = current_path[1:end-1]
            elseif words[3] == "/"
                current_path = ["/"]
            else
                push!(current_path, words[3])
            end
        end
        continue
    end

    if words[1] != "dir"
        size = parse(Int, words[1])
        for dir in cumprod(current_path)
            if haskey(directories, dir)
                directories[dir] += size
            else
                directories[dir] = size
            end
        end
    end
end

total_size = 0
for (key, value) in directories
    global total_size
    # println(key, ": ", value)
    if value <= 100000
        total_size += value
    end
end

println("total size ", total_size)

