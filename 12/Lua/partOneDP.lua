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
local solveDP = {}
local function solve(mapTable, damagedTable)
    if #mapTable == 0 then
        if #damagedTable == 0 then
            return 1
        end
        return 0
    end
    if #damagedTable == 0 then
        for _, val in ipairs(mapTable) do
            if val == '#' then
                return 0
            end
        end
        return 1
    end

    local sum = 0

    if mapTable[1] == '.' or mapTable[1] == '?' then
        local newMapTable = {}
        for i = 2, #mapTable do
            newMapTable[i - 1] = mapTable[i]
        end
        sum = sum + solve(newMapTable, damagedTable)
    end
    if mapTable[1] == '#' or mapTable[1] == '?' then
        if damagedTable[1] == #mapTable or (damagedTable[1] < #mapTable and mapTable[damagedTable[1] + 1] ~= '#') then
            local newMapTable = {}
            local newDamageTable = {}
            for i = 1, damagedTable[1] do
                if mapTable[i] == '.' then
                    goto EndOfFunction
                end
            end
            for i = 2 + damagedTable[1], #mapTable do
                newMapTable[i - 1 - damagedTable[1]] = mapTable[i]
            end
            for i = 2, #damagedTable do
                newDamageTable[i - 1] = damagedTable[i]
            end
            sum = sum + solve(newMapTable, newDamageTable)
        end
    end
    ::EndOfFunction::
    return sum
end
local sum = 0
for line in io.lines("input.txt") do
    local map, damagedList = line:match("(.*)%s(.*)")
    local mapTable = {}
    local damagedTable = {}
    local count = 0
    for i, ch in substr(map) do
        mapTable[i] = ch
    end
    for val in string.gmatch(damagedList, "(%d+)") do
        damagedTable[#damagedTable + 1] = tonumber(val)
    end
    count = solve(mapTable, damagedTable)
    sum = sum + count
end
io.write(string.format("%.0f", sum))
