local map = {}
local sum = 0
string.gfind = function(s, pattern, index, plain)
    index = index or 1
    plain = plain and true
    return function()
        local startIndex, endIndex, val = string.find(s, pattern, index, plain)
        if startIndex == nil then
            return nil, nil, nil
        end
        index = endIndex + 1
        return startIndex, val, endIndex
    end
end

for line in io.lines("input.txt") do
    local mapRow = {}
    line:gsub(".", function(char) mapRow[#mapRow + 1] = char end)
    for startIndex, value, endIndex in line:gfind("(%d+)") do
        for i = startIndex, endIndex do
            mapRow[i] = tonumber(value)
        end
    end
    map[#map + 1] = mapRow
end

local count = 1
for rowNumber, mapRow in ipairs(map) do
    for colNumber, val in ipairs(mapRow) do
        local row = rowNumber
        local col = colNumber
        if val == "*" then
            local gearCount = 0
            local gearRatio = 1
            for q = row - 1, row + 1 do
                for r = col - 1, col + 1 do
                    if q == row and r == col then
                    elseif map[q] and tonumber(map[q][r]) and gearCount <= 2 then
                        local selectNumber = map[q][r]
                        gearRatio = gearRatio * selectNumber
                        gearCount = gearCount + 1
                        count = count + 1
                        local index = r
                        while tonumber(map[q][index]) == selectNumber do
                            index = index - 1
                        end
                        index = index + 1
                        while tonumber(map[q][index]) == selectNumber do
                            map[q][index] = "."
                            index = index + 1
                        end
                    end
                end
            end
            if gearCount == 2 then
                sum = sum + gearRatio
            end
        end
    end
end
print(sum)
