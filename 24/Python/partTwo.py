positionStrings = [line.split()[0:3] for line in open("input.txt").readlines()]
positionList = [
    [int(numberString.replace(",", "")) for numberString in positionString]
    for positionString in positionStrings
]
positionSum = [sum(position) for position in positionList]
result = set([x for x in positionSum if positionSum.count(x) > 1])
print(result.pop())
