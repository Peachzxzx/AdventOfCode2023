local file = io.open("input.txt")
local line = file:read()
file:close()

local hashMap = {}
local fastMap = {}
for seq in string.gmatch(line, "([^,]+)") do
    local label, opcode, focalLength = string.match(seq, "^(%a+)(%-?=?)(%d*)$")

    local hashValue = 0
    for _, asciiNumber in ipairs { string.byte(label, 1, #label) } do
        hashValue = ((hashValue + asciiNumber) * 17) % 256
    end
    hashValue = hashValue + 1

    if opcode == "-" then
        if fastMap[label] then
            table.remove(hashMap[hashValue], fastMap[label][2])
            fastMap[label] = nil

            for key, value in pairs(hashMap[hashValue]) do
                fastMap[value][2] = key
            end
        end
    elseif opcode == "=" then
        if fastMap[label] then
            hashMap[fastMap[label][1]][fastMap[label][2]] = label
            fastMap[label][3] = focalLength
        else
            if hashMap[hashValue] == nil then
                hashMap[hashValue] = {}
            end

            hashMap[hashValue][#hashMap[hashValue] + 1] = label
            fastMap[label] = { hashValue, #hashMap[hashValue], focalLength }
        end
    end
end

local sum = 0
for _, item in pairs(fastMap) do
    sum = sum + item[1] * item[2] * tonumber(item[3])
end

print(sum)
