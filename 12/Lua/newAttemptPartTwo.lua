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
local function convertToDamaged(map)
    local res = {}
    local count = 0
    for _, ch in substr(map) do
        if ch == '#' then
            count = count + 1
        elseif count > 0 and ch == "." then
            res[#res + 1] = count
            count = 0
        end
    end
    if count > 0 then
        res[#res + 1] = count
    end
    return res
end
local function possibleOutcomeGenerate(mapTable, mapTableIndex, damagedIndexTable)
    if mapTableIndex > #mapTable then
        coroutine.yield(mapTable)
    else
        if damagedIndexTable[mapTableIndex] then
            mapTable[mapTableIndex] = '#'
            possibleOutcomeGenerate(mapTable, mapTableIndex + 1, damagedIndexTable)
            mapTable[mapTableIndex] = '.'
            possibleOutcomeGenerate(mapTable, mapTableIndex + 1, damagedIndexTable)
        else
            possibleOutcomeGenerate(mapTable, mapTableIndex + 1, damagedIndexTable)
        end
    end
end

local function possibleOutcome(mapTable, damagedIndexTable)
    return coroutine.wrap(function() possibleOutcomeGenerate(mapTable, 1, damagedIndexTable) end)
end
local sum = 0
local multi = 5
for line in io.lines("input.txt") do
    local map, damagedList = line:match("(.*)%s(.*)")
    local mapTable = {}
    local damagedIndexTable = {}
    local count = 0
    local count2 = 0
    for i, ch in substr(map) do
        mapTable[#mapTable + 1] = ch
        if ch == '?' then
            damagedIndexTable[i] = true
        end
    end
    for _ in possibleOutcome(mapTable, damagedIndexTable) do
        local mapString = table.concat(mapTable, '')
        if table.concat(convertToDamaged(mapString), ',') == damagedList then
            count = count + 1
        end
    end
    damagedList = string.rep(damagedList, 2, ',')
    map = string.rep(map, 2, '?')
    damagedIndexTable = {}
    mapTable = {}
    for i, ch in substr(map) do
        mapTable[#mapTable + 1] = ch
        if ch == '?' then
            damagedIndexTable[i] = true
        end
    end
    for _ in possibleOutcome(mapTable, damagedIndexTable) do
        local mapString = table.concat(mapTable, '')
        if table.concat(convertToDamaged(mapString), ',') == damagedList then
            count2 = count2 + 1
        end
    end
    sum = sum + (count * (count2 / count) ^ (multi - 1))
end
print(sum)
