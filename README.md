# adventofcode2018

| #     | comment                                                                          |   |
|-------|----------------------------------------------------------------------------------------------------------------|---|
| 1 | Found itertools with cycle() iterator                                                                          | https://github.com/filipux/adventofcode2018/blob/master/a01.nim  |
| 2 | toCountTable(seq) saved some typing - nice!                                                                    | https://github.com/filipux/adventofcode2018/blob/master/a02.nim  |
| 3 | Happy about how I could use an iterator for patches :)                                                         | https://github.com/filipux/adventofcode2018/blob/master/a03.nim  |
| 4 | Very hard. Learned about parseEnum[]() and attributes on enums                                                 | https://github.com/filipux/adventofcode2018/blob/master/a04.nim  |
| 5 | Started with string based regex solution but went with DoublyLinkedList for speed (0.1 seconds for both parts) | https://github.com/filipux/adventofcode2018/blob/master/a05.nim  |
| 6 | Hard problem. Inititally solved part #1 using a super fast flood fill technique but had to change to a slower method to solve part #2 with same code (0.2 sec for both parts).  | https://github.com/filipux/adventofcode2018/blob/master/a06.nim  |
| 7 | Graph problem that got a bit bloated. Why isn't there a Graph class in the Nim standard library? Tried out generics for the first time. Used strscans instead of regex to parse input. | https://github.com/filipux/adventofcode2018/blob/master/a07.nim  |
| 8 | Easier problem. readTree() turned out great, super happy about my code this time! Learned about seq.pop()| https://github.com/filipux/adventofcode2018/blob/master/a08.nim  |
| 9 | Easily solved using DoublyLinkedRing. ring.head.prev.prev.prev.prev.prev.prev.prev 😄| https://github.com/filipux/adventofcode2018/blob/master/a09.nim  |
| 10 | Also quite easy. Hardest part was figuring out when to stop time and how to print the output| https://github.com/filipux/adventofcode2018/blob/master/a10.nim  |
| 11 | Easy. Immediately recognised the problem as one that could make use an integral map. Had to read up on wikipedia how to implement one but it was very straight forward. | https://github.com/filipux/adventofcode2018/blob/master/a11.nim  |
| 12 | Meh. Learned how to index arrays backwards using [^] | https://github.com/filipux/adventofcode2018/blob/master/a12.nim  |
| 13 | I didn't like this one at all. Horrible horrible code that I don't want to see ever again. | https://github.com/filipux/adventofcode2018/blob/master/a13.nim  |
| 14 | Easy once you realise you need to check for Part 2 after each added recipe. | https://github.com/filipux/adventofcode2018/blob/master/a14.nim  |
| 15 | This was WAY too hard. Probably made 10% of all people give up on advent of code this year ☹️ I spent too much time on this so I didn't find the time to optimize the solution. It is is very slow, 13 seconds on my computer,  but optimizing it could be easy based on this quick profiling with nimprof: <pre>a15.nim: addNeighbour 628/1703 = 36.88%<br/>a15.nim: init 1096/1703 = 64.36%<br/>a15.nim: newDistanceMap 1697/1703 = 99.65%</pre>| https://github.com/filipux/adventofcode2018/blob/master/a15.nim  |
| 16 | Lots of fun and easy compared to #15. Used templates to get nice CPU emulator code. | https://github.com/filipux/adventofcode2018/blob/master/a16.nim  |
| 17 | Kept looking for a simple set of local rules to run the simulation and sort of found it in the end. Ugly code but I'm happy with the algorithm I ended up with. First working version took 10 minutes to finish but I was able to optimize it alot down to 0.1 seconds 😎 | https://github.com/filipux/adventofcode2018/blob/master/a17.nim  |
| 18 | Easy day but ugly code. Realised CountTable can't count to zero. Submitted a feature request. | https://github.com/filipux/adventofcode2018/blob/master/a18.nim  |
