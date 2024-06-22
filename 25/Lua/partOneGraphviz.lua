local vertex = {}
local adj = {}
local seen = {}
local file = io.open("gviz.txt", "w")
file:write(tostring("graph G {\n"))
for line in io.lines("input.txt") do
    local v, vAdj = string.match(line, "^(%a+):(.+)$")
    if adj[v] == nil then
        adj[v] = {}
    end
    vertex[#vertex + 1] = v
    for w in string.gmatch(vAdj, "(%a+)") do
        adj[v][w] = true
        seen[v] = false
        if adj[w] == nil then
            adj[w] = {}
        end
        adj[w][v] = true
        seen[w] = false
        file:write(tostring(v .. " -- " .. w .. ";\n"))
        vertex[#vertex + 1] = w
    end
end
file:write(tostring("}"))
file:close()
local ans = io.read()
local cut = {}
for node1, node2 in string.gmatch(ans, "(%a%a%a)%s*,%s*(%a%a%a+)") do
    cut[#cut + 1] = { node1, node2 }
end
for i = 1, 3 do
    adj[cut[i][1]][cut[i][2]] = nil
    adj[cut[i][2]][cut[i][1]] = nil
end
local queue = { vertex[1] }
local count1, count2 = 0, 0
while #queue > 0 do
    local v = table.remove(queue, 1)
    if seen[v] then
        goto continue
    end
    seen[v] = true
    count1 = count1 + 1
    for w, _ in pairs(adj[v]) do
        queue[#queue + 1] = w
    end
    ::continue::
end
local queue = { unpack(vertex, 2) }
while #queue > 0 do
    local v = table.remove(queue, 1)
    if seen[v] then
        goto continue
    end
    seen[v] = true
    count2 = count2 + 1
    for w, _ in pairs(adj[v]) do
        queue[#queue + 1] = w
    end
    ::continue::
end
print(count1 * count2)
