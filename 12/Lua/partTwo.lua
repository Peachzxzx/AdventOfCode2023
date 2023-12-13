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
local damagedIndexTable = {}
local mapTable = {}
local totalDamaged
local function possibleOutcomeGenerate(mapTableIndex, damagedCount)
    if damagedCount > totalDamaged then
    elseif mapTableIndex > #damagedIndexTable then
        coroutine.yield(true)
    else
        mapTable[damagedIndexTable[mapTableIndex]] = '#'
        possibleOutcomeGenerate(mapTableIndex + 1, damagedCount + 1)
        mapTable[damagedIndexTable[mapTableIndex]] = '.'
        possibleOutcomeGenerate(mapTableIndex + 1, damagedCount)
    end
end
local function possibleOutcome(damagedCount)
    return coroutine.wrap(function() possibleOutcomeGenerate(1, damagedCount) end)
end
local sum = 0
local multi = 5
for line in io.lines("input.txt") do
    local map, damagedList = line:match("(.*)%s(.*)")
    mapTable = {}
    damagedIndexTable = {}
    local count = 0
    local damage = 0
    totalDamaged = 0
    for i in string.gmatch(damagedList, "(%d+)") do
        totalDamaged = totalDamaged + tonumber(i)
    end

    for i, ch in substr(map) do
        mapTable[#mapTable + 1] = ch
        if ch == '?' then
            damagedIndexTable[#damagedIndexTable + 1] = i
        elseif ch == '#' then
            damage = damage + 1
        end
    end
    for _ in possibleOutcome(damage) do
        local mapString = table.concat(mapTable, '')
        if table.concat(convertToDamaged(mapString), ',') == damagedList then
            count = count + 1
        end
    end
    totalDamaged = totalDamaged * 2
    damagedList = string.rep(damagedList, 2, ',')
    map = string.rep(map, 2, '?')
    damagedIndexTable = {}
    mapTable = {}

    local count2 = 0
    local damage = 0
    for i, ch in substr(map) do
        mapTable[#mapTable + 1] = ch
        if ch == '?' then
            damagedIndexTable[#damagedIndexTable + 1] = i
        elseif ch == '#' then
            damage = damage + 1
        end
    end
    for _ in possibleOutcome(damage) do
        local mapString = table.concat(mapTable, '')
        if table.concat(convertToDamaged(mapString), ',') == damagedList then
            count2 = count2 + 1
        end
    end
    sum = sum + (count * (math.ceil(count2 / count) ^ (multi - 1)))
end
print(sum)
