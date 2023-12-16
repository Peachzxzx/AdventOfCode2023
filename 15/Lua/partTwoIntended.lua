local file = io.open("input.txt")
local line = file:read()
file:close()

local hashMap = {}
for seq in string.gmatch(line, "([^,]+)") do
    local label, opcode, focalLength = string.match(seq, "^(%a+)(%-?=?)(%d*)$")

    local hashValue = 0
    for _, asciiNumber in ipairs { string.byte(label, 1, #label) } do
        hashValue = ((hashValue + asciiNumber) * 17) % 256
    end
    hashValue = hashValue + 1

    if hashMap[hashValue] == nil then
        hashMap[hashValue] = {}
    end

    if opcode == "-" then
        for index, item in ipairs(hashMap[hashValue]) do
            if item[1] == label then
                table.remove(hashMap[hashValue], index)
                break
            end
        end
    elseif opcode == "=" then
        for _, item in ipairs(hashMap[hashValue]) do
            if item[1] == label then
                item[2] = focalLength
                goto continue
            end
        end

        hashMap[hashValue][#hashMap[hashValue] + 1] = { label, focalLength }
    end

    ::continue::
end

local sum = 0
for hashMapIndex, list in pairs(hashMap) do
    for listIndex, item in ipairs(list) do
        sum = sum + hashMapIndex * listIndex * item[2]
    end
end

print(sum)
