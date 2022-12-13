lines = readlines("input")


function parselist(str)
    list = []
    current = list
    queue = [current]
    #skip first '['
    str = str[2:end]
    while length(str) > 0
        if str[1] == '['
            next = []
            append!(current, [next])
            append!(queue, [current])
            current = next
        elseif str[1] == ']'
            current = pop!(queue)
        elseif str[1] != ','
            number = split(str, r"[,\]\[]")[1]
            str = str[length(number):end]
            number = parse(Int, number)
            append!(current, [number])
        end
        str = str[2:end]
    end
    return list
end

function compare(original1, original2)
    list1 = copy(original1)
    list2 = copy(original2)
    while length(list1) > 0 && length(list2) > 0
        item1 = popfirst!(list1)
        item2 = popfirst!(list2)
        if typeof(item1) == Int && typeof(item2) == Int
            if item1 > item2
                result = "larger"
            elseif item2 > item1
                result = "smaller"
            else
                result = "equal"
            end
        elseif typeof(item1) == Int && typeof(item2) == Vector{Any}
            result = compare(Vector{Any}([item1]), item2)
        elseif typeof(item1) == Vector{Any} && typeof(item2) == Int
            result = compare(item1, Vector{Any}([item2]))
        elseif typeof(item1) == Vector{Any} && typeof(item2) == Vector{Any}
            result = compare(item1, item2)
        else
            throw("Well this is weird!")
        end
        if result != "equal"
            return result
        end
    end

    if length(list1) == 0 && length(list2) == 0
        return "equal"
    elseif length(list1) == 0
        return "smaller"
    else
        return "larger"
    end
end

function isless(list1, list2)
    comparison = compare(list1, list2)
    if comparison == "smaller"
        return true
    else
        return false
    end
end

sum = 0
packets = []
for (i, pairs) in enumerate(Iterators.partition(lines, 3))
    global sum
    # Note: a pair contains a third, empty line
    list1 = pairs[1]
    list2 = pairs[2]

    list1 = parselist(list1)
    list2 = parselist(list2)
    append!(packets, [list1, list2])

    if compare(list1, list2) == "smaller"
        sum += i
    end
end

println("Sum of indices = ", sum)


append!(packets, parselist("[[2]]"), parselist("[[6]]"))
sort!(packets, lt=isless)

decoder = 1
for (i, packet) in enumerate(packets)
    global decoder
    if compare(packet, parselist("[[2]]")) == "equal"
        decoder *= i
    elseif compare(packet, parselist("[[6]]")) == "equal"
        decoder *= i
    end
end

println("Decoder = ", decoder)



