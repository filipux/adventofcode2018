#[    
# Instruction by instruction rewrite and analysis

00:    ip = ip + 16    # goto 17

01:    D = 1           # [A=0, B=10551267, C=0, D=1, E=10550400, ip=1]
02     C = 1           # [A=0, B=10551267, C=1, D=1, E=10550400, ip=1]
03:  ┌>E = D * C       # inner loop 
04:  │ E = E == B       
05:  │ ip = E + ip     # if E == B: goto 07: else: 
06:  │ ip = ip + 1     # goto 08
07:  │ A = D + A
08:  │ C = C + 1
09:  │ E = C > B       
10:  │ ip = ip + E     # if C > B: goto 12: else
11:  └─ip = 2          # goto 03
12:    D = D + 1
13:    E = D > B
14:    ip = E + ip     # if D > B: goto 16 (exit) else:
15:    ip = 1          # goto 02
16     ip = ip * ip    # exit

# init
17:    B = B + 2       
18:    B = B * B
19:    B = ip * B
20:    B = B * 11
21:    E = E + 1
22:    E = E * ip
23:    E = E + 9
24:    B = B + E
25:    ip = ip + A
26:    ip = 0          # goto 01

27:    E = ip
28:    E = E * ip
29:    E = ip + E
30:    E = ip * E
31:    E = E * 14
32:    E = E * ip
33:    B = B + E
34:    A = 0
35:    ip = 0

]#

# A high level rewrite of assembler code

proc simplification1():int = 
    var A=0
    var B=10551267
    var C=0
    var D=0
    var E=10550400

    D=1                 # 01
    while true:
        C=1             # 02
        while true:
            E = D * C   # 03
            if E == B:  # 04
                A += D  # 07
            inc(C)      # 08
            if C > B:
                break   # 11
        inc(D)          # 12
        if D > B: break # 13
    result = A

# Simplified things alot more here

proc simplification2():int =
    var A=0
    var B=10551267
    var C=0
    var D=0
    var E=10550400
    for D in 1..10551267:
        for C in 1..10551267:
            if C * D == 10551267:
                A += D
    result = A

# Final solution - realised what the code actually does:
# Compute sum of integer factors of 10551267

import intsets, math, algorithm

proc factors(n:int): seq[int] =
    var fs = initIntSet()
    for x in 1 .. int(sqrt(float(n))):
        if n mod x == 0:
            fs.incl(x)
            fs.incl(n div x)
    
    result = @[]
    for x in fs:
        result.add(x)
    sort(result, system.cmp[int])
    
echo "Part 2: ", factors(10551267).sum