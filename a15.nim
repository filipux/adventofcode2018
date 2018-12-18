import sequtils, strutils, heapqueue, sugar, algorithm, math, lists

type Position = tuple[x,y:int]

# --- Unit ---

type Unit = ref object of RootObj
        pos:Position
        hitPoints:int
        attackPower:int
        value:char

# --- Node ---

type Node = ref object
        value:char
        dist:int
        neighbours:seq[Node]
        pos:Position

proc addNeighbour(a,b:Node) =
    a.neighbours.add(b)
    b.neighbours.add(a)

proc readingOrder(a,b:Node|Unit):int =
    result = cmp(a.pos.y, b.pos.y)
    if result == 0: result = cmp(a.pos.x, b.pos.x)
    
# Needed for HeapQueue
proc `<`(a,b:Node):bool = a.dist < b.dist

# --- DistanceMap ---

type DistanceMap = seq[seq[Node]]

proc `[]`(self:DistanceMap, pos:Position):Node = self[pos.y][pos.x]
proc `[]`(self:DistanceMap, unit:Unit):Node = self[unit.pos.y][unit.pos.x]

proc init(map:seq[string]): DistanceMap =
    result = newSeqWith(map.len, newSeq[Node](map[0].len))
    
    # Create nodes
    for y in 0..<map.len:
        for x in 0..<map[y].len:
            result[y][x] = Node(value: map[y][x], pos: (x,y), dist: int.high)

    # Connect neighbours
    for y in 0..<map.len-1:
        for x in 0..<map[y].len-1:
            addNeighbour(result[y][x], result[y][x+1])
            addNeighbour(result[y][x], result[y+1][x])

proc newDistanceMap(map:seq[string], start:Position):DistanceMap =
    result = init(map)
            
    # Djikstra
    var q = newHeapQueue[Node]()
    result[start].dist = 0
    q.push(result[start])
    while q.len > 0:
        let curr = q.pop()
        for n in curr.neighbours:
            if n.dist > curr.dist + 1 and n.value != '#':
                n.dist = curr.dist + 1
                if n.value == '.':
                    q.push(n)

# --- Map ---

type Map = seq[string]   

template `[]=`(self:Map, pos:Position, c:char) = self[pos.y][pos.x] = c

iterator squares(self:Map):tuple[value:char, pos:Position] =
    for y in 0..<self.len:
        for x in 0..<self[y].len:
            yield (self[y][x], (x,y))
    
# --- Part 1 ---

proc play(filename:string, elfAttackPower:int = 3):tuple[rounds, remains:int, winners:char, killedElves:int] =
    var units : seq[Unit]

    # Load map
    var map = toSeq(lines(filename))

    for square in map.squares:
        if square.value == 'E':
            units.add(Unit(hitPoints:200, attackPower: elfAttackPower, value: square.value, pos: square.pos))
        elif square.value == 'G':
            units.add(Unit(hitPoints:200, attackPower: 3, value: square.value, pos: square.pos))

    var rounds = 0
    var done = false
    while not done:
 
        for unit in units.sorted(readingOrder):
            if unit.hitPoints <= 0: continue

            # Map of distances to current unit
            var dist = newDistanceMap(map, unit.pos)
            
            # Get list of all enemies that are still alive
            var enemyValue = if unit.value == 'E': 'G' else:'E'
            let enemies = units.filterIt(it.value == enemyValue).filterIt(it.hitPoints > 0)
            
            # No enemies left? Game over.
            if enemies.len == 0:
                done = true
                break
                
            # < MOVE >

            let shouldMove = enemies.filterIt(dist[it].dist == 1).len == 0
            if shouldMove:
                # 1. Get all empty squares next to all enemies
                let inRangeSquares = enemies.mapIt(dist[it].neighbours).concat.filterIt(it.value == '.')
                
                # 1. Filter out those which are unreachable
                let reachableSquares = inRangeSquares.filterIt(it.dist < int.high)
                if reachableSquares.len > 0:
                    
                    # 3. Get the closest squares
                    let minDist = reachableSquares.mapIt(it.dist).min
                    let nearestSquares = reachableSquares.filterIt(it.dist == minDist)
                    if(nearestSquares.len > 0):
                        
                        # 4. Sort by reading order and choose the first one
                        let choosenSquare = nearestSquares.sorted(readingOrder)[0]

                        # 5. Turn it all around. Get all paths to choosen square and see which neighbour is closest
                        let dist2 = newDistanceMap(map, choosenSquare.pos)
                        let unitNeighbourNodes = dist2[unit].neighbours.filterIt(it.value == '.')
                        let minDist = unitNeighbourNodes.mapIt(it.dist).min
                        let nearestPaths = unitNeighbourNodes.filterIt(it.dist == minDist)
                        let moveToPos = nearestPaths.sorted(readingOrder)[0].pos
                        
                        # Make the move
                        map[unit.pos] = '.'
                        unit.pos = moveToPos
                        map[unit.pos] = unit.value
                        dist = newDistanceMap(map, unit.pos)

            # < ATTACK >
            var toAttack = enemies.filterIt(dist[it].dist == 1)

            if toAttack.len > 0:
                let minHitPoints = toAttack.mapIt(it.hitPoints).min
                let targets = toAttack.filterIt(it.hitPoints == minHitPoints).sorted(readingOrder)
                let target = targets[0]
                
                target.hitPoints -= unit.attackPower
                if target.hitPoints <= 0:
                    map[target.pos] = '.'

        if not done:
            inc(rounds)

    # Finish up
    let remains = units.filterIt(it.hitPoints > 0).mapIt(it.hitPoints).sum
    let killedElves = units.filterIt(it.value == 'E' and it.hitPoints <= 0).len
    let winners = units.filterIt(it.hitPoints > 0)[0].value
    result = (rounds, remains, winners, killedElves)

# --- Part 1 ---

let outcome = play("15_input.txt")
echo "Part 1: ", outcome.rounds * outcome.remains

# --- Part 2 ---

var power = 4
var done = false
var outcomePart2:tuple[rounds, remains:int, winners:char, killedElves:int]
while not done:
    inc(power)
    outcomePart2 = play("15_input.txt", power)
    done = outcomePart2.winners == 'E' and outcomePart2.killedElves == 0

echo "Part 2: ", outcomePart2.rounds * outcomePart2.remains