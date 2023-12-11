local function substr(s)
    local index = 1
    local endIndex = s:len()
    return function()
        if index > endIndex then
            return nil
        end
        local character = string.sub(s, index, index)
        index = index + 1
        return index - 1, character
    end
end
local universeMap = {}
local galaxiesPosition = {}
local sum = 0
local index = 1
local countDot
local tempRowMap
for line in io.lines("input.txt") do
    countDot = 0
    tempRowMap = {}
    for colCount, ch in substr(line) do
        tempRowMap[colCount] = ch
        if ch == "." then
            countDot = countDot + 1
        end
    end
    universeMap[#universeMap + 1] = tempRowMap
    if countDot == #tempRowMap then
        tempRowMap = {}
        for k = 1, #universeMap[#universeMap] do
            tempRowMap[k] = "."
        end
        universeMap[#universeMap + 1] = tempRowMap
    end
end
for j = #tempRowMap, 1, -1 do
    countDot = 0
    for i = 1, #universeMap do
        if universeMap[i][j] == "." then
            countDot = countDot + 1
        end
    end
    if countDot == #universeMap then
        for i = 1, #universeMap do
            table.insert(universeMap[i], j, ".")
        end
    end
end
index = 1
for i = 1, #universeMap do
    for j = 1, #universeMap[i] do
        if universeMap[i][j] == "#" then
            galaxiesPosition[index] = { i, j }
            index = index + 1
        end
    end
end

for i = 1, #galaxiesPosition do
    for j = i + 1, #galaxiesPosition do
        sum = sum + math.abs(galaxiesPosition[j][1] - galaxiesPosition[i][1]) +
        math.abs(galaxiesPosition[j][2] - galaxiesPosition[i][2])
    end
end

print(sum)
