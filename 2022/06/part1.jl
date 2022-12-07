for line in readlines("input")
    for i in 1:length(line)-3
        section = line[i:i+3]
        if length(Set(section)) == 4
            println("match at ", i+3)
            break
        end
    end
end



