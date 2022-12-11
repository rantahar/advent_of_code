
lines = readlines("input")

c = 0     # cycle
x = 1     # register X
n = 0     # addition register
state = 0 # 0 = noop, 1 = processing addx

signal = fill(".", 240)

while length(lines) > 0 || state != 0
    global c, n, state, x, signal

    c = c+1
    x_position = mod(c,40)
    if x_position >= x && x_position < x+3
        signal[c] = "#"
    end

    if state == 0
        # read the next instruction
        line = popfirst!(lines)
        words = split(line, " ")
        #println(c+1, " ", words, " ", x)
        if words[1] == "noop"
            state = 0
        elseif words[1] == "addx"
            n = parse(Int, words[2])
            state = 1
        end
    elseif state == 1
        # process the addition
        x += n
        state = 0
    end
end

println()
for i in 1:6
    for j in 1:40
        print(signal[40*(i-1)+j])
    end
    println()
end


