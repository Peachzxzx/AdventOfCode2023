local sum = 0
for line in io.lines("input.txt") do
    local x, y = line:match("Game%s(%d+):%s(.*)")
    local bag = { ["red"] = 0, ["blue"] = 0, ["green"] = 0 }
    for i, j in y:gmatch("(%d+)%s(%a+),?%s?") do
        if (tonumber(i) > bag[j]) then
            bag[j] = tonumber(i)
        end
    end
    sum = sum + (bag["red"] * bag["green"] * bag["blue"])
end
print(sum)
