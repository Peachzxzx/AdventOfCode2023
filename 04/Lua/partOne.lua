local sum = 0
for line in io.lines("input.txt") do
    local winningCards, ownedCards = line:match("^.*:%s(.*)%s|%s(.*)$")
    local winningCardList = {}
    local count = 0
    for winningCard in winningCards:gmatch("%d+") do
        winningCardList[winningCard] = true
    end
    for ownedCard in ownedCards:gmatch("%d+") do
        if winningCardList[ownedCard] then
            count = count + 1
        end
    end
    sum = sum + (count > 0 and 2 ^ (count - 1) or count)
end
print(sum)
