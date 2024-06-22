local map = {}
local sr, sc
local count = 0
local unpack = table.unpack or unpack

for line in io.lines("input.txt") do
    count = count + 1
    map[count] = {}
    for i = 1, #line do
        map[count][i] = { string.sub(line, i, i), nil }
        if map[count][i][1] == "S" then
            sr, sc = count, i
        end
    end
end

local stepLimit = 64
local dir = { { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 } }
local queue = { { sr, sc, 0 } }
while #queue > 0 do
    local stepData = table.remove(queue, 1)
    local r, c, step = unpack(stepData)
    if step == stepLimit + 1 then
        break
    end
    for _, d in ipairs(dir) do
        local nr, nc = r + d[1], c + d[2]
        if map[nr]
            and map[nr][nc]
            and map[nr][nc][2] == nil
            and (
                map[nr][nc][1] == "."
                or map[nr][nc][1] == "S"
            )
        then
            map[nr][nc][2] = (step % 2) == 1
            queue[#queue + 1] = { nr, nc, step + 1 }
        end
    end
end

local sum = 0
for _, row in ipairs(map) do
    for _, cell in ipairs(row) do
        if cell[2] then
            sum = sum + 1
        end
    end
end
print(sum)
