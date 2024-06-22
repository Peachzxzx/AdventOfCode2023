local switchTable = {
    ["A"] = true,
    ["R"] = false,
}

for line in io.lines("input.txt") do
    if line == '' then
        break
    end

    local switchName = string.match(line, "^(%a+){")
    local switch = { name = switchName }

    local count = 1
    for xmas, opcode, compareValue, nextSwitch in string.gmatch(line, "(%a+)([><])(%d+):(%a+),") do
        switch[count] = { xmas, opcode, tonumber(compareValue), nextSwitch }
        count = count + 1
    end
    local theElse = string.match(line, ",(%a+)}$")
    switch[count] = { true, true, true, theElse }

    switchTable[switchName] = switch
end

local rangeTable = { { x = { 1, 4000 }, m = { 1, 4000 }, a = { 1, 4000 }, s = { 1, 4000 }, jumpTo = "in" } }
local queue = { switchTable["in"] }
local function queueInsert(switch)
    if type(switch) ~= "boolean" then
        queue[#queue + 1] = switch
    end
end
local function rangeCopy(source)
    local newRange = { x = {}, m = {}, a = {}, s = {}, jumpTo = "in" }
    for key, compareValue in pairs(source) do
        if key == "jumpTo" then
            newRange[key] = compareValue
        else
            newRange[key] = { unpack(compareValue) }
        end
    end
    return newRange
end

while #queue > 0 do
    local switch = table.remove(queue, 1)
    for i = 1, #switch do
        local xmas, opcode, compareValue, nextSwitch = unpack(switch[i])

        for j = 1, #rangeTable do
            local range = rangeTable[j]
            if range.jumpTo == switch.name then
                if opcode == "<" then
                    if range[xmas][2] < compareValue then
                        range.jumpTo = nextSwitch
                        queueInsert(switchTable[nextSwitch])
                    elseif range[xmas][1] < compareValue and compareValue <= range[xmas][2] then
                        local newRange = rangeCopy(range)
                        newRange.jumpTo = nextSwitch

                        newRange[xmas][2] = compareValue - 1
                        range[xmas][1] = compareValue

                        rangeTable[#rangeTable + 1] = newRange
                        queueInsert(switchTable[nextSwitch])
                    end
                elseif opcode == ">" then
                    if range[xmas][1] > compareValue then
                        range.jumpTo = nextSwitch
                        queueInsert(switchTable[nextSwitch])
                    elseif range[xmas][1] <= compareValue and compareValue < range[xmas][2] then
                        local newRange = rangeCopy(range)
                        newRange.jumpTo = nextSwitch

                        range[xmas][2] = compareValue
                        newRange[xmas][1] = compareValue + 1

                        rangeTable[#rangeTable + 1] = newRange
                        queueInsert(switchTable[nextSwitch])
                    end
                elseif opcode == true then
                    range.jumpTo = nextSwitch
                    queueInsert(switchTable[nextSwitch])
                end
            end
        end
    end
end

local xmasKey = { "x", "m", "a", "s" }
local sum = 0
for _, value in ipairs(rangeTable) do
    if value.jumpTo == "A" then
        local tmp = 1
        for _, k in ipairs(xmasKey) do
            tmp = tmp * (value[k][2] - value[k][1] + 1)
        end
        sum = sum + tmp
    end
end
io.write(string.format("%.f", sum))
