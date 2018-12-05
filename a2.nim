import strutils, sequtils, tables

var lines = readfile("2_input.txt").splitlines()

# Part 1
var twos, threes: Natural

for line in lines:
    var counter = toSeq(toCountTable(line).values)
    if 2 in counter: inc(twos)
    if 3 in counter: inc(threes)
    
echo "Checksum: ", twos * threes

# Part 2
var correctBox: string

for line1 in lines:
    for line2 in lines:
        let deduped = zip(line1, line2).filterIt(it.a == it.b)
        if line1.len - deduped.len == 1:
            correctBox = deduped.foldl(a & b.b, "")

echo "Correct box: ", correctBox