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
local multi = 10 ^ 6
local countDotCol = {}
local rowCount = 1
for line in io.lines("input.txt") do
    countDot = 0
    tempRowMap = {}
    for colCount, ch in substr(line) do
        tempRowMap[colCount] = { ["ch"] = ch, ["distanceRow"] = 1, ["distanceCol"] = 1 }
        if ch == "." then
            countDot = countDot + 1
            countDotCol[colCount] = countDotCol[colCount] and countDotCol[colCount] + 1 or 1
        elseif ch == "#" then
            galaxiesPosition[index] = { rowCount, colCount }
            index = index + 1
        end
    end
    universeMap[#universeMap + 1] = tempRowMap
    if countDot == #tempRowMap then
        for _, positionDetail in ipairs(tempRowMap) do
            positionDetail["distanceRow"] = positionDetail["distanceRow"] * multi
        end
    end
    rowCount = rowCount + 1
end
for col, countDot in ipairs(countDotCol) do
    if countDot == #universeMap then
        for row = 1, #universeMap do
            universeMap[row][col]["distanceCol"] = universeMap[row][col]["distanceCol"] * multi
        end
    end
end
for i = 1, #galaxiesPosition do
    for j = i + 1, #galaxiesPosition do
        local startRow = galaxiesPosition[j][1]
        local endRow = galaxiesPosition[i][1]
        local startCol = galaxiesPosition[j][2]
        local endCol = galaxiesPosition[i][2]
        if startRow > endRow then
            startRow, endRow = endRow, startRow
        end
        if startCol > endCol then
            startCol, endCol = endCol, startCol
        end
        for x = startRow + 1, endRow do
            sum = sum + universeMap[x][startCol]["distanceRow"]
        end
        for y = startCol + 1, endCol do
            sum = sum + universeMap[endRow][y]["distanceCol"]
        end
    end
end

print(sum)
