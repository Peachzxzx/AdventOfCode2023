local sum = 0
for line in io.lines("input.txt") do
    local x, y = line:match("Game%s(%d+):%s(.*)")
    local bag = { ["red"] = 0, ["blue"] = 0, ["green"] = 0 }
    for i, j in y:gmatch("(%d+)%s(%a+),?%s?") do
        if (tonumber(i) > bag[j]) then
            bag[j] = tonumber(i)
        end
    end
    if (bag["red"] <= 12 and bag["green"] <= 13 and bag["blue"] <= 14) then
        sum = sum + tonumber(x)
    end
end
print(sum)
