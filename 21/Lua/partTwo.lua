local map = {}
local sr, sc
local count = 0
local unpack = table.unpack or unpack

for line in io.lines("input.txt") do
    count = count + 1
    map[count] = {}
    for i = 1, #line do
        map[count][i] = { string.sub(line, i, i), nil }
        if map[count][i][1] == "S" then
            sr, sc = count, i
        end
    end
end
local dir = { { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 } }
local function findPossibleStepCount(sr, sc, stepLimit)
    local queue = { { sr, sc, 0 } }
    local visited = {}
    local function addVisited(r, c)
        if visited[r] == nil then
            visited[r] = {}
        end
        visited[r][c] = true
    end
    local function isVisited(r, c)
        return visited[r] ~= nil and visited[r][c] == true
    end
    local stepCount = {}
    for i = 0, stepLimit, 1 do
        stepCount[i] = 0
    end
    while #queue > 0 do
        local stepData = table.remove(queue, 1)
        local r, c, step = unpack(stepData)
        if step == stepLimit + 1 or isVisited(r, c) then
            goto continue
        end

        stepCount[step] = stepCount[step] + 1
        addVisited(r, c)
        for _, d in ipairs(dir) do
            local nr, nc = r + d[1], c + d[2]
            if map[((nr - 1) % 131) + 1][((nc - 1) % 131) + 1][1] ~= "#" then
                queue[#queue + 1] = { nr, nc, step + 1 }
            end
        end
        ::continue::
    end
    return stepCount
end

local function possibleStep(r, c, stepLimit)
    local possibleStepCount = findPossibleStepCount(r, c, stepLimit)
    local sum = 0
    for step, count in pairs(possibleStepCount) do
        if (step % 2 == stepLimit % 2) then
            sum = sum + count
        end
    end
    return sum
end

local function quadraticFit(firstResult, secondResult, thirdResult, wantTerm)
    local a = math.floor((thirdResult - (2 * secondResult) + firstResult) / 2)
    local b = secondResult - firstResult - a
    local c = firstResult
    return (a * wantTerm ^ 2) + (b * wantTerm) + c
end

local center = sc - 1
local stepLimit = 26501365
local n = (stepLimit - sc + 1) / count
local x = possibleStep(sr, sc, center)
local y = possibleStep(sr, sc, center + 1 * count)
local z = possibleStep(sr, sc, center + 2 * count)

print(string.format("%.f", quadraticFit(x, y, z, n)))
