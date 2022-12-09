
lines = readlines("input")
rope_length = 10

knots = []
for k in 1:rope_length
    push!(knots, [1,1])
end
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
        knots[1][dir] += sign
        for k in 2:length(knots)
            for d in 1:2
               if knots[k][d] + 1 < knots[k-1][d]
                   knots[k][d] += 1
                   if knots[k][otherdir[d]] > knots[k-1][otherdir[d]]
                       knots[k][otherdir[d]] -= 1
                   elseif knots[k][otherdir[d]] < knots[k-1][otherdir[d]]
                           knots[k][otherdir[d]] += 1
                   end
                   break
               elseif knots[k][d] - 1 > knots[k-1][d]
                   knots[k][d] -= 1
                   if knots[k][otherdir[d]] > knots[k-1][otherdir[d]]
                       knots[k][otherdir[d]] -= 1
                   elseif knots[k][otherdir[d]] < knots[k-1][otherdir[d]]
                           knots[k][otherdir[d]] += 1
                   end
                   break
               end
            end
        end
        push!(touched, tuple(knots[end]...))

    end
end

println("Squares touched: ", length(touched))
