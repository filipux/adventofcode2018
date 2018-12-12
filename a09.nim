import strutils, sequtils, lists, re

# --- Functions missing from standard library ---

proc append*[T](a,b: DoublyLinkedNode[T]) =
    a.next.prev = b
    b.next = a.next
    a.next = b
    b.prev = a

proc append*[T](a:DoublyLinkedNode[T], value:T) =
    append(a, newDoublyLinkedNode(value))

# --- Read data ---

let data = readFile("9_input.txt").strip().findAll(re"\d+").map(parseInt)
let numberOfPlayers = data[0]
let lastMarbleValue = data[1]

# --- Part 1 ---
proc play(numberOfRounds:int):int=
    var points = newSeq[int](numberOfPlayers)
    var currentPlayer = 0

    var ring = DoublyLinkedRing[int]()
    ring.append(0)

    for i in 1..numberOfRounds:
        if i mod 23 == 0:
            points[currentPlayer] += i
            let marbleToRemove = ring.head.prev.prev.prev.prev.prev.prev.prev
            ring.head = marbleToRemove.next
            points[currentPlayer] += marbleToRemove.value
            ring.remove(marbleToRemove)
        else:
            var m = newDoublyLinkedNode(i)
            ring.head.next.append(m)
            ring.head = m

        inc(currentPlayer)
        if currentPlayer >= points.len: currentPlayer = 0
    
    result = points.max

echo "Part 1: ", play(lastMarbleValue)

# --- Part 2 ---

echo "Part 2: ", play(lastMarbleValue * 100)
