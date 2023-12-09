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

for line in io.lines("input.txt") do
    if count == 1 then
        sequence = line
        count = count + 1
    elseif count == 2 then
        count = count + 1
    else
        local node, nodeLeft, nodeRight = line:match("^(%w+) = %((%w+), (%w+)%)$")
        graph[node] = { ["name"] = node, ["L"] = nodeLeft, ["R"] = nodeRight }
    end
end

local pointer = graph["AAA"]
count = 0
while pointer["name"] ~= "ZZZ" do
    for _, s in substr(sequence) do
        pointer = graph[pointer[s]]
        count = count + 1
    end
end

print(count)
