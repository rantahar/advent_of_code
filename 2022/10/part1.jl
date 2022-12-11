
lines = readlines("input")

c = 0     # cycle
x = 1     # register X
n = 0     # addition register
state = 0 # 0 = noop, 1 = processing addx

signal = 0

while length(lines) > 0 || state != 0
    global c, n, state, x, signal

    c = c+1
    if mod(c-20, 40) == 0
        println(c, " ", x, " ", c*x)
        signal += c*x
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

println("signal = ", signal)

