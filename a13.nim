import sequtils, strutils, tables, lists, sets, algorithm, sugar

type
    Direction = enum
        Up = (0, "^")
        Left = (1, "<")
        Down = (2, "v")
        Right = (3, ">")
    Map = seq[string]
    Position = tuple[x,y:int]
    Cart = ref object
        dir:Direction
        pos:Position
        intersectCount:int
        crashed:bool

proc `$`(cart:Cart):string =
    "dir: " & $(cart.dir) & ", pos: " & $cart.pos & ", crashed: " & $cart.crashed

proc turnLeft(cart:var Cart) =
    cart.dir = Direction(if cart.dir.int == 3: 0 else: cart.dir.int+1)

proc turnRight(cart:var Cart) =
    cart.dir = Direction(if cart.dir.int == 0: 3 else: cart.dir.int-1)

proc newCart(dir:Direction, pos:Position):Cart =
    result = new(Cart)
    result.dir = dir
    result.pos = pos

proc `+`(a,b:Position):Position = (a.x + b.x, a.y + b.y)
proc `[]`(map:var Map, pos:Position):char = map[pos.y][pos.x]

# Read data
var moves = {Up:(0,-1), Left:(-1,0), Down:(0,1), Right:(1,0)}.toOrderedTable
var carts:seq[Cart]
var crashedCarts:seq[Cart]
var map:Map = toSeq(lines("13_input.txt"))

# Extract carts
for y in 0..<map.len:
    for x in 0..<map[y].len:
        let obama = {'v':'|', '^':'|', '>':'-', '<':'-'}.toTable()
        let value = map[y][x]
        if value in obama:
            let dir = parseEnum[Direction]($value)
            carts.add(newCart(dir,(x,y)))
            map[y][x] = obama[value]

iterator step():Cart=
    var sortedCarts = carts.sorted((a,b) => cmp(a.pos.y*map[0].len+a.pos.x,b.pos.y*map[0].len+b.pos.x))

    for cart in sortedCarts.mitems:
        if cart.crashed: continue

        # Move
        cart.pos = cart.pos + moves[cart.dir]

        # Handle turns and intersections
        case map[cart.pos]:
            of '\\':
                if cart.dir in [Up, Down]:
                    cart.turnLeft
                else:
                    cart.turnRight
            of '/':
                if cart.dir in [Up, Down]:
                    cart.turnRight
                else:
                    cart.turnLeft
            of '+':
                case cart.intersectCount:
                    of 0: cart.turnLeft
                    of 1: discard
                    of 2: cart.turnRight
                    else: discard
                cart.intersectCount = (cart.intersectCount + 1) mod 3
            else: discard

        # Handle crashes
        let crashes = carts.filterIt(not it.crashed).filterIt(it.pos == cart.pos)
        if crashes.len > 1:
            for crash in crashes:
                crash.crashed = true
                yield crash

var crashCount:int
var foundPart1:bool
while carts.len-crashCount > 1:
    for crashedCart in step():
        if not foundPart1:
            echo "Part 1: ", crashedCart.pos.x, ",", crashedCart.pos.y
            foundPart1 = true    
        inc(crashCount)

let surviver = carts.filterIt(not it.crashed)[0]
echo "Part 2: ", surviver.pos.x, ",", surviver.pos.y