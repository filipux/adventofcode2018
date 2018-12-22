import sequtils, strutils, re, tables

# --- CPU ---

var ip: tuple[value, register:int]
var registers = [0,0,0,0,0,0]

type Opcode = enum ADDR,ADDI,MULR,MULI,BANR,BANI,BORR,BORI,SETR,SETI,GTIR,GTRI,GTRR,EQIR,EQRI,EQRR

type Instruction = tuple[opcode:Opcode, p1, p2, p3:int]

template A():int = registers[ar.p1]
template B():int = registers[ar.p2]
template C():int = registers[ar.p3]
template value_A():int = ar.p1
template value_B():int = ar.p2
template value_C():int = ar.p3

proc execute(ar:Instruction) =
    case ar.opcode:
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

proc parseProgram(data:seq[string]):seq[Instruction] =
    for line in data:
        let tokens = line.split(" ")
        let regs = tokens[1..3].map(parseInt)
        let op = parseEnum[Opcode](tokens[0])
        result.add((op, regs[0], regs[1], regs[2]))

proc runProgram(program:seq[Instruction]) =
    ip.value = 0
    while ip.value in 0..<program.len:
        registers[ip.register] = ip.value
        execute(program[ip.value])
        ip.value = registers[ip.register]
        inc(ip.value)

var data = toSeq(lines("19_input.txt"))
ip.register = data[0].findAll(re"\d+")[0].parseInt
data.delete(0)
let program = parseProgram(data)

# --- Part 1 ---

registers = [0,0,0,0,0,0]
runProgram(program)

echo "Part 1: ", registers[0]

# --- Part 2 ---

#registers = [1,0,0,0,0,0]
#runProgram(program)

#echo "Part 2: ", registers[0]

# Would need ~3 years to run!
# See a19_part2.nim for analysis and solution.
