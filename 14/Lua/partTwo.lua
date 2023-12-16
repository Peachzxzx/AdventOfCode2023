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
local seen = {}
local state = 0
local loopStart
local loopEnd
local loopIndex
local index = 0
while index < 1e9 do
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
    for i = 1, height do
        for j = 1, width do
            if map[i][j] == "O" then
                local tempIndex = j
                while map[i][tempIndex - 1] == '.' do
                    tempIndex = tempIndex - 1
                end
                map[i][j] = "."
                map[i][tempIndex] = "O"
            end
        end
    end
    for i = height, 1, -1 do
        for j = 1, width do
            if map[i][j] == "O" then
                local tempIndex = i
                while map[tempIndex + 1] ~= nil and map[tempIndex + 1][j] == '.' do
                    tempIndex = tempIndex + 1
                end
                map[i][j] = "."
                map[tempIndex][j] = "O"
            end
        end
    end
    for i = 1, height do
        for j = width, 1, -1 do
            if map[i][j] == "O" then
                local tempIndex = j
                while map[i][tempIndex + 1] == '.' do
                    tempIndex = tempIndex + 1
                end
                map[i][j] = "."
                map[i][tempIndex] = "O"
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
    index = index + 1

    if state == 1 then
        if seen[loopIndex][2] == supportBeamLoad then
            if loopIndex == loopEnd then
                break
            end
            loopIndex = loopIndex + 1
        else
            state = 0
        end
    end
    if state == 0 then
        for i = #seen, 1, -1 do
            if seen[i][2] == supportBeamLoad then
                loopIndex = i + 1
                loopEnd = #seen
                loopStart = i
                state = 1
                break
            end
        end
    end
    seen[#seen + 1] = { index, supportBeamLoad }
end

print(seen[(1e9 - loopStart) % (loopEnd - loopStart + 1) + loopStart][2])
