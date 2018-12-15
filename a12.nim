import sequtils, strutils, re, tables

const PART1_ITERATIONS = 20
const MAX_ITERATIONS = 300

# Read data
let data = toSeq(lines("12_input.txt"))
var state = data[0][("initial state: ".len..^1)]
var rules = newTable[string, char]()

for r in data[2..^1]:
    let rr = toSeq(r.split(" => "))
    rules.add(rr[0], rr[1][0])

# Do stuff and junk
proc applyRule(state:string,rules:TableRef[string,char], pos:int):char =
    result = '.'
    let pattern = state[pos-2..pos+2]
    if rules.hasKey(pattern):
        result = rules[pattern]

# Each iteration could theoretically grow two new plants on each side
let dots = "..".repeat(MAX_ITERATIONS)
state = dots & state & dots

proc sumSeriesWithPlats(s:string):int=
    let left = s.find('#')
    let right = s.rfind('#')
    for x in left..right:
        if s[x] == '#':
            result += x-dots.len

var deltas:seq[int]
var lastTotalNumberOfPlants:int

for i in 1..MAX_ITERATIONS:

    # New iteration
    var newState = state
    for pos in 2..<state.len-2:
        newState[pos] = state.applyRule(rules, pos)
    state = newState

    # Calculate total number and difference to last iteration
    var totalNumberOfPlants = sumSeriesWithPlats(state)
    deltas.add(totalNumberOfPlants - lastTotalNumberOfPlants)
    lastTotalNumberOfPlants = totalNumberOfPlants
    
    # --- Part 1 ---
    if i == PART1_ITERATIONS:
        echo "Part 1: ", totalNumberOfPlants

    # --- Part 2 --- 
    # Check for convergence and extrapolate
    if deltas.len>20:
        if deltas[^10..^1].allIt(it == deltas[^11]):
            let finalDelta = deltas[high(deltas)]
            echo "Part 2: ", totalNumberOfPlants + (50000000000-i) * finalDelta
            break
    