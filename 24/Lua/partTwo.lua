local hailStorm = {}
for line in io.lines("input.txt") do
    local x, y, z, _, _, _ = string.match(line, "^(-?%d+),%s+(-?%d+),%s+(-?%d+)%s+@%s+(-?%d+),%s+(-?%d+),%s+(-?%d+)$")

    local h = { tonumber(x), tonumber(y), tonumber(z) }
    hailStorm[#hailStorm + 1] = h
end

local hailPositionSumCount = {}
for _, hail in ipairs(hailStorm) do
    local sum = 0
    for _, val in ipairs(hail) do
        sum = sum + val
    end
    hailPositionSumCount[sum] = hailPositionSumCount[sum] and hailPositionSumCount[sum] + 1 or 1
end

for sum, count in pairs(hailPositionSumCount) do
    if count > 1 then
        io.write(string.format("%0.f", sum))
    end
end
