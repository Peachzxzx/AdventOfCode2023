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

local count = 1
local sequence
local graph = {}
local queue = {}

for line in io.lines("input.txt") do
    if count == 1 then
        sequence = line
        count = count + 1
    elseif count == 2 then
        count = count + 1
    else
        local node, nodeLeft, nodeRight = line:match("^(%w+) = %((%w+), (%w+)%)$")
        graph[node] = { ["name"] = node, ["L"] = nodeLeft, ["R"] = nodeRight }
        if node:sub(#node, #node) == "A" then
            queue[#queue + 1] = { ["start"] = node, ["current"] = node }
        end
    end
end


local function gcd(a, b)
    if b == 0 then
        return a
    end
    return gcd(b, a % b)
end

local function lcm(a, b)
    return a / gcd(a, b) * b
end

local AtoZ = {}
local ZtoZ = {}
count = 0

for ind, selectedNode in ipairs(queue) do
    count = 0
    local zloop = 0
    while zloop < 2 do
        for _, s in substr(sequence) do
            selectedNode["current"] = graph[graph[selectedNode["current"]][s]]["name"]
            count = count + 1
            if selectedNode["current"]:sub(#selectedNode["current"], #selectedNode["current"]) == "Z" then
                zloop = zloop + 1
                if zloop == 1 then
                    AtoZ[ind] = count
                    count = 0
                elseif zloop == 2 then
                    ZtoZ[ind] = count
                    break
                end
            end
        end
    end
end

local res = 1
for _, value in ipairs(ZtoZ) do
    res = lcm(res, value)
end

print(res)
