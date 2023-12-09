local sum = 0
local x = {}
for line in io.lines("input.txt") do
    local cardNum, winningNumbers, checkingNumbers = line:match("^Card%s+(%d+):%s(.*)%s|%s(.*)$")
    local cardNumber = tonumber(cardNum)
    if x[cardNumber] == nil then
        x[cardNumber] = 1
    else
        x[cardNumber] = x[cardNumber] + 1
    end
    local winningNumberList = {}
    local count = 0
    for winningNumber in winningNumbers:gmatch("%d+") do
        winningNumberList[winningNumber] = true
    end
    for checkingNumber in checkingNumbers:gmatch("%d+") do
        if winningNumberList[checkingNumber] then
            count = count + 1
        end
    end
    for ads = cardNumber + 1, cardNumber + count, 1 do
        if x[ads] == nil then
            x[ads] = 0
        end
        x[ads] = x[ads] + 1 * x[cardNumber]
    end
    -- sum = sum + (count > 0 and 2 ^ (count - 1) or count) * x[cardNumber]
end
local ss = 0
for i, v in ipairs(x) do
    print(i, v)
    sum = sum + v
end
print(sum)
