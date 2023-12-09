local allHands = {}
local cardValueMap = {
    ["2"] = 2,
    ["3"] = 3,
    ["4"] = 4,
    ["5"] = 5,
    ["6"] = 6,
    ["7"] = 7,
    ["8"] = 8,
    ["9"] = 9,
    ["T"] = 10,
    ["J"] = 1,
    ["Q"] = 12,
    ["K"] = 13,
    ["A"] = 14
}

local valueCardMap = {
    [2] = "2",
    [3] = "3",
    [4] = "4",
    [5] = "5",
    [6] = "6",
    [7] = "7",
    [8] = "8",
    [9] = "9",
    [10] = "T",
    [1] = "J",
    [12] = "Q",
    [13] = "K",
    [14] = "A",
}

local function substr(s)
    local index = 1
    local endIndex = s:len()
    return function()
        if index > endIndex then
            return nil
        end
        local character = string.sub(s, index, index)
        index = index + 1
        return index - 1, character
    end
end

local function handType(cards)
    local result = { "", "", "", "", "" }
    local mostCardInHandStrength = 0
    local mostCardInHand
    for i = 2, #valueCardMap do
        if i == 11 then
        elseif cards[valueCardMap[i]] >= mostCardInHandStrength then
            mostCardInHandStrength = cards[valueCardMap[i]]
            mostCardInHand = valueCardMap[i]
        end
    end
    for key, val in pairs(cards) do
        local value = val
        if key == "J" then
            goto continue
        end
        if mostCardInHand == key then
            value = value + cards["J"]
        end
        if value == 0 then
        elseif value == 5 then
            result[5] = key
        elseif value == 4 then
            result[4] = key
        elseif value == 3 then
            result[3] = key
        elseif value == 2 then
            if result[2] ~= "" then
                if cardValueMap[result[2]] > cardValueMap[key] then
                    result[2] = result[2] .. key
                else
                    result[2] = key .. result[2]
                end
            else
                result[2] = key
            end
        else
            if result[1] == "" then
                result[1] = key
            else
                local tempString = {}
                local temp
                local charaterPointer = key

                for _, s in substr(result[1]) do
                    tempString[#tempString + 1] = s
                end
                for index, value in ipairs(tempString) do
                    if cardValueMap[charaterPointer] > cardValueMap[value] then
                        temp = tempString[index]
                        tempString[index] = charaterPointer
                        charaterPointer = temp
                    end
                end
                tempString[#tempString + 1] = charaterPointer
                result[1] = table.concat(tempString)
            end
        end
        ::continue::
    end
    if result[5]:len() > 0 then
        result[6] = 7
        result[7] = 5
    elseif result[4]:len() > 0 then
        result[6] = 6
        result[7] = 4
    elseif result[3]:len() == 1 and result[2]:len() == 1 then
        result[6] = 5
        result[7] = 3
    elseif result[3]:len() == 1 then
        result[6] = 4
        result[7] = 3
    elseif result[2]:len() == 2 then
        result[6] = 3
        result[7] = 2
    elseif result[2]:len() == 1 then
        result[6] = 2
        result[7] = 2
    else
        result[6] = 1
        result[7] = 1
    end
    return result
end

for line in io.lines("input.txt") do
    local hands, bit = line:match("^(.+)%s(%d+)%s*$")
    local countTa = {
        ["2"] = 0,
        ["3"] = 0,
        ["4"] = 0,
        ["5"] = 0,
        ["6"] = 0,
        ["7"] = 0,
        ["8"] = 0,
        ["9"] = 0,
        ["T"] = 0,
        ["J"] = 0,
        ["Q"] = 0,
        ["K"] = 0,
        ["A"] = 0
    }
    for _, card in substr(hands) do
        countTa[card] = countTa[card] + 1
    end

    allHands[#allHands + 1] = { ["hands"] = hands, ["bit"] = bit, ["type"] = handType(countTa) }
end

table.sort(
    allHands,
    function(a, b)
        if a["type"][6] < b["type"][6] then
            return true
        end
        if a["type"][6] == b["type"][6] then
            local x = a["hands"]
            local y = b["hands"]
            for indd = 1, #x do
                if cardValueMap[x:sub(indd, indd)] < cardValueMap[y:sub(indd, indd)] then
                    return true
                elseif cardValueMap[x:sub(indd, indd)] > cardValueMap[y:sub(indd, indd)] then
                    return false
                end
            end
        end
        return false
    end
)

local sum = 0
for index, head in ipairs(allHands) do
    sum = sum + (index * head["bit"])
end
print(sum)
