local first
local last
local sum = 0

for line in io.lines("input.txt") do
    first = nil
    for i = 1, #line, 1 do
        local subline = line:sub(i, #line)
        local number = nil
        if tonumber(subline:sub(1, 1)) then
            number = tonumber(subline:sub(1, 1))
        elseif subline:sub(1, 3) == "one" then
            number = 1
        elseif subline:sub(1, 3) == "two" then
            number = 2
        elseif subline:sub(1, 5) == "three" then
            number = 3
        elseif subline:sub(1, 4) == "four" then
            number = 4
        elseif subline:sub(1, 4) == "five" then
            number = 5
        elseif subline:sub(1, 3) == "six" then
            number = 6
        elseif subline:sub(1, 5) == "seven" then
            number = 7
        elseif subline:sub(1, 5) == "eight" then
            number = 8
        elseif subline:sub(1, 4) == "nine" then
            number = 9
        end
        if number then
            if first == nil then
                first = number
            end
            last = number
        end
    end
    sum = sum + tonumber(first .. last)
end

print(sum)
