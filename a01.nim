import strutils, sequtils, sets, math, itertools

var freq = 0
var freqHash = initSet[int]()

# Part 1
var numbers = toSeq("1_input.txt".lines).map(parseInt)
echo "Total frequency: ", numbers.sum

# Part 2
for n in numbers.cycle():
    freq += n
    if freqHash.containsOrIncl(freq): break
    
echo "First repeated frequency: ", freq
