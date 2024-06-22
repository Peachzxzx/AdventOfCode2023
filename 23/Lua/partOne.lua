local map = {}
local count = 1
for line in io.lines("input.txt") do
    map[count] = {}
    for i = 1, #line do
        map[count][i] = { string.sub(line, i, i), -1 }
    end
    count = count + 1
end

local sc, ec
local sr, er = 1, #map
for j = 1, #map[1] do
    if map[sr][j][1] == '.' then
        sc = j
    end
    if map[er][j][1] == '.' then
        ec = j
    end
end

local function copyTable(x)
    local r = {}
    for k, v in ipairs(x) do
        r[k] = v
    end
    return r
end

local queue = { { sr, sc, 0, {} } }
local dir = { { -1, 0, "^" }, { 0, 1, ">" }, { 1, 0, "v" }, { 0, -1, "<" } }
while #queue > 0 do
    local r, c, dis, visited = unpack(table.remove(queue, 1))
    for _, v in ipairs(visited) do
        if v[1] == r and v[2] == c then
            goto continue
        end
    end
    visited[#visited + 1] = { r, c }
    local nd = dis + 1
    for _, d in ipairs(dir) do
        local dr, dc, h = unpack(d)
        local nr = r + dr
        local nc = c + dc
        if map[nr] and map[nr][nc] and map[nr][nc][2] < dis and (map[nr][nc][1] == "." or map[nr][nc][1] == h) then
            local nv = copyTable(visited)
            queue[#queue + 1] = { nr, nc, nd, nv }
            map[nr][nc][2] = nd
        end
    end
    ::continue::
end

print(map[er][ec][2])
