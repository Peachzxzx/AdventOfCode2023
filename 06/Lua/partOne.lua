local ta = {}
for line in io.lines("input.txt") do
    local numbers = {}
    for val in line:gmatch("(%d+)") do
        numbers[#numbers + 1] = tonumber(val)
    end
    ta[#ta + 1] = numbers
end
local ways = 1
-- distance + 1 > distance =  (totalTime - holdedTime) * holdedTime
-- distance + 1 > holdedTime * holdedTime - holdedTime ^ 2
-- holdedTime ^ 2 - totalTime * holdedTime + distance + 1 > 0
-- holdedTime > ( totalTime +- sqrt( totalTime ^ 2 - 4 * (distance + 1) ) ) / 2
for index = 1, #ta[1] do
    local time = ta[1][index]
    local distance = ta[2][index] + 1
    local t1 = math.floor((time + math.sqrt((time ^ 2) - (4 * distance))) / 2)
    local t2 = math.ceil((time - math.sqrt((time ^ 2) - (4 * distance))) / 2)
    ways = ways * (t1-t2 + 1)
end
print(ways)
