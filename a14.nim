import sequtils, strutils

const puzzleInput =  "047801"
const puzzleInputInt = puzzleInput.parseInt
const puzzleInputList = puzzleInput.mapIt(parseInt($it).int8)

var elf1 = 0
var elf2 = 1
var scoreBoard:seq[int8] = @[3.int8, 7.int8]

template CheckPart2() =
    if scoreboard.len > puzzleInput.len:
        if scoreBoard[^puzzleInput.len..^1] == puzzleInputList:
            break;

while true:
    let combinedRecipe = scoreBoard[elf1] + scoreBoard[elf2]
    if combinedRecipe >= 10:
        scoreBoard.add(1)
        CheckPart2
        scoreBoard.add(combinedRecipe-10)
    else:
        scoreBoard.add(combinedRecipe)
    CheckPart2

    elf1 = (elf1 + 1 + scoreBoard[elf1]) mod scoreBoard.len
    elf2 = (elf2 + 1 + scoreBoard[elf2]) mod scoreBoard.len

echo "Part 1: ", scoreBoard[puzzleInputInt..puzzleInputInt+9].join("")
echo "Part 2: ", scoreBoard.len-puzzleInput.len
