import strutils, sequtils, tables, sugar, times, re, algorithm, math

type ShiftState = enum BeginsShift = "Guard", FallsAsleep = "falls", WakesUp = "wakes"
type Nap = tuple[start:DateTime, to:DateTime]
type Naps = seq[Nap]
type Logs = OrderedTable[int, Naps]

iterator minutes(nap:Nap):int64 =
    var time = nap.start
    while time < nap.to:
        yield time.minute
        time += 1.minutes

proc mostSleepyMinute(naps:Naps):tuple[minute:int64,totalSleep:int] =
    let (a,b) = toCountTable(naps.mapIt(toSeq[minutes(it)]).concat()).largest()
    result = (a,b)

proc totalSleep(naps:Naps):Duration =
    result = naps.mapIt(it.to-it.start).sum()

proc mostSleepyGuard(logs:Logs):tuple[id:int, totalSleep:Duration]=
    for guard, naps in logs:
        let totalSleep = totalSleep(naps)
        if totalSleep >= result.totalSleep:
            result = (guard, totalSleep)

proc loadLogs():Logs  =
    var startTime:DateTime
    var guard:int
    result = initOrderedTable[int, Naps]()
    
    for line in toSeq(lines("4_input.txt")).sorted(cmp):
        let log = line.findAll(re"\[.*\]|wakes|falls|Guard|\d+")
        let time = log[0].parse("[yyyy-MM-dd hh:mm]")
        let state = parseEnum[ShiftState](log[1])

        case state:
            of BeginsShift:
                guard = parseInt(log[2])
            of FallsAsleep:
                startTime = time
            of WakesUp:
                discard result.hasKeyOrPut(guard, @[])
                result[guard].add((startTime, time))

# Part 1

var logs = loadLogs()
let guard = logs.mostSleepyGuard()
var minute = logs[guard.id].mostSleepyMinute().minute

echo "Part1: ", guard.id * minute

# Part 2

logs.sort((a,b:(int, Naps)) => cmp(mostSleepyMinute(b[1]).totalSleep, mostSleepyMinute(a[1]).totalSleep))
let (guard2, naps) = toSeq(logs.pairs)[0]
let minute2 = mostSleepyMinute(naps).minute
echo "Part2: ", guard2 * minute2
