local function solve(sequence)
    if #sequence == 1 then
        return sequence[1]
    end
    local nextSequence = {}
    local countZero
    if sequence[1] == 0 then
        countZero = 1
    else
        countZero = 0
    end
    for index = 2, #sequence do
        if sequence[index] == 0 then
            countZero = countZero + 1
        end
        nextSequence[#nextSequence + 1] = sequence[index] - sequence[index - 1]
    end
    if countZero == #sequence then
        return 0
    end
    return sequence[1] - solve(nextSequence)
end

local sum = 0
for line in io.lines("input.txt") do
    local sequence = {}
    for number in line:gmatch("(-?%d+)") do
        sequence[#sequence + 1] = tonumber(number)
    end
    sum = sum + solve(sequence)
end
print(sum)
