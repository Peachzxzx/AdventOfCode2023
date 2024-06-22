---@type table<string, table<string, boolean>>
local adjSet = {}
for line in io.lines("input.txt") do
    local v, vAdj = string.match(line, "^(%a+):(.+)$")
    if adjSet[v] == nil then
        adjSet[v] = {}
    end
    for w in string.gmatch(vAdj, "(%a+)") do
        adjSet[v][w] = true
        if adjSet[w] == nil then
            adjSet[w] = {}
        end
        adjSet[w][v] = true
    end
end

-- https://github.com/joshackland/advent_of_code/blob/834d685699eec688e17a0f9e608767d2f88498cd/2023/python/25.py

---@type table<string, boolean>
local nodeGroup = {}
local allNodeCount = 0
for node, _ in pairs(adjSet) do
    nodeGroup[node] = true
    allNodeCount = allNodeCount + 1
end

---@return integer
local countRemainingEdgeInNodeGroup = function(node)
    local sum = 0
    for key, _ in pairs(adjSet[node]) do
        if not nodeGroup[key] then
            sum = sum + 1
        end
    end
    return sum
end

---@return integer
local countAllRemainingEdgeInNodeGroup = function()
    local sum = 0
    for node, _ in pairs(nodeGroup) do
        sum = sum + countRemainingEdgeInNodeGroup(node)
    end
    return sum
end

while countAllRemainingEdgeInNodeGroup() ~= 3 do
    local maxRemoveEdgeNode = nil
    local maxRemoveEdgeCount = -1
    for node, _ in pairs(nodeGroup) do
        local removeEdgeCount = countRemainingEdgeInNodeGroup(node)
        if removeEdgeCount > maxRemoveEdgeCount then
            maxRemoveEdgeCount = removeEdgeCount
            maxRemoveEdgeNode = node
        end
    end

    nodeGroup[maxRemoveEdgeNode] = nil
end

local s = 0
for _, _ in pairs(nodeGroup) do
    s = s + 1
end

print((allNodeCount - s) * s)
