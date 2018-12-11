import strutils, sequtils, strscans, sugar, algorithm, tables

# --- Node class ---

type GenericNode[T] = ref object
    value:T
    parents: seq[GenericNode[T]]
    children: seq[GenericNode[T]]

proc newNode[T](value:T):GenericNode[T]=
    result = new(GenericNode[T])
    result.value = value

# --- Graph class ---

type Node = GenericNode[char]
type Graph = seq[Node]

proc getOrAdd(g:var Graph, value:char):Node =
    let gf = g.filterIt(it.value == value)
    if gf.len == 0:
        result = newNode(value)
        g.add(result)
    elif gf.len == 1:
        result = gf[0]  

proc remove(g:var Graph, n:Node) =
    for np in n.parents:
        np.children = np.children.filterIt(it != n)
    for nc in n.children:
        nc.parents = nc.parents.filterIt(it != n)
    let index = g.find(n)
    if index >= 0: g.del(index)

proc remove(g:var Graph, value:char) =
    for index, n in g:
        if n.value == value:
            g.remove(n)

proc connect(g:var Graph, a,b:Node) =
    a.children.add(b)
    b.parents.add(a)

proc connect(g:var Graph, a,b:char) =
    var na = g.getOrAdd(a)
    var nb = g.getOrAdd(b)
    g.connect(na,nb)

# --- Read data ---

proc getGraph():Graph=
    result = newSeq[Node]()
    for line in lines("7_input.txt"):
        var a,b:string
        discard line.scanf("Step $w must be finished before step $w can begin.", a,b)
        result.connect(a[0],b[0])

# --- Part 1 ---

var graph = getGraph()
var part1:string

while true:
    let orphans = graph.filterIt(it.parents.len == 0).sorted(cmp)
    if(orphans.len == 0): break
    part1 &= orphans[0].value
    graph.remove(orphans[0])

echo "Part 1: ", part1

# --- Part 2 ---

graph = getGraph()
var workers = newTable[char, int]()
var step = 0

while true:
    # decrease all worker time and remove if zero
    for k in workers.keys:
        dec(workers[k])
        if workers[k] <= 0:
            workers.del(k)
            graph.remove(k)

    # find all possible nodes, e.g. those with no parents and not already worked on
    var orphans = graph.filterIt(it.parents.len == 0)
                    .filterIt(not workers.hasKey(it.value))
                        .sorted(cmp)

    # start new workers
    while workers.len < 5 and orphans.len > 0:
        let value = orphans[0].value
        let time =  61 + orphans[0].value.int - 'A'.int
        workers.add(value, time)
        orphans.delete(0,0)

    if graph.len == 0: break

    inc(step)

echo "Part 2: ", step