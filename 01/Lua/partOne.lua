local first
local last
local sum = 0

for line in io.lines("input.txt") do
    first = nil
    for number in line:gmatch("%d") do
        if first == nil then
            first = number
        end
        last = number
    end
    sum = sum + tonumber(first .. last)
end

print(sum)
