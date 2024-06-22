local instruction = {
    ["<"] = function(xmas, compareValue)
        return function(xmasTable)
            return xmasTable[xmas] < compareValue
        end
    end,
    [">"] = function(xmas, compareValue)
        return function(xmasTable)
            return xmasTable[xmas] > compareValue
        end
    end
}
local switchTable = {
    ["A"] = true,
    ["R"] = false,
}

local sum = 0
local state = false
for line in io.lines("input.txt") do
    if line == '' then
        state = true
    elseif state == false then
        local switchName = string.match(line, "^(%a+){")
        local switch = {}

        local count = 1
        for xmas, opcode, compareValue, nextSwitch in string.gmatch(line, "(%a+)([><])(%d+):(%a+),") do
            switch[count] = { instruction[opcode](xmas, tonumber(compareValue)), nextSwitch }
            count = count + 1
        end
        local theElse = string.match(line, ",(%a+)}$")
        switch[count] = { function(_) return true end, theElse }

        switchTable[switchName] = switch
    elseif state == true then
        local xmasTable = {}
        for name, value in string.gmatch(line, "(%a)=(%d+)") do
            xmasTable[name] = tonumber(value)
        end

        local switchCase = switchTable["in"]
        while type(switchCase) ~= "boolean" do
            for _, compareFunction in ipairs(switchCase) do
                if compareFunction[1](xmasTable) then
                    switchCase = switchTable[compareFunction[2]]
                    break
                end
            end
        end

        if switchCase then
            sum = sum + xmasTable.x + xmasTable.m + xmasTable.a + xmasTable.s
        end
    end
end

print(sum)
