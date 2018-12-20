import sequtils, strutils, strscans, re, math

type Position = tuple[x,y:int]
type Map = seq[string]

# --- Load map ---

proc parseMap(data:seq[string]): Map =
    var clay = newSeq[Position]()
    
    for line in data:
        let m = line.findAll(re"\d+").map(parseInt)
        clay = clay.concat(toSeq(m[1]..m[2]).mapIt(if line[0] == 'y':(it,m[0]) else: (m[0],it)))

    var dx = clay.mapIt(it.x).min - 1
    var width = clay.mapIt(it.x).max - dx + 2
    var height = clay.mapIt(it.y).max + 2

    result = newSeqWith(height, '.'.repeat(width))
    for c in clay: result[c.y][c.x-dx] = '#'
    result[0][500-dx] = '+'
    result[1][500-dx] = '|'
    
var map = parseMap(toSeq(lines("17_input.txt")))

# --- Simulation ---

var y = 1

proc tick() =
    var nextY = true
    for x in 0..<map[y].len:
        if map[y][x] == '|' and y < map.len-2:
            if map[y+1][x] in ['.', '|']:
                map[y+1][x] = '|'
            else:
                if map[y][x-1] == '.':
                    map[y][x-1] = '|'
                    nextY = false
                if map[y][x+1] == '.':
                    map[y][x+1] = '|'
                    nextY = false
    
    let b = map[y].findBounds(re"#\|+#")
    if b[0] >= 0 and map[y+1][b[0]+1..<b[1]].allIt(it in ['#','~']):
        map[y][b[0]+1..<b[1]] = '~'.repeat(b[1]-b[0]-1)
        dec(y)
    elif nextY: inc(y)

# --- Part 1 and 2---

while y < map.len-2:
    tick() # Run simulation

for y in 0..<map.len:
    if map[y].contains('#'):
        let total = map[y..<map.len].join()
        let drops = total.filterIt(it in ['|']).len
        let still = total.filterIt(it in ['~']).len
        echo "Part 1: ", drops + still
        echo "Part 2: ", still
        break