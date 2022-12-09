
lines = readlines("input")

head = [1,1]
tail = [1,1]
touched = Set([tuple(1,1)])

otherdir = [2,1]

for line in lines
    dir_label, num = split(line, " ")
    num = parse(Int, num)
    if dir_label == "R"
        dir = 1
        sign = 1
    end
    if dir_label == "L"
        dir = 1
        sign = -1
    end
    if dir_label == "U"
        dir = 2
        sign = 1
    end
    if dir_label == "D"
        dir = 2
        sign = -1
    end
    for step in 1:num
        head[dir] += sign
        for d in 1:2
           if tail[d] + 1 < head[d]
               tail[d] += 1
               if tail[otherdir[d]] > head[otherdir[d]]
                   tail[otherdir[d]] -= 1
               elseif tail[otherdir[d]] < head[otherdir[d]]
                       tail[otherdir[d]] += 1
               end
               break
           elseif tail[d] - 1 > head[d]
               tail[d] -= 1
               if tail[otherdir[d]] > head[otherdir[d]]
                   tail[otherdir[d]] -= 1
               elseif tail[otherdir[d]] < head[otherdir[d]]
                       tail[otherdir[d]] += 1
               end
               break
           end
        end
        push!(touched, tuple(tail...))
    end
end

println("Squares touched: ", length(touched))
