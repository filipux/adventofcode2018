import sequtils, strutils, re, tables

# --- CPU ---

type Quad = array[4, int]

var registers = [0,0,0,0]

type Opcode = enum ADDR,ADDI,MULR,MULI,BANR,BANI,BORR,BORI,SETR,SETI,GTIR,GTRI,GTRR,EQIR,EQRI,EQRR

template A():int = registers[ar[1]]
template B():int = registers[ar[2]]
template C():int = registers[ar[3]]
template value_A():int = ar[1]
template value_B():int = ar[2]
template value_C():int = ar[3]

proc execute(ar:Quad) =
    case Opcode(ar[0]):
        of ADDR: C = A + B
        of ADDI: C = A + value_B
        of MULR: C = A * B
        of MULI: C = A * value_B
        of BANR: C = A and B
        of BANI: C = A and value_B
        of BORR: C = A or B
        of BORI: C = A or value_B
        of SETR: C = A
        of SETI: C = value_A
        of GTIR: C = (value_A > B).int
        of GTRI: C = (A > value_B).int
        of GTRR: C = (A > B).int
        of EQIR: C = (value_A == B).int
        of EQRI: C = (A == value_B).int
        of EQRR: C = (A == B).int
        else: discard

# --- Read and parse data ---

type TestData = tuple[before, instruction, after:Quad]

var data = readFile("16_input.txt").strip().split("\n\n\n\n")
var data1 = data[0].split("\n")
var data2 = data[1].split("\n")

proc parseQuad(line:string):Quad = 
    let r = line.findAll(re"\d+").map(parseInt)
    [r[0],r[1],r[2],r[3]]

proc parseTestData(data:seq[string]):seq[TestData] =   
    var i = 0
    while i < data.len:
        result.add((data[i].parseQuad, data[i+1].parseQuad, data[i+2].parseQuad))
        inc(i,4)

proc parseTestData2(data:seq[string]):seq[Quad] =   
   data.map(parseQuad)

# --- Part 1 ---

proc getPossibleInstructions(testData: TestData):tuple[value:int, opcodes:set[Opcode]] =
    result.value = testData.instruction[0]
    for opcode in Opcode:
        var test = testData.instruction
        test[0] = opcode.int # override opcode
        registers = testData.before
        execute(test)
        if registers == testData.after:
            result.opcodes.incl(opcode)

var possibleInstructions = data1.parseTestData.map(getPossibleInstructions)
let threeOrMoreOpcodes = possibleInstructions.filterIt(it.opcodes.card >= 3).len
echo "Part 1: ", threeOrMoreOpcodes

# --- Part 2 ---

var mapping = initTable[int, Opcode]()
var resolvedOpcodes:set[Opcode]

while toSeq(Opcode.items).len - mapping.len > 0:
    for resolved in possibleInstructions.filterIt(it.opcodes.card == 1):
        resolvedOpcodes.incl(resolved.opcodes)
        mapping[resolved.value] = toSeq(resolved.opcodes.items)[0]

    for x in possibleInstructions.mitems:
        x.opcodes.excl(resolvedOpcodes)

# Now we have a mapping. Run program.
var program = data2.parseTestData2

registers = [0,0,0,0]
for instruction in program:
    var mappedInstruction = instruction
    mappedInstruction[0] = mapping[instruction[0]].int
    execute(mappedInstruction)

echo "Part 2: ", registers[0]