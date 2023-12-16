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

local map = {}
for line in io.lines("input.txt") do
    local tempRowMap = {}
    for i, ch in substr(line) do
        tempRowMap[i] = ch
    end
    map[#map + 1] = tempRowMap
end

local height = #map
local width = #map[1]
for i = 1, height do
    for j = 1, width do
        if map[i][j] == "O" then
            local tempIndex = i
            while map[tempIndex - 1] ~= nil and map[tempIndex - 1][j] == '.' do
                tempIndex = tempIndex - 1
            end
            map[i][j] = "."
            map[tempIndex][j] = "O"
        end
    end
end

local supportBeamLoad = 0
for i = 1, height do
    for j = 1, width do
        if map[i][j] == 'O' then
            supportBeamLoad = supportBeamLoad + (#map - i + 1)
        end
    end
end

print(supportBeamLoad)
