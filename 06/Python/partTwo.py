import math

with open("input.txt", "r") as f:
    line = f.readlines()
    time = int(''.join(line[0].strip().split()[1:]))
    distance = int(''.join(line[1].strip().split()[1:]))
    sums = 0
    for i in range(math.floor(time/2)+1):
        dis = i * (time-i)
        if dis > distance:
            sums += 1 if time%2 == 0 and i == time//2 else 2
    print(sums)
    # distance = - i ^ 2 + i * time
    # i^2 - i * time + distance = 0
    # -time + sqrt(time^2 - 4 * distance) / 2
