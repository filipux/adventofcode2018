import strutils,sequtils,strscans, algorithm, lists, tables, sets, math

type Point = tuple[x,y:int]
type Distances = seq[int]
type Grid = seq[seq[Distances]]

# --- Read and preprocess data ---

var points:seq[Point]

for line in lines("6_input.txt"):
    let p = line.split(", ").map(parseInt)
    points.add((p[0], p[1]))

# Create a grid with distances to every point
var grid = newSeqWith(points.mapIt(it.y).max + 1,
                newSeqWith(points.mapIt(it.x).max + 1,
                    newSeq[Distances](points.len).mapIt(high(int))))

for y in 0..<grid.len:
    for x in 0..<grid[y].len:
        for i, d in grid[y][x]:
            grid[y][x][i] = abs(points[i].x - x) + abs(points[i].y - y)

# --- Part 1 ---

proc createAreaGrid(g:var Grid, points:seq[Point]):seq[seq[int]]=
    result = newSeqWith(grid.len, newSeq[int](grid[0].len))
    for y in 0..<g.len:
        for x in 0..<g[y].len:
            let dist = g[y][x]
            let value = dist.min
            let pointType = dist.find(value)
            let closestPoint = if dist.count(value) == 1: pointType else: -1
            result[y][x] = closestPoint
            
var areaGrid = createAreaGrid(grid, points)

# Create set of all points at border as they extend to infinity
var infinites = initSet[int]()
infinites.incl(toSet(areaGrid[0]))                  # first row
infinites.incl(toSet(areaGrid[high(areaGrid)]))     # last row
infinites.incl(toSet(areaGrid.mapIt(it[0])))        # first col
infinites.incl(toSet(areaGrid.mapIt(it[high(it)]))) # last row

# Find total area of all point types excluding inifinite ones and get maximum
let largestArea = toSeq(toCountTable(areaGrid.concat).pairs)
                    .filterIt(not infinites.contains(it[0]))
                        .mapIt(it[1]).max()

echo "Part 1: ", largestArea

# --- Part 2 ---

var area = 0
for y in 0..<grid.len:
    for x in 0..<grid[y].len:
        if grid[y][x].sum < 10000:
            inc(area)

echo "Part 2: ", area