local file = io.open("input.txt")
local line = file:read()
file:close()

local sum = 0
for seq in string.gmatch(line, "([^,]+)") do
    local hashValue = 0
    for _, asciiNumber in ipairs { string.byte(seq, 1, #seq) } do
        hashValue = ((hashValue + asciiNumber) * 17) % 256
    end

    sum = sum + hashValue
end

print(sum)
