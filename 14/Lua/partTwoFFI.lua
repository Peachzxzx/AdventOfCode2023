local ffi = require('ffi')

local keepAwayFromGC = {}
local height = 100
local width = 100
local map = ffi.new("char*[100]")
for i = 0, height - 1 do
    local cString = ffi.new("char[101]")
    map[i] = cString
    keepAwayFromGC[i + 1] = cString
end

local countIndex = 0
for line in io.lines("input.txt") do
    ffi.copy(map[countIndex], line)
    countIndex = countIndex + 1
end

local seen = {}
local state = 0
local loopIndex
local loopStart
local loopEnd
local index = 0
while index < 1e9 do
    for i = 0, height - 1 do
        for j = 0, width - 1 do
            if map[i][j] == 79 then
                local tempIndex = i
                while tempIndex - 1 >= 0 and map[tempIndex - 1][j] == 46 do
                    tempIndex = tempIndex - 1
                end
                map[i][j] = 46
                map[tempIndex][j] = 79
            end
        end
    end
    for i = 0, height - 1 do
        for j = 0, width - 1 do
            if map[i][j] == 79 then
                local tempIndex = j
                while tempIndex - 1 >= 0 and map[i][tempIndex - 1] == 46 do
                    tempIndex = tempIndex - 1
                end
                map[i][j] = 46
                map[i][tempIndex] = 79
            end
        end
    end
    for i = height - 1, 0, -1 do
        for j = 0, width - 1 do
            if map[i][j] == 79 then
                local tempIndex = i
                while tempIndex + 1 < height and map[tempIndex + 1][j] == 46 do
                    tempIndex = tempIndex + 1
                end
                map[i][j] = 46
                map[tempIndex][j] = 79
            end
        end
    end
    for i = 0, height - 1 do
        for j = width - 1, 0, -1 do
            if map[i][j] == 79 then
                local tempIndex = j
                while tempIndex + 1 < width and map[i][tempIndex + 1] == 46 do
                    tempIndex = tempIndex + 1
                end
                map[i][j] = 46
                map[i][tempIndex] = 79
            end
        end
    end
    
    local supportBeamLoad = 0
    for i = 0, height - 1 do
        for j = 0, width - 1 do
            if map[i][j] == 79 then
                supportBeamLoad = supportBeamLoad + height - i
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
