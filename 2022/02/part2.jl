
using Formatting

rounds = readlines("input")

score = 0
choices = Dict("A"=> 1, "B"=> 2, "C"=> 3, "X"=> 1, "Y"=> 2, "Z"=> 3)
match_scores = [0 3 6]
fixed_choices = [3 1 2 ; 1 2 3 ; 2 3 1]

for round in rounds
    global score
    (elf, result) = split(round)
    elf = choices[elf]
    result = choices[result]
    me = fixed_choices[elf, result]
    round_score = me + match_scores[result]
    score += round_score
    println(score, " ", round_score, " ", elf, " ", me)
end


printfmt("score: {:d}\n", score)

