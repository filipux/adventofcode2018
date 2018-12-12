import strutils, sequtils, strscans, re

type Star = ref object
    pos:tuple[x,y:int]
    vel:tuple[dx,dy:int]

proc newStar(data:seq[int]):Star =
    result = new(Star)
    result.pos = (data[0], data[1])
    result.vel = (data[2], data[3])

# --- Read and preprocess data ---

var stars:seq[Star]
let data = toSeq(lines("10_input.txt")).mapIt(toSeq(it.findAll(re"(-)?\d+")).map(parseInt))
stars = data.mapIt(newStar(it))

# --- Part 1 and Part 2 ---

proc totalArea(s:seq[Star]):int=
    let rx = s.mapIt(it.pos.x)
    let ry = s.mapIt(it.pos.y)
    result = (rx.max-rx.min) * (ry.max-ry.min)

proc tick()=
    for star in stars:
        star.pos.x += star.vel.dx
        star.pos.y += star.vel.dy

proc tock()=
    for star in stars:
        star.pos.x -= star.vel.dx
        star.pos.y -= star.vel.dy

proc `$`(s:seq[Star]):string =
    var grid = newSeq[string]();
    let minx = stars.mapIt(it.pos.x).min
    let miny = stars.mapIt(it.pos.y).min
    let maxx = stars.mapIt(it.pos.x).max
    let maxy = stars.mapIt(it.pos.y).max
    grid.add(" ".repeat(maxx-minx+1))
    for i in 1..(maxy-miny):
        grid.add(grid[0])
    for star in s:
        grid[star.pos.y-miny][star.pos.x-minx] = '#'
    result = grid.join("\n")

var seconds =0
var area = int.high

while true:
    let newArea = stars.totalArea
    if newArea > area:
        tock()
        dec(seconds)
        break
    tick()
    inc(seconds)
    area = newArea

echo "Part 1: \n", stars
echo "Part 2: ", seconds
