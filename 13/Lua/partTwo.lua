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
local sum = 0
local function solve()
    local left, right = 1, 2
    local top, bottom = 1, 2
    local a, b = 0, 0
    local sol = {}
    while bottom <= #map do
        a = top
        b = bottom
        while a > 0 and b <= #map do
            for i = 1, #map[1] do
                if map[a][i] ~= map[b][i] then
                    goto continue
                end
            end
            a = a - 1
            b = b + 1
        end
        sol[#sol + 1] = top * 100
        ::continue::
        top = top + 1
        bottom = bottom + 1
    end
    while right <= #map[1] do
        a = left
        b = right
        while a > 0 and b <= #map[1] do
            for i = 1, #map do
                if map[i][a] ~= map[i][b] then
                    goto continue
                end
            end
            a = a - 1
            b = b + 1
        end
        sol[#sol + 1] = left
        ::continue::
        left = left + 1
        right = right + 1
    end
    return sol
end

local function solve2()
    local res
    local solutionHashMap = {}
    for i = 1, #map do
        for j = 1, #map[1] do
            if map[i][j] == '.' then
                map[i][j] = '#'
            else
                map[i][j] = '.'
            end
            res = solve()
            if map[i][j] == '.' then
                map[i][j] = '#'
            else
                map[i][j] = '.'
            end
            for _, v in ipairs(res) do
                solutionHashMap[v] = true
            end
        end
    end
    res = solve()
    solutionHashMap[res[1]] = nil
    for key, _ in pairs(solutionHashMap) do
        return key
    end
end

for line in io.lines("input.txt") do
    if line == "" then
        sum = sum + solve2()
        map = {}
        goto continue
    end
    local tempRowMap = {}
    for index, val in substr(line) do
        tempRowMap[index] = val
    end
    map[#map + 1] = tempRowMap
    ::continue::
end
sum = sum + solve2()
print(sum)
