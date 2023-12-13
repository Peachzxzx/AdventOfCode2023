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
local function findUnknown(map)
    local res = {}
    for i, ch in substr(map) do
        if ch == "?" then
            res[#res + 1] = i
        end
    end
    return res
end
local da = {}
local mapTable = {}
local totalDamaged
local damagedTable = {}
local function isPossible()
    local state = 0
    local index = 1
    local count = 0
    for _, ch in ipairs(mapTable) do
        if ch == "." then
            if state == 0 then
                state = 1
                index = index + 1
            end
        elseif ch == "?" then
            state = 0
        elseif ch == "#" then
            state = 0
            count = count + 1
            if count > damagedTable[index] then
                return false
            end
        end
    end
    return true
end
local function permgen(n, damagedCount)
    if damagedCount > totalDamaged then
    elseif n > #da then
        coroutine.yield(true)
    else
        mapTable[da[n]] = '#'
        permgen(n + 1, damagedCount + 1)
        mapTable[da[n]] = '.'
        permgen(n + 1, damagedCount)
    end
end

local function perm(damagedCount)
    return coroutine.wrap(function() permgen(1, damagedCount) end)
end
local function solve(mapIndex, damagedIndex, ch, chPrev, damage)
    -- local x = 0
    -- local debugStack = {}
    -- debugStack[#debugStack+1] = ch
    -- print(mapIndex, damagedIndex, ch, chPrev, damage)
    if damage < 0 then
        return 0
    end
    if damage == 0 then
        if damagedIndex == #damagedTable then
            if ch == nil then
                return 1
            end
            if ch == "." or ch == "?" then
                return solve(mapIndex + 1, damagedIndex, mapTable[mapIndex + 1], ch, damage)
            end
            return 0
        end
        if ch == "." then
            if chPrev == "." then
                return solve(mapIndex + 1, damagedIndex, ch, chPrev, damage)
            end
            return solve(mapIndex + 1, damagedIndex + 1, mapTable[mapIndex + 1], ch, damagedTable[damagedIndex + 1])
        end
        if ch == "?" then
            return solve(mapIndex, damagedIndex, ".", chPrev, damage)
        end
        return 0
    end
    if damage > 0 then
        if ch == "." then
            if chPrev == "." then
                return solve(mapIndex + 1, damagedIndex, mapTable[mapIndex + 1], ch, damage)
            end
            if damage ~= 0 then
                return 0
            end
            return solve(mapIndex + 1, damagedIndex + 1, mapTable[mapIndex + 1], ch, damagedTable[damagedIndex + 1])
        end
        if ch == "#" then
            return solve(mapIndex + 1, damagedIndex, mapTable[mapIndex + 1], ch, damage - 1)
        end
        if ch == "?" then
            return solve(mapIndex, damagedIndex, "#", chPrev, damage) +
                solve(mapIndex, damagedIndex, ".", chPrev, damage)
        end
    end
    -- print("LOL")
    -- print(table.concat(debugStack,"1"))
    if damage == 0 then
        if damagedIndex == #damagedTable then
            return 1
        end
        -- print("LOL56")
    end
    return 0
    -- print(x)
end
local sum = 0
local multi = 5
for line in io.lines("input.txt") do
    local map, damaged = line:match("(.*)%s(.*)")
    totalDamaged = 0
    damagedTable = {}
    for i in string.gmatch(damaged, "(%d)") do
        totalDamaged = totalDamaged + tonumber(i)
        damagedTable[#damagedTable + 1] = tonumber(i)
    end
    da = {}
    mapTable = {}
    local damage = 0
    for i, ch in substr(map) do
        mapTable[i] = ch
        if ch == '?' then
            da[#da + 1] = i
        elseif ch == '#' then
            damage = damage + 1
        end
    end
    local x = solve(1, 1, mapTable[1], ".", damagedTable[1])
    sum = sum + x
end
print(sum)
