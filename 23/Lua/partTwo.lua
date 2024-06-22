local map = {}
local seen = {}
local count = 1
for line in io.lines("input.txt") do
    map[count] = {}
    seen[count] = {}
    for i = 1, #line do
        map[count][i] = string.sub(line, i, i)
        seen[count][i] = false
    end
    count = count + 1
end

local sc, ec
local sr, er = 1, #map
for j = 1, #map[1] do
    if map[sr][j] == '.' then
        sc = j
    end
    if map[er][j] == '.' then
        ec = j
    end
end

local dir = { { -1, 0, "^" }, { 0, 1, ">" }, { 1, 0, "v" }, { 0, -1, "<" } }
local vertex = { { sr, sc }, { er, ec } }
local adj = { [sr] = { [sc] = {} }, [er] = { [ec] = {} } }
for r, col in ipairs(map) do
    for c, _ in ipairs(col) do
        if map[r][c] ~= "." then
            goto continue
        end

        local count = 0
        for _, dd in ipairs(dir) do
            local dr, dc = unpack(dd, 1, 2)
            if map[r + dr] and map[r + dr][c + dc] and map[r + dr][c + dc] ~= '#' then
                count = count + 1
            end
        end

        if count > 2 then
            vertex[#vertex + 1] = { r, c }
            if adj[r] == nil then
                adj[r] = {}
            end
            adj[r][c] = {}
        end

        ::continue::
    end
end

for _, v in ipairs(vertex) do
    local r, c = unpack(v)
    for _, d in ipairs(dir) do
        local dr, dc = unpack(d)
        local nr, nc = r + dr, c + dc

        if map[nr] == nil or map[nr][nc] == nil or map[nr][nc] == '#' then
            goto continue
        end

        local pr, pc = r, c
        local ed = 1
        repeat
            for _, vv in ipairs(vertex) do
                if vv[1] == nr and vv[2] == nc then
                    adj[r][c][#adj[r][c] + 1] = { nr, nc, ed }
                    goto continue
                end
            end

            ed = ed + 1
            for _, dd in ipairs(dir) do
                if (pr ~= nr + dd[1] or pc ~= nc + dd[2]) and map[nr + dd[1]] and map[nr + dd[1]][nc + dd[2]] and map[nr + dd[1]][nc + dd[2]] ~= "#" then
                    pr, pc = nr, nc
                    nr, nc = nr + dd[1], nc + dd[2]
                    break
                end
            end
        until false

        ::continue::
    end
end

local sol = 0
local function dfs(r, c, d)
    if r == er and c == ec then
        if sol < d then
            sol = d
        end
        return
    end

    seen[r][c] = true
    for _, v in ipairs(adj[r][c]) do
        local nr, nc, ed = unpack(v)
        if seen[nr][nc] == false then
            dfs(nr, nc, d + ed)
        end
    end
    seen[r][c] = false
end

dfs(sr, sc, 0)
print(sol)
