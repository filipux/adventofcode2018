import strutils,sequtils, itertools, math, lists, sugar

proc len(l:DoublyLinkedList):int = 
    result = toSeq(l.items).len

proc toList(s:string):DoublyLinkedList[char] = 
    result = initDoublyLinkedList[char]()
    for c in s: result.append(c)

proc shouldReactChars(a,b:char):bool = abs(a.int - b.int) == abs('a'.int - 'A'.int)

proc react(l:var DoublyLinkedList[char]) =
    for k in l.nodes:
        if k.prev != nil:
            if(shouldReactChars(k.value, k.prev.value)):
                l.remove(k.prev)
                l.remove(k)

# Part 1:

var data = readFile("5_input.txt").strip()
var list = data.toList()
list.react()

echo "Part 1: ", list.len

# Part 2:

var minLen = data.len
for c in 'a'..'z':
    var unitList = data.toList()
    for k in unitList.nodes:
        if(k.value == c or k.value == c.toUpperAscii):
            unitList.remove(k)
    unitList.react()
    minLen = min(minLen, unitList.len)

echo "Part 2: ", minLen