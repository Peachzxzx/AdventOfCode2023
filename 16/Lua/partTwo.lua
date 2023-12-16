local map = {}
local queue = {}
local cache = {}
local function storeQueue(xUpDown, yLeftRight, upDown, leftRight, distanceLimit)
    if cache[upDown] == nil then
        cache[upDown] = {}
    end
    if cache[upDown][leftRight] == nil then
        cache[upDown][leftRight] = {}
    end
    if cache[upDown][leftRight][xUpDown] == nil then
        cache[upDown][leftRight][xUpDown] = {}
    end
    if cache[upDown][leftRight][xUpDown][yLeftRight] ~= true then
        queue[#queue + 1] = { xUpDown, yLeftRight, upDown, leftRight, distanceLimit }
        cache[upDown][leftRight][xUpDown][yLeftRight] = true
    end
end

local function light()
    local data = table.remove(queue, 1)
    local xUpDown = data[1]
    local yLeftRight = data[2]
    local upDown = data[3]
    local leftRight = data[4]
    local distanceLimit = data[5]

    if distanceLimit <= 0 then
    elseif upDown ~= 0 then
        while map[xUpDown] ~= nil and (map[xUpDown][yLeftRight][1] == "." or map[xUpDown][yLeftRight][1] == "|") and distanceLimit > 0 do
            map[xUpDown][yLeftRight][2] = true
            distanceLimit = distanceLimit - 1
            xUpDown = xUpDown + upDown
        end
        if map[xUpDown] == nil or distanceLimit <= 0 then
            return
        end
        distanceLimit = distanceLimit - 1
        map[xUpDown][yLeftRight][2] = true
        if map[xUpDown][yLeftRight][1] == "-" then
            storeQueue(xUpDown, yLeftRight + 1, 0, 1, distanceLimit)
            storeQueue(xUpDown, yLeftRight - 1, 0, -1, distanceLimit)
        elseif map[xUpDown][yLeftRight][1] == "/" then
            storeQueue(xUpDown, yLeftRight - upDown, 0, -upDown, distanceLimit)
        elseif map[xUpDown][yLeftRight][1] == "\\" then
            storeQueue(xUpDown, yLeftRight + upDown, 0, upDown, distanceLimit)
        end
    elseif leftRight ~= 0 then
        while map[xUpDown][yLeftRight] ~= nil and (map[xUpDown][yLeftRight][1] == "." or map[xUpDown][yLeftRight][1] == "-") and distanceLimit > 0 do
            map[xUpDown][yLeftRight][2] = true
            yLeftRight = yLeftRight + leftRight
            distanceLimit = distanceLimit - 1
        end
        if map[xUpDown][yLeftRight] == nil or distanceLimit <= 0 then
            return
        end
        distanceLimit = distanceLimit - 1
        map[xUpDown][yLeftRight][2] = true
        if map[xUpDown][yLeftRight][1] == "|" then
            storeQueue(xUpDown + 1, yLeftRight, 1, 0, distanceLimit)
            storeQueue(xUpDown - 1, yLeftRight, -1, 0, distanceLimit)
        elseif map[xUpDown][yLeftRight][1] == "/" then
            storeQueue(xUpDown - leftRight, yLeftRight, -leftRight, 0, distanceLimit)
        elseif map[xUpDown][yLeftRight][1] == "\\" then
            storeQueue(xUpDown + leftRight, yLeftRight, leftRight, 0, distanceLimit)
        end
    end
end

local function trace(xUpDown, yLeftRight, upDown, leftRight)
    storeQueue(xUpDown, yLeftRight, upDown, leftRight, 1000)
    while #queue > 0 do
        light()
    end
    local sum = 0
    for i = 1, #map do
        for j = 1, #map[1] do
            if (map[i][j][2]) then
                sum = sum + 1
                map[i][j][2] = false
            end
        end
    end
    cache = {}
    return sum
end

local function maxTrace(xUpDown, yLeftRight)
    local N = trace(xUpDown, yLeftRight, -1, 0)
    local E = trace(xUpDown, yLeftRight, 0, 1)
    local W = trace(xUpDown, yLeftRight, 0, -1)
    local S = trace(xUpDown, yLeftRight, 1, 0)
    return math.max(N, E, W, S)
end

for line in io.lines("input.txt") do
    local tempRowMap = {}
    for i = 1, #line do
        tempRowMap[i] = { line:sub(i, i), false }
    end
    map[#map + 1] = tempRowMap
end

local sum = 0
for i = 1, #map do
    for j = 1, #map[1] do
        local result = maxTrace(i, j)
        if result > sum then
            sum = result
        end
    end
end

print(sum)
