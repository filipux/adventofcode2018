import sequtils, strutils, tables, queues, math

type Map = seq[string]

proc `$`(map:Map):string = map.join("\n")

proc neighbours(data:Map,x,y:int):seq[char] =
    result = newSeqOfCap[char](8)
    for j in max(0,y-1)..min(data.len-1, y+1):
        for i in max(0,x-1)..min(data[j].len-1,x+1):
            if not (j == y and i == x):
                result.add(data[j][i])

proc tick(data:var seq[string]) =
    var newData = data
    for y in 0..<data.len:
        for x in 0..<data[y].len:
            let counts = toCountTable(data.neighbours(x,y))
            case data[y][x]:
                of '.':
                    if counts.getOrDefault('|') >= 3:
                        newData[y][x] = '|'
                of '|':
                    if counts.getOrDefault('#') >= 3:
                        newData[y][x] = '#'        
                of '#':
                    if counts.getOrDefault('#') == 0 or counts.getOrDefault('|') == 0:
                        newData[y][x] = '.'   
                else: discard
    data = newData

# --- Part 1 ---

var data = toSeq(lines("18_input.txt"))

for i in 1..10:
    tick(data)
let wood = toCountTable(data.join)['|']
let yard = toCountTable(data.join)['#']
echo "Part 1: ", wood * yard


# --- Part 2 ---

var q = initTable[seq[int], int]()
var s:seq[int]

data = toSeq(lines("18_input.txt"))
let max = 1000000000
for i in 1..max:
    tick(data)
    let wood = toCountTable(data.join)['|']
    let yard = toCountTable(data.join)['#']
    let horseRadish = wood*yard
    s.add(horseRadish)
    if s.len > 100:
        s.delete(0)
        if q.hasKey(s): # oh lawd this is nasty
            var phase = i-q[s]
            let mult = floor((max-i)/phase).int
            var j = i + phase * mult
            for r in j..<max:
                tick(data)
            let wood = toCountTable(data.join)['|']
            let yard = toCountTable(data.join)['#']
            echo "Part 2: ", wood * yard
            break
        else:
            q[s] = i