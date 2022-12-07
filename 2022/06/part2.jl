for line in readlines("input")
    for i in 1:length(line)-13
        section = line[i:i+13]
        if length(Set(section)) == 14
            println("match at ", i+13)
            break
        end
    end
end