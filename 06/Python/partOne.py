import math


result = []
with open("input.txt", "r") as f:
    line = f.readlines()
    time = line[0].strip().split()[1:]
    distance = line[1].strip().split()[1:]
    s = 1
    for t,d in zip(time,distance):
        t = int(t)
        d = int(d)
        sums = 0
        # print(t/2)
        # print(math.floor(t/2)+1)
        for i in range(math.floor(t/2)+1):
            # print(i)
            dis = i * (t-i)
            if dis > d:
                print(i, dis)
                sums += 1 if t%2 == 0 and i == t//2 else 2
        # print(sums)
        s *= sums
    print(s)
