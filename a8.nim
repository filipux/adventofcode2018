import strutils, sequtils, math

type Node = ref object
    children: seq[Node]
    metadata: seq[int]

# Debug function
proc `$`(n:Node, i:int=65):string = 
    result &= chr(i)
    result &= "["
    for j,c in n.children:
        if j > 0: result &= "," 
        result &= `$`(c, i+j+1)
    result &= "]"

# Recursive iterators are not allowed so we must use our own stack
iterator nodes(root: Node): Node =
    var stack: seq[Node] = @[root]
    while stack.len > 0:
        var n = stack.pop()
        yield n
        add(stack, n.children)

# I think I nailed it
proc readTree(data:seq[int]):Node =
    var i = 0
    proc readInt():int =
        result = data[i]
        inc(i)
    proc readNode():Node =
        result = new(Node)
        let childCount = readInt()
        let metadataCount = readInt()
        for c in 0..<childCount:
            result.children.add(readNode())
        for m in 0..<metadataCount:
            result.metadata.add(readInt())
    result = readNode()

# --- Read data ---

let data = readFile("8_input.txt").strip().split(" ").map(parseInt)
var tree = readTree(data)

# --- Part 1 ---

echo "Part 1: ", toSeq(tree.nodes).mapIt(it.metadata).concat.sum

# --- Part 2 ---

proc getValue(node:Node):int=
    if node.children.len == 0:
        return node.metadata.sum
    for m in node.metadata:
        if m in 1..(node.children.len):
            result += getValue(node.children[m-1])

echo "Part 2: ", getValue(tree)