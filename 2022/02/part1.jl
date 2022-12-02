
using Formatting

rounds = readlines("input")

score = 0
choice_scores = Dict("A"=> 1, "B"=> 2, "C"=> 3, "X"=> 1, "Y"=> 2, "Z"=> 3)
match_scores = [3 6 0 ; 0 3 6 ; 6 0 3]

for round in rounds
    global score
    (elf, me) = split(round)
    elf = choice_scores[elf]
    me = choice_scores[me]
    round_score = me + match_scores[elf, me]
    score += round_score
    println(score, " ", round_score, " ", elf, " ", me)
end


printfmt("score: {:d}\n", score)

