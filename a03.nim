import strutils, sequtils, tables, hashes, sugar
import nre except toSeq

type Patch = tuple[x, y: int]

iterator patches(claim: seq[int]): Patch =
    for i in claim[1]..<(claim[1] + claim[3]):
        for j in claim[2]..<(claim[2] + claim[4]):
            yield (i,j)

var fabric = newCountTable[Patch]()
var claims = toSeq(lines("3_input.txt"))
            .mapIt(it.findAll(re"\d+")
            .map(parseInt))

#Part 1
for claim in claims:
    for patch in claim.patches:
        fabric.inc(patch)

let overlapCount = toSeq(fabric.values).filterIt(it > 1).len
echo "Overlaps: ",overlapCount

#Part 2
for claim in claims:
    if toSeq(claim.patches).allIt(fabric[it] == 1):
        echo "No overlaps on ID: ", claim[0]
