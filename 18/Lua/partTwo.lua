local instruction = {}
local count = 1
local unpack = table.unpack or unpack
for line in io.lines("input.txt") do
    instruction[count] = { string.match(line, "^(%a+) (%d+) %(#(%x+)%)$") }
    count = count + 1
end
local r, c = 1e2, 1e2

local point = {}
local mm = { [3] = { -1, 0 }, [2] = { 0, -1 }, [1] = { 1, 0 }, [0] = { 0, 1 } }
for index, value in ipairs(instruction) do
    local _, _, ins = unpack(value)

    local distance, opcode = string.match(ins, '^(%x%x%x%x%x)(%x)$')
    distance = tonumber(distance, 16)
    opcode = tonumber(opcode)
    local dr, dc = unpack(mm[opcode])

    r, c = r + dr * distance, c + dc * distance
    point[#point + 1] = { r, c }
end

point[#point + 1] = point[1]
local s = 0
local tt = 0
local ddd = 0
for i = #point, 2, -1 do
    local a = point[i][2] * point[i - 1][1] -- cross x1y2
    local b = point[i][1] * point[i - 1][2] -- cross x2y1
    local shoelace = b - a
    local c = point[i][1] - point[i - 1][1] -- distance of x
    local d = point[i][2] - point[i - 1][2] -- distance of y
    local diameter = math.abs(c) + math.abs(d)
    s = s + (math.abs(c) + math.abs(d))
    s = s + (b - a)
    tt = tt + shoelace
    ddd = ddd + diameter
end
-- A = i + b / 2 -1
-- A - b / 2 + 1 = i

s = s / 2 + 1
io.write(string.format("%.f", s))
