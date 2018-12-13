import sequtils, strutils, math, algorithm

let gridSerial = 7689
let gridSize = 300

proc powerForCell(x,y:int):int =
    let rackID = x + 10
    result = rackID * y
    result += gridSerial
    result *= rackID
    result = result div 100 - result div 1000 * 10
    result -= 5

# --- Calculate power for all cells and store in an integral map ---
# https://en.wikipedia.org/wiki/Summed-area_table

var grid = newSeqWith(gridSize+1, newSeq[int](gridSize+1))
for y in 1..<grid.len:
    for x in 1..<grid[y].len:
        var value = powerForCell(x,y) + grid[y][x-1] + grid[y-1][x] - grid[y-1][x-1]
        grid[y][x] = value

proc areaSum(g:seq[seq[int]],x,y,w,h:int):int=
    result = g[y][x] + g[y+h][x+w] - g[y+h][x] - g[y][x+w]
   
proc maxSquarePower(g:seq[seq[int]],size:int):tuple[x,y,power:int]=
    result = (0,0,int.low)
    for y in 0..<gridSize-size:
        for x in 0..<gridSize-size:
            var pow = g.areaSum(x,y,size,size)
            if pow > result.power:
                result = (1 + x, 1 + y, pow) # top is (1,1)

# --- Part 1 ---

var maxPower = grid.maxSquarePower(3)
echo "Part 1: ", maxPower.x,",",maxPower.y

# --- Part 2 ---

let maxTotalPower = toSeq(1..300).mapIt((it,grid.maxSquarePower(it))).sortedByIt(it[1].power)[^1]
echo "Part 2: ", maxTotalPower[1].x, ",", maxTotalPower[1].y, ",", maxTotalPower[0]