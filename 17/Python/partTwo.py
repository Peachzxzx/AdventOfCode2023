import heapq

graph = [[int(y) for y in x] for x in open("input.txt").read().splitlines()]
gr = len(graph)
gc = len(graph[0])
queue = [(0, 0, 0, -1, 0)]
cache = set()

x = [(-1, 0), (0, -1), (1, 0), (0, 1)]
while queue:
    distance, row, column, facingDirection, count = heapq.heappop(queue)

    if gr - 1 == row and gc - 1 == column and count > 3:
        print(distance)
        break

    if (row, column, facingDirection, count) in cache:
        continue
    cache.add((row, column, facingDirection, count))

    for i, (dr, dc) in enumerate(x):
        newRow = row + dr
        newCol = column + dc

        if 0 <= newRow < gr and 0 <= newCol < gc:
            newDistance = distance + graph[newRow][newCol]

            if count < 10 and i == facingDirection or -1 == facingDirection:
                heapq.heappush(queue, (newDistance, newRow, newCol, i, count + 1))
                
            if count > 3 and facingDirection != i and (facingDirection + 2) % 4 != i:
                heapq.heappush(queue, (newDistance, newRow, newCol, i, 1))
